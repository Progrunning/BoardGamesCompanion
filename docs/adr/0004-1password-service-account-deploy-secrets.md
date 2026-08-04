# Inject Search API runtime secrets via `op run --env-file`, not `op run --environment`

ADR-0001 commits to pulling runtime secrets (Mongo connection string, API key(s), BGG API key) from 1Password at `docker compose up` time on the Hetzner server, authenticated as a 1Password service account scoped to a `bgc` vault, with no secret ever written to disk. This spike (issue #322) researched which of the 1Password CLI's two "inject secrets into a process environment" mechanisms — `op run --environment <id>` (1Password Environments) or `op run --env-file <file>` with `op://vault/item/field` references — actually works under pure service-account, non-interactive auth, since that's the only auth mode available on an unattended server.

**Recommendation: `op run --env-file` with `op://` secret references.** `--environment` is rejected.

## Status

proposed — unverified against real infrastructure (see Verification below).

## Why `--env-file` and not `--environment`

- **`--environment` is a beta feature, not a stable one.** 1Password's own docs (`developer.1password.com/docs/environments/read-environment-variables`, redirects to `1password.dev/environments/read-environment-variables`) state it requires "the latest beta build of 1Password CLI, version `2.33.0-beta.02` or later." Pinning a production deploy pipeline to a beta CLI build is itself a risk the spec doesn't ask us to take on.
- **Service-account auth against Environments has open, unresolved failure reports.** A 1Password Community thread ("1Password CLI Bug Report: Service Account Cannot Read Environments") documents `op run --environment` / `op environment read` failing with `[ERROR] Environment was not found` when authenticated via `OP_SERVICE_ACCOUNT_TOKEN`, even though the same Environment ID works fine under desktop-app (interactive) auth. Community reverse-engineering traced it to the CLI treating the environment ID as a vault ID and getting a 403 from `/api/v3/vault/{id}`. The workaround found was re-scoping the service account's vault access at creation time — i.e. the feature works, but only after non-obvious, under-documented configuration, on a beta code path, with no official 1Password acknowledgement in the thread. That's not a foundation for an unattended CD pipeline.
- **`--env-file` is stable, GA, and explicitly documented for service accounts.** `op run --env-file="./prod.env" -- <command>` is part of the stable CLI (`developer.1password.com/docs/cli/secrets-environment-variables`, redirects to `1password.dev/cli/secrets-environment-variables`), and the docs state plainly: "Automate access with a service account token. Service accounts support both secret references and 1Password Environments" — secret references being the `op://vault/item/field` syntax used in env files. There is no beta gate and no reported service-account-specific breakage.
- **The "no secret touches disk" requirement holds either way, but `--env-file` makes it obvious.** The file on disk contains only `op://` references (e.g. `MongoDbSettings__ConnectionString=op://bgc/search-api/mongo-connection-string`), never resolved values. `op run` resolves them in-memory and injects them into the child process's environment for the duration of that process only. Same guarantee `--environment` would provide, but backed by a stable, well-trodden code path instead of a beta one with known service-account edge cases.

## Decision

- Provision a 1Password service account scoped read-only to a `bgc` vault. No other vaults, no write access.
- Store the account's token on the Hetzner server only, in a file at a fixed path, mode `0400`, owned by the deploy user (e.g. `/opt/bgc/secrets/op-service-account-token`, `chmod 400`, `chown bgc-deploy:bgc-deploy`). The token never lives in GitHub, in the repo, or in any CI log.
- Keep a checked-in, secret-free template env file (e.g. `backend/.env.prod.op-template`, not yet created by this spike — see Follow-ups) containing only `op://bgc/<item>/<field>` references for the three runtime secrets, following the naming already established by `pipelines/templates/update_container_secrets.yaml` (`mongodb-connection`, `api-key`, `bgg-api-key`) mapped onto the settings keys ASP.NET Core actually binds (`MongoDbSettings:ConnectionString`, `ApiKeyAuthenticationSettings:ApiKey`, `BggSettings:ApiKey` — confirmed against the real settings classes in #323/#324).
- Wrap the deploy's `docker compose up` in `op run --env-file <template> -- docker compose ... up -d`, with `OP_SERVICE_ACCOUNT_TOKEN` read from the owner-read-only file into the deploy shell's environment (not hardcoded, not logged).
- A reference wrapper implementing this is at `deploy/1password/verify-op-run.sh` — see that file's header comment for prerequisites. It is not wired into the real deploy workflow yet; it exists so a human with real 1Password access can run the actual verification this spike could not perform.

## Consequences

- The deploy workflow's only 1Password-specific logic is: load `OP_SERVICE_ACCOUNT_TOKEN` from the owner-read-only file, then prefix the existing `docker compose up` invocation with `op run --env-file <file> --`. No SDK, no extra service, no beta CLI channel to track.
- `docker compose config` (which resolves `env_file` entries and prints the effective config) becomes the verification surface: run it under `op run` to confirm secrets resolve, without ever starting the real containers or writing secrets to disk.
- If 1Password ships Environments as GA with confirmed service-account support in the future, this decision can be revisited — the env-file approach doesn't preclude switching later, it's just what's provably supported today.
- The env-file template is a new file this spike does not create (it would need a real vault layout and item names to be meaningful); implementing ADR-0001's deploy workflow needs to add it alongside the actual `docker-compose.prod.yml`.

## Verification — NOT DONE, must be completed against real infrastructure

This spike had no SSH access to the Hetzner server, no real 1Password account, and no service-account token. Nothing in this ADR has been executed against real 1Password infrastructure. Everything above is a recommendation derived from reading 1Password's official developer docs and public community bug reports, not a confirmed result.

To actually close this spike out, a human with the necessary access needs to:

1. Create a 1Password service account scoped to (only) a `bgc` vault, with read access to the three items (Mongo connection string, API key, BGG API key).
2. Provision the resulting token on the target Hetzner server as an owner-read-only file (e.g. `sudo install -m 400 -o bgc-deploy -g bgc-deploy /dev/stdin /opt/bgc/secrets/op-service-account-token`).
3. Create the real `op://bgc/<item>/<field>` env-file template with the actual vault/item/field names chosen in the vault.
4. Run `deploy/1password/verify-op-run.sh` (or the equivalent `op run --env-file ... -- docker compose config` invocation) on that server and confirm all three secrets resolve to non-empty values in the printed config, with no `[ERROR]` from `op`.
5. Confirm no secret value appears anywhere on disk afterwards (`grep` the env-file template itself — it should still show only `op://` references — and check shell history / process list for accidental exposure).
6. Only after (4) and (5) pass, wire the pattern into the real GitHub Actions deploy workflow and mark this ADR's Status as `accepted`.

## Considered options

- **`op run --environment <id>`** (rejected: beta-only CLI feature, and public reports of service-account auth failing against it with an unhelpful `Environment was not found` error; not something to build an unattended CD pipeline on)
- **1Password Connect (self-hosted secrets API)** (rejected: adds a whole extra service + its own credentials to run on the Hetzner box, for no benefit over `op run` given the deploy is already a single SSH'd shell invocation)
- **1Password SDKs (Go/Python/JS) called from a custom script instead of the CLI** (rejected: more code to write and maintain than a one-line `op run` wrapper around an unchanged `docker compose up`, for the same underlying auth model)
