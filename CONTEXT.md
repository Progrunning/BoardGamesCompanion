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

### Statistics

**Competitive play**:
A finished, non-deleted playthrough of a game whose settings classify it as scored (not cooperative). The scores establish an ordering, so one player can be said to finish above another.
_Avoid_: Versus game, scored game, ranked play

**Co-op play**:
A finished, non-deleted playthrough of a game whose settings classify it as cooperative. The result — win or loss — belongs to the whole table, not to any one player.
_Avoid_: Cooperative game, team play, no-score play

**Solo play**:
A play with a single participant. Counted in a player's total plays, but excluded from their competitive win rate because there is no opposition to beat.
_Avoid_: Single-player game, one-player play

**Competitive win rate**:
The fraction of a player's multiplayer competitive plays that they won, ties for first counting as a win. Reported separately and never blended with the co-op win rate.
_Avoid_: Win rate, win percentage, win ratio

**Co-op win rate**:
The fraction of a player's co-op plays the table won. A whole-table outcome, kept apart from the competitive win rate so a run of hard co-op games does not drag a strong competitive record down.
_Avoid_: Win rate, cooperative percentage

**Head-to-head record**:
Between two players, how many competitive plays one finished above the other and how many below, shown as a wins–losses pair. Beating someone means finishing above them, not only winning the play.
_Avoid_: Matchup, score line, record

**Rival**:
The opponent a player has beaten most across their shared competitive plays, considered only once the two have met in at least three competitive plays. A player's rival rarely has that player as their own rival — the relation is directional.
_Avoid_: Best matchup, favourite opponent

**Nemesis**:
The opponent a player has lost to most across their shared competitive plays, subject to the same three-play floor as the rival.
_Avoid_: Arch-enemy, worst matchup

**Buddy**:
Someone a player has shared the most playthroughs with, co-op and competitive alike. The five buddies with the highest shared-play counts are shown.
_Avoid_: Friend, teammate, frequent player
