# Search API production cutover verification and Azure cleanup

Runbook for GitHub issue #326, the final step of the Hetzner migration (#289). This
ticket cannot be completed by an agent: its acceptance criteria require a real merge
to `main` and a real manual rollback dispatch to have actually served production
traffic, which no agent in this repo has the access (SSH key, GHCR, live server) to
perform. This document is the checklist a human runs through to close it out.

## Prerequisites

Before any of this is possible, a human must have already completed the manual setup
that earlier tickets in this migration flagged as out of their scope:

- [ ] `HETZNER_DEPLOY_SSH_KEY`, `HETZNER_SSH_HOST`, `HETZNER_SSH_USER` repo secrets exist
      (see the `deploy` job in `.github/workflows/search-api-ci.yml`, added by #325).
- [ ] The GHCR package `ghcr.io/progrunning/board-games-companion-search-api` has been
      set to public visibility after its first push (Settings → Packages → package →
      Change visibility → Public).
- [ ] A 1Password service account scoped to the `bgc` vault exists, its token is
      provisioned on the Hetzner server at the owner-read-only path `deploy.sh` expects
      (`OP_TOKEN_FILE`, default `/opt/bgc/secrets/op-service-account-token`), and the
      real `op://` env-file exists at `OP_ENV_FILE`'s path (default
      `/opt/bgc/secrets/search-api.op-env`) — see
      `docs/adr/0004-1password-service-account-deploy-secrets.md` for the exact
      verification steps (issue #322), which still need to be run for real.
- [ ] Caddy is running on the server and its main Caddyfile `import`s
      `/opt/bgc/sites/bgc.caddy` (the RemoteServer-owned prerequisite the spec
      explicitly calls out as manual, out of this repo's automation).
- [ ] The otel-collector + Loki + Grafana stack is reachable at the `OTEL_EXPORTER_OTLP_ENDPOINT`
      the compose file points at.

## Verification checklist (acceptance criteria for #326)

- [ ] **A production merge through the new workflow has served live traffic with zero
      failed requests during cutover.** Merge a real backend change to `main`, watch the
      `deploy` job succeed, and confirm the domain serves the new release (e.g. check a
      response header/timestamp, or just that `/healthz` responds) while polling it
      through the cutover window with no failed requests.
- [ ] **A manual rollback dispatch to an older tag has been exercised successfully
      against production.** Run `workflow_dispatch` on `search-api-ci.yml` with
      `image_tag` set to a previously-published short SHA, confirm the `deploy` job
      redeploys it without rebuilding/republishing (the `build-test`/`publish` jobs
      should not run), and confirm the older release is what's live afterward.

## Cleanup — only after both boxes above are checked

Once a real merge-triggered deploy and a real rollback dispatch have both succeeded
against production, delete the now-dead Azure pipeline config:

```
git rm pipelines/search_api/build_pipeline.yaml
git rm pipelines/search_api/deploy_pipeline.yaml
git rm pipelines/templates/update_container_secrets.yaml
```

`update_container_secrets.yaml` is confirmed (by repo-wide grep as of this writing) to
be referenced only from `pipelines/search_api/deploy_pipeline.yaml` — re-grep before
deleting in case something else started referencing it in the meantime:

```
grep -rn "update_container_secrets" pipelines/
```

After deletion, confirm no other dead CI config for the Search API remains (e.g. no
now-orphaned Azure DevOps service connections or variable groups referenced only by the
deleted files — those live in Azure DevOps project settings, not this repo, and are
this checklist's last manual step).
