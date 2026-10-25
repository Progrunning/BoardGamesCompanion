# Remediate a bad 1Password secret via manual config-only redeploy, not automated refresh

Runtime secrets are injected via `op run` at compose-up on the Hetzner server (ADR-0001). Because `op run` sets process env at container start, a secret rotated or corrected in 1Password after deploy has no effect until the container is recreated. We need a defined way to fix a bad or stale secret post-deploy without a host reboot or full VM restart.

This ADR covers **1Password-sourced secrets only**. Non-secret config (appsettings values, feature flags) stays baked into the image and ships through the existing git → CI → blue-green path from ADR-0001; a wrong value there is fixed by committing a correction and redeploying, or by rolling back to the prior SHA — no new process needed.

## Consequences

- **No automated secret-change detection.** No 1Password webhook/Events API integration, no polling cron. Detecting and fixing a bad secret is a manual act. Revisit only if manual remediation proves too slow in practice.
- **Remediation reuses the existing rollback trigger, pointed the other way.** ADR-0001's `workflow_dispatch` rollback (redeploy an old SHA) is reused to redeploy the *current* SHA with no image rebuild. This re-runs `op run` + `docker compose up` for the idle color, picking up the corrected secret, gated by the same health check, followed by the same Caddy cutover on success — zero downtime, no reboot.
- **Detection has two paths, both already covered by existing infrastructure:**
  - A secret that's bad enough to break startup fails the health check during a normal deploy. The workflow run shows the failure, the swap aborts, and the previously-active color keeps serving — no separate alerting needed, the deploy pipeline is the signal.
  - A secret that's superficially valid (app starts) but wrong at runtime (e.g. points at the wrong downstream target) won't fail a health check. This is only caught via the existing Grafana/Loki/otel-collector observability stack, not the deploy pipeline.
- **Failure notification stays GitHub-native.** A failed config-only redeploy is surfaced via the GitHub Actions run failure only (Actions tab / email). No new Grafana alert wiring for this case.
- **Remediation flow, end to end:** fix the value in the 1Password vault → trigger the deploy workflow via `workflow_dispatch` for the current SHA → workflow re-injects secrets and cuts over the idle color → health check gates the swap → Caddy flips traffic on success, or the swap aborts and the old color keeps running on failure.

## Considered options

- Automate secret-change pickup via 1Password Events API webhook → `repository_dispatch` (rejected: requires a Business/Enterprise 1Password tier and adds trigger/detection infrastructure for a low-frequency, low-urgency event; manual trigger is cheap enough)
- Automate via scheduled polling of item metadata (rejected: same complexity cost as the webhook option without the tier requirement, still not justified by frequency)
- Move non-secret config to an externally-mounted file so it can also skip image rebuilds (rejected: introduces drift between the image and an out-of-band file for a rare case that the existing git/CI path already handles)
- In-process hot-reload (`IOptionsMonitor` watching a live secret source, no container recreate at all) (rejected: env-var-based secret injection can't support this without re-architecting how secrets reach the app; a config-only blue-green redeploy already delivers zero downtime at far lower cost)
