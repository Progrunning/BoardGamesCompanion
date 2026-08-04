#!/usr/bin/env bash
#
# verify-op-run.sh — one-off verification for issue #322 / ADR-0004.
#
# Confirms that runtime secrets (Mongo connection string, API key, BGG API
# key) can be resolved from 1Password into the Search API's Docker Compose
# environment at `docker compose up` time, authenticated as a 1Password
# service account scoped to a "bgc" vault, WITHOUT ever writing a resolved
# secret to disk.
#
# This script has never been run against real 1Password infrastructure — it
# was written by an agent with no service-account token and no server access
# (see docs/adr/0004-1password-service-account-deploy-secrets.md). It is a
# ready-to-run reference for a human who has both.
#
# Prerequisites (all one-time, done by a human, not by this script):
#   1. A 1Password service account exists, scoped read-only to the "bgc"
#      vault, with access to the three secret items referenced below.
#   2. The service account's token is provisioned on THIS server as an
#      owner-read-only file, e.g.:
#        sudo install -m 400 -o "$(whoami)" -g "$(whoami)" \
#          /dev/stdin /opt/bgc/secrets/op-service-account-token <<< "$TOKEN"
#      Never put the token in this repo, in shell history, or in a CI log.
#   3. The 1Password CLI (`op`) is installed on this server:
#        https://developer.1password.com/docs/cli/get-started/
#   4. An env-file exists with op:// references for the three secrets (not
#      the secrets themselves) — see ENV_FILE below for the expected shape.
#   5. Docker and Docker Compose are installed, and backend/docker-compose.yml
#      (or its production equivalent) is present at COMPOSE_FILE.
#
# Usage:
#   OP_TOKEN_FILE=/opt/bgc/secrets/op-service-account-token \
#   ENV_FILE=/opt/bgc/secrets/search-api.op-env \
#   COMPOSE_FILE=/opt/bgc/backend/docker-compose.prod.yml \
#     ./verify-op-run.sh
#
# What it does:
#   - Loads OP_SERVICE_ACCOUNT_TOKEN from the owner-read-only token file into
#     this shell's environment only (never echoed, never logged).
#   - Runs `op run --env-file <ENV_FILE> -- docker compose -f <COMPOSE_FILE>
#     config` — this resolves the op:// references and prints the *effective*
#     compose config with secrets injected, without starting any container
#     and without writing the resolved values anywhere.
#   - Greps the printed config for the three expected settings keys and
#     reports whether each resolved to a non-empty value.
#
# What it deliberately does NOT do:
#   - It does not start the real containers (`docker compose up`). Swap the
#     `config` subcommand for `up -d` once you're satisfied secrets resolve
#     correctly and you want to perform a real deploy.
#   - It does not print secret values to stdout/logs.

set -euo pipefail

OP_TOKEN_FILE="${OP_TOKEN_FILE:?Set OP_TOKEN_FILE to the owner-read-only service-account token file path}"
ENV_FILE="${ENV_FILE:?Set ENV_FILE to the op:// reference env-file path}"
COMPOSE_FILE="${COMPOSE_FILE:?Set COMPOSE_FILE to the docker-compose file to verify}"

# Expected settings keys (ASP.NET Core double-underscore hierarchical binding)
# that the three runtime secrets must resolve to. Adjust if the app's
# configuration section names change.
EXPECTED_KEYS=(
  "MongoDbSettings__ConnectionString"
  "ApiKeyAuthenticationSettings__ApiKeys"
  "BggSettings__ApiKey" # confirm this is the real key name during implementation
)

if [[ ! -f "$OP_TOKEN_FILE" ]]; then
  echo "ERROR: token file not found: $OP_TOKEN_FILE" >&2
  exit 1
fi

perms="$(stat -c '%a' "$OP_TOKEN_FILE" 2>/dev/null || stat -f '%Lp' "$OP_TOKEN_FILE")"
if [[ "$perms" != "400" && "$perms" != "600" ]]; then
  echo "WARNING: $OP_TOKEN_FILE has permissions $perms, expected 400/600 (owner-read-only)." >&2
fi

if ! command -v op >/dev/null 2>&1; then
  echo "ERROR: 1Password CLI ('op') is not installed or not on PATH." >&2
  exit 1
fi

# Read the token into this shell's environment only. Never write it to a
# file, never echo it, never pass it as a CLI arg (which would leak into
# process listings / shell history).
export OP_SERVICE_ACCOUNT_TOKEN
OP_SERVICE_ACCOUNT_TOKEN="$(cat "$OP_TOKEN_FILE")"

echo "Resolving secrets via 'op run --env-file' (no container will be started)..."
resolved_config="$(op run --env-file "$ENV_FILE" -- docker compose -f "$COMPOSE_FILE" config)"

missing=0
for key in "${EXPECTED_KEYS[@]}"; do
  if echo "$resolved_config" | grep -q "${key}="; then
    echo "OK: ${key} resolved to a non-empty value."
  else
    echo "MISSING: ${key} did not resolve (not present in effective compose config)." >&2
    missing=1
  fi
done

unset OP_SERVICE_ACCOUNT_TOKEN

if [[ "$missing" -ne 0 ]]; then
  echo "One or more secrets failed to resolve. See docs/adr/0004-1password-service-account-deploy-secrets.md." >&2
  exit 1
fi

echo "All expected secrets resolved via op run --env-file. Secrets were never written to disk."
echo "Next step (manual, once satisfied): swap 'docker compose ... config' for 'docker compose ... up -d' to perform a real deploy."
