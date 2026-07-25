# Keep Azure APIM alive as a legacy-client shim after the Hetzner migration

The app's Search API base URL is a compile-time `String.fromEnvironment` baked into every binary, pointing at `bgc-shared-apim.azure-api.net` — a hostname whose DNS we don't control. There is no forced update and no remote config, so **no app-side mechanism can repoint an install that is already in the wild**. Rather than orphan those users at cutover, we keep the APIM instance running as a shim: it authenticates legacy clients on their `Ocp-Apim-Subscription-Key`, translates it to the `x-api-key` the Search API expects, and forwards to the Hetzner backend. New app builds bypass it and call Hetzner directly.

This qualifies ADR-0001: we have left Azure for compute, CI/CD, telemetry, and registry, but APIM remains in the hot path for legacy clients until a forced-update mechanism ships.

## Status

accepted — superseded when the forced-update mechanism lands and the legacy key is revoked.

## Consequences

- **Azure is not fully vacated.** One APIM instance survives indefinitely. ADR-0001's "leave the Azure estate" is true for everything except this front door.
- **The shim needs no new code.** `backend/apim/search-api-policies-prod.xml` already injects `{{SearchApiKeyHeaderName}}: {{SearchApiKeyProd}}` on every inbound request — the old→new auth translation has been in production all along. Migrating the shim is two portal edits: repoint the API's backend URL at Hetzner, and update the `SearchApiKeyProd` named value.
- **The Search API accepts a set of keys, not one.** `ApiKeyAuthenticationSettings.ApiKey` becomes `Dictionary<string, string> ApiKeys` (client name → secret). The matched name flows into `ClaimTypes.Name`, so logs and OTLP spans self-attribute to `legacy-apim` or `mobile` without extra instrumentation. Revoking the shim is deleting one map entry. This is a breaking config change (`__ApiKey` → `__ApiKeys__<name>`) that must land in the same deploy as the 1Password update; it fails closed via `ValidateOnStart`.
- **Key comparison stays non-constant-time.** Deliberate: the keys are baked into published binaries and are effectively public, so timing attacks are not the threat model.
- **`/api/search`'s response shape is frozen, not versioned.** While the legacy key exists, every result object must carry a non-null `id` and `name` — the only two `required` fields in the legacy client's `BoardGameSearchResultDto`. Everything else is nullable and additive changes are unrestricted (json_serializable ignores unknown keys; `type` is guarded with `unknownEnumValue`).
- **Retirement is governed by Firebase, not by API metrics.** Firebase Analytics is already initialized and collects `app_version` per active user, which counts *people* rather than requests. The shim retires when active users on pre-cutover builds stay below **1% for 8 consecutive weeks**. The legacy key is a kill switch, not a metric.
- **Retirement is by key revocation, not resource deletion.** Same user-visible outcome, instantly reversible if the Firebase numbers mislead, and it keeps the shim available should a safe way to message orphaned users ever appear.
- **Blast radius at retirement is bounded to search.** Every other feature — collections, plays, game details, hot games — calls `boardgamegeek.com` directly. Orphaned users see the existing generic search error (search failures are already caught and reported to Crashlytics); the rest of the app is untouched.
- **Cost is unquantified.** Nobody has checked what the APIM instance costs per month. If it's a fixed tier rather than consumption, the forced-update work deserves higher priority than the retirement threshold alone implies.

## Considered options

- **Let old clients break at cutover** (rejected: search is how users add games; breaking it silently invites uninstalls and one-star reviews for no saving beyond one Azure resource)
- **Re-point DNS at Caddy and drop Azure entirely** (rejected: not possible — shipped clients call `*.azure-api.net` directly and no custom domain fronts APIM)
- **Route new builds through APIM too** (rejected: makes Azure permanently load-bearing, and destroys the decay signal that tells us when the shim is safe to delete)
- **Version the endpoint as `/api/v2/search` for new clients** (rejected: two code paths carried for exactly as long as the freeze would be, for a response shape we have no plan to change)
- **Share one API key between legacy and direct clients** (rejected: no independent kill switch, and legacy traffic becomes indistinguishable at the API)
- **Message orphaned users through a synthetic search result** (rejected: `HomeViewModel` persists every search result into the user's Hive collection via `BoardGameDetails.fromSearchResult`, so a fake row would corrupt user data on every search)
- **Return an empty array at retirement instead of failing** (rejected: looks like a working app with a broken index, more confusing than an error, and suppresses the Crashlytics signal)
