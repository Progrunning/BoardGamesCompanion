#!/usr/bin/env bash
#
# deploy.sh — blue-green deploy of the Search API to the Hetzner server (#324,
# ADR-0001). Given an image tag (a Release, per CONTEXT.md), this script owns
# all server-side blue-green logic: pre-flight, Color detection, start the
# inactive Color, health-poll it, cut Caddy over on success, stop (not
# remove) the old Color, or roll back the new Color on failure.
#
# Run manually over SSH with nothing but the image tag:
#   ./deploy/deploy.sh <image-tag>
#
# Prerequisites on the server (see docs/adr/0004-1password-service-account-deploy-secrets.md
# and deploy/1password/verify-op-run.sh for the exact idiom this reuses):
#   - `op` (1Password CLI), `docker`, `docker compose`, `curl` on PATH.
#   - OP_SERVICE_ACCOUNT_TOKEN readable from an owner-read-only file
#     (OP_TOKEN_FILE below), scoped to the `bgc` vault.
#   - An env-file of op:// references (OP_ENV_FILE below) — never resolved
#     secret values, only op://vault/item/field lines.
#   - deploy/docker-compose.prod.yml and deploy/sites/bgc.caddy present
#     (this repo checkout, or the deployed layout — see CADDY_SNIPPET_PATH).
#   - Caddy already running on the server, importing deploy/sites/bgc.caddy
#     (or its deployed copy) into its main Caddyfile.
#
# No application secret is ever written to disk here: OP_ENV_FILE holds only
# op:// references, and `op run` resolves them straight into the child
# process's environment for that process's lifetime only.

set -euo pipefail

# ---- Configuration (overridable via env, sensible defaults for a checkout) ----

IMAGE_TAG="${1:?Usage: deploy.sh <image-tag>}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="${COMPOSE_FILE:-$SCRIPT_DIR/docker-compose.prod.yml}"

# Default assumes running from a repo checkout; on the real server this is
# overridden to the deployed snippet's actual path, e.g.
# CADDY_SNIPPET_PATH=/opt/bgc/sites/bgc.caddy (the file the main Caddyfile
# actually imports — rewriting this repo checkout's copy would not affect
# live traffic).
CADDY_SNIPPET_PATH="${CADDY_SNIPPET_PATH:-$SCRIPT_DIR/sites/bgc.caddy}"

OP_TOKEN_FILE="${OP_TOKEN_FILE:-/opt/bgc/secrets/op-service-account-token}"
OP_ENV_FILE="${OP_ENV_FILE:-/opt/bgc/secrets/search-api.op-env}"

HEALTH_CHECK_ATTEMPTS="${HEALTH_CHECK_ATTEMPTS:-30}"
HEALTH_CHECK_INTERVAL_SECONDS="${HEALTH_CHECK_INTERVAL_SECONDS:-2}"
DRAIN_PAUSE_SECONDS="${DRAIN_PAUSE_SECONDS:-5}"

# Reload mechanism: Caddy is assumed to run as a container named `caddy` on
# the same docker network, with its running config reloadable via `caddy
# reload`. If the server instead runs Caddy as a systemd unit, swap this for
# `sudo systemctl reload caddy` (or equivalent) — noted here since it's the
# one piece of this script tied to how Caddy happens to be deployed, which
# this ticket does not own.
CADDY_RELOAD_CMD="${CADDY_RELOAD_CMD:-docker exec caddy caddy reload --config /etc/caddy/Caddyfile}"

log() { echo "[deploy] $*"; }
err() { echo "[deploy] ERROR: $*" >&2; }

# ---- 1. Pre-flight: 1Password auth must work before any container is touched ----

preflight_op() {
  if [[ ! -f "$OP_TOKEN_FILE" ]]; then
    err "OP_SERVICE_ACCOUNT_TOKEN file not found: $OP_TOKEN_FILE"
    exit 1
  fi

  if ! command -v op >/dev/null 2>&1; then
    err "1Password CLI ('op') is not installed or not on PATH."
    exit 1
  fi

  if [[ ! -f "$OP_ENV_FILE" ]]; then
    err "op env-file not found: $OP_ENV_FILE"
    exit 1
  fi

  # Loaded into this shell's environment only; never echoed, never logged,
  # never passed as a CLI arg.
  export OP_SERVICE_ACCOUNT_TOKEN
  OP_SERVICE_ACCOUNT_TOKEN="$(cat "$OP_TOKEN_FILE")"

  if ! op run --env-file "$OP_ENV_FILE" -- op whoami >/dev/null 2>&1; then
    err "1Password pre-flight failed: 'op run --env-file $OP_ENV_FILE -- op whoami' did not succeed."
    err "Check OP_SERVICE_ACCOUNT_TOKEN validity and that $OP_ENV_FILE's op:// references resolve."
    exit 1
  fi

  log "1Password pre-flight OK."
}

