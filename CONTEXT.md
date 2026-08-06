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

### Storage

**Collection entry**:
The user's relationship to a board game — owned, wishlist, friends, and the settings governing how they score it. Distinct from the game itself: a game can be known without the user having any relationship to it. Survives every refresh from BGG.
_Avoid_: Owned game, library entry, collection item

**Catalogue data**:
Board game facts sourced from BGG — name, description, rating, ranks, categories, publishers, designers, artists, expansions, prices. Replaced wholesale on refresh and always re-fetchable, therefore never irreplaceable.
_Avoid_: Game data, BGG data, game details

**User-authored data**:
Playthroughs, scores, players, notes, and collection entries. Recorded by the user and reconstructible from nothing — the only data in the app whose loss is permanent.
_Avoid_: Local data, app data, user data

**Legacy store**:
The Hive files predating the SQLite migration. Read-only, imported once on launch, and retained indefinitely because old backups still contain them.
_Avoid_: Old database, Hive box, legacy database

**Catalogue proxy**:
A backend endpoint that fetches catalogue data from BGG on behalf of the client and caches the result server-side, shared across all users. `/hot` and game `/thing` details are catalogue proxies.
_Avoid_: BGG proxy, cache endpoint

**Pass-through proxy**:
A backend endpoint that fetches BGG-username-scoped data on behalf of the client but does not persist it server-side — each request is re-fetched from BGG, just with the backend absorbing BGG's own retry/queuing behaviour instead of the client. Collection and plays import are pass-through proxies, not catalogue proxies, because the result is scoped to one BGG username rather than shared catalogue data.
_Avoid_: BGG proxy, forwarding endpoint
