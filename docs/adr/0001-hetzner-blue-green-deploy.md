# Deploy the Search API to a Hetzner server via GitHub Actions blue-green, not Azure Container Apps

The Search API used to build on Azure DevOps and deploy to Azure Container Apps (DEV → PROD). We moved to a single GitHub Actions workflow that builds, tests, and deploys straight to a standalone Hetzner server using a docker-compose blue-green cutover behind Caddy. Motivation: leave the Azure estate, cut cost and moving parts, and keep the whole deploy story in one repo — the app, its compose file, and the workflow that ships it version together.

## Consequences

- **No DEV environment.** Full CD: merge to `main` deploys to production. The safety net is the PR test/coverage gate plus the blue-green health check — a sick release never receives traffic and the deploy aborts leaving the active color untouched.
- **Releases are git SHAs.** Images are tagged with the short commit SHA and pushed to GHCR (public, like the repo). Rollback is redeploying an old SHA via manual workflow dispatch.
- **Cutover state lives in the Caddy site snippet.** The BGC repo owns `sites/bgc.caddy` on the server (imported by the RemoteServer-owned Caddyfile); rewriting it + graceful reload is the traffic flip. Caddy terminates TLS; the container speaks plain HTTP on the internal docker network.
- **Runtime secrets come from 1Password**, injected at compose-up via `op run` under a service account scoped to the bgc vault. GitHub holds only the SSH deploy key — a GitHub compromise can trigger deploys but cannot read app secrets.
- **Telemetry is self-hosted.** The app requires an OTLP endpoint at startup; a shared otel-collector + Loki + Grafana stack on the server (RemoteServer-owned) receives it. No Application Insights.
- **MongoDB stays managed for now.** Migrating it onto the Hetzner box is deliberately deferred (TODO), so the API makes an off-box round-trip per query.

## Considered options

- Stay on Azure DevOps pipelines (rejected: leaving Azure anyway; two CI systems for one repo)
- Pull-based deploys via Watchtower/Arcane (rejected: blue-green needs orchestration the puller can't express; failures invisible to the commit)
- Docker Hub (rejected in favor of GHCR: one less vendor; public image needs no registry auth on the server)
