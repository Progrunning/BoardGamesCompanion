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

### Publishing

**Published collection**:
The copy of a user's collection held on the server that a share link resolves to. A snapshot taken at the moment of publishing — the collection in the app can be ahead of it, never behind. Exists only while the user keeps it published.
_Avoid_: Public collection, synced collection, profile, cloud collection

**Publish key**:
The opaque secret held by the app that identifies and authorises writes to a published collection. It is not an account: there is no login, and whoever holds the key owns the published collection. Travels with the user's backup so a reinstall keeps the same share link.
_Avoid_: Token, API key, user id, device id

**Share link**:
The public URL at which a published collection can be viewed. Unlisted — reachable only by those it is given to; never discoverable through search or a directory. Carries a public id, never the publish key.
_Avoid_: Profile URL, collection URL, permalink

**Statistics snapshot**:
The statistics the app computed and sent along with a published collection, shown on the web exactly as received. Derived, never authoritative: the server stores it, it never recomputes it, and each publish replaces it wholesale.
_Avoid_: Server stats, cached stats, web statistics

### Statistics

**Competitive play**:
A playthrough of a game whose players are ranked against each other, so exactly one place is first. The only kind of play that can say anything about one player relative to another.
_Avoid_: Versus game, PvP, scored game

**Co-op play**:
A playthrough whose players share a single outcome — the whole table wins or the whole table loses. Nobody beats anybody.
_Avoid_: Cooperative game, team game, no-score game

**Recorded result**:
A player's outcome in a playthrough that is definite enough to count towards their statistics — a place in a competitive play, a shared outcome in a co-op play. A play in progress or missing outcomes has no recorded result and is invisible to every statistic.
_Avoid_: Finished score, valid score, complete play

**Competitive win rate**:
The share of a player's competitive plays they finished first in, ties included. Kept apart from co-op because a co-op outcome belongs to the table rather than the player, and blending the two produces a number that cannot be compared between players.
_Avoid_: Win %, win ratio

**Co-op win rate**:
The share of a player's co-op plays the table won. A property of the groups a player plays with as much as of the player.

**Head-to-head record**:
Two players' wins and losses against each other, counted a pair at a time within the competitive plays they shared. Finishing above someone is a win against them regardless of who else was at the table.
_Avoid_: Matchup, H2H, record

**Rival**:
The player someone has beaten most across their head-to-head records. Rivalry is not symmetric — your rival's rival is rarely you.
_Avoid_: Favourite victim, best matchup

**Nemesis**:
The player someone has lost to most across their head-to-head records.
_Avoid_: Worst matchup, bogey player

**Buddy**:
A player someone has shared the most playthroughs with, of any kind. Measures company kept, not results, so co-op plays count exactly as much as competitive ones.
_Avoid_: Frequent player, teammate, partner

### Score entry

**Partial score**:
One increment appended to a player's total while recording a score. A total is always exactly the sum of its partial scores, which is what makes undoing the last one meaningful — remove a partial and the total follows. A typed number is a single partial score, no different from a tapped one.
_Avoid_: Increment, step, delta, sub-score

**Instant score**:
A fixed-value partial score committed in one tap, without typing. Exists for the increments common enough to be worth a dedicated key.
_Avoid_: Preset, quick score, tile, shortcut

**Score entry**:
Digits that have been typed but not yet committed as a partial score. It is not part of the total until committed, and it is what backspace edits — as opposed to undo, which removes a partial score that already counted.
_Avoid_: Input, draft score, pending score, buffer