# ---- 2. Detect Active Color from the Caddy snippet ----

detect_active_color() {
  if [[ ! -f "$CADDY_SNIPPET_PATH" ]]; then
    err "Caddy snippet not found: $CADDY_SNIPPET_PATH"
    exit 1
  fi

  local color
  color="$(grep -oP 'reverse_proxy bgc_searchapi_\K(blue|green)(?=:8080)' "$CADDY_SNIPPET_PATH" || true)"

  if [[ "$color" != "blue" && "$color" != "green" ]]; then
    err "Could not detect Active Color from $CADDY_SNIPPET_PATH (expected a line matching 'reverse_proxy bgc_searchapi_(blue|green):8080')."
    exit 1
  fi

  echo "$color"
}

inactive_color_of() {
  if [[ "$1" == "blue" ]]; then echo "green"; else echo "blue"; fi
}

# ---- 3. Start the inactive Color under op run ----

start_color() {
  local color="$1"
  log "Starting inactive Color '$color' with IMAGE_TAG=$IMAGE_TAG ..."
  IMAGE_TAG="$IMAGE_TAG" op run --env-file "$OP_ENV_FILE" -- \
    docker compose -f "$COMPOSE_FILE" up -d "bgc_searchapi_${color}"
}

stop_color() {
  local color="$1"
  log "Stopping Color '$color' (stop, not down/rm — keeps rollback possible)..."
  docker compose -f "$COMPOSE_FILE" stop "bgc_searchapi_${color}"
}

# ---- 4. Health poll ----
#
# Relies on the compose file's own healthcheck (curl against /healthz inside
# the container, mirroring the dockerfile's healthcheck) rather than reaching
# into the container over the network, since no host port is published in
# prod. `docker inspect`'s reported Health.Status is the source of truth.

wait_for_healthy() {
  local color="$1"
  local container="bgc_searchapi_${color}"
  local attempt

  for ((attempt = 1; attempt <= HEALTH_CHECK_ATTEMPTS; attempt++)); do
    local status
    status="$(docker inspect --format '{{.State.Health.Status}}' "$container" 2>/dev/null || echo "unknown")"

    if [[ "$status" == "healthy" ]]; then
      log "Color '$color' is healthy (attempt $attempt/$HEALTH_CHECK_ATTEMPTS)."
      return 0
    fi

    log "Waiting for '$color' to become healthy (attempt $attempt/$HEALTH_CHECK_ATTEMPTS, status: $status)..."
    sleep "$HEALTH_CHECK_INTERVAL_SECONDS"
  done

  return 1
}

# ---- 5. Cutover on success ----

cutover_to_color() {
  local new_color="$1"
  local old_color="$2"

  log "Cutting over: rewriting $CADDY_SNIPPET_PATH to point at '$new_color'..."
  sed -i -E "s/(reverse_proxy bgc_searchapi_)(blue|green)(:8080)/\1${new_color}\3/" "$CADDY_SNIPPET_PATH"

  log "Reloading Caddy..."
  eval "$CADDY_RELOAD_CMD"

  log "Draining old Color '$old_color' for ${DRAIN_PAUSE_SECONDS}s before stopping it..."
  sleep "$DRAIN_PAUSE_SECONDS"

  stop_color "$old_color"

  log "Cutover complete. Active Color is now '$new_color'."
}

# ---- Main ----

main() {
  preflight_op

  local active_color inactive_color
  active_color="$(detect_active_color)"
  inactive_color="$(inactive_color_of "$active_color")"

  log "Active Color: $active_color. Deploying Release '$IMAGE_TAG' to inactive Color: $inactive_color."

  start_color "$inactive_color"

  if wait_for_healthy "$inactive_color"; then
    cutover_to_color "$inactive_color" "$active_color"
  else
    err "Health check timed out after $((HEALTH_CHECK_ATTEMPTS * HEALTH_CHECK_INTERVAL_SECONDS))s for Color '$inactive_color'."
    err "Aborting: stopping '$inactive_color'. Caddy snippet and live traffic on '$active_color' are untouched."
    stop_color "$inactive_color"
    exit 1
  fi
}

main
