# Board Games Companion

A companion app for board game players — a Flutter mobile app backed by a Search API that fronts BoardGameGeek (BGG) data.

## Language

### Deployment

**Release**:
A specific build of the Search API, identified by the short git SHA of the commit it was built from. One release = one immutable image tag.
_Avoid_: Build, version, build ID

**Color**:
One of the two interchangeable production slots for the Search API — blue or green. Exactly one color serves traffic at steady state.

**Active color**:
The color currently receiving production traffic. The reverse-proxy site snippet is the single source of truth for which color is active.
_Avoid_: Live container, current deployment

**Cutover**:
The act of switching production traffic from the active color to the freshly deployed one, performed only after the new color proves healthy.
_Avoid_: Swap, switch-over, flip (in docs; "flip" is fine in conversation)

**Rollback**:
Deploying a previously released image tag through the normal deploy path. A rollback is an ordinary deploy pointed at an old release, not a special mechanism.

**Legacy client**:
An install of the app built before the Hetzner migration, whose Search API base URL is baked in at compile time and can never be repointed.
_Avoid_: Old app, stale client, legacy user

**Legacy shim**:
The retained APIM instance that authenticates legacy clients and forwards their search requests to the Search API. Its only job is keeping legacy clients alive; it is not a general-purpose gateway.
_Avoid_: Proxy, gateway, APIM

**Legacy key**:
The named entry in the Search API's key map used exclusively by the legacy shim. Revoking it retires the shim.
_Avoid_: Old key, APIM key

**Frozen contract**:
The guarantee that a search result keeps its `id` and `name`, for as long as the legacy key exists. Additive changes are unrestricted.
_Avoid_: Contract freeze, v1 contract
