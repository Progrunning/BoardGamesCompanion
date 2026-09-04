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

### Ratings

**In-app review**:
The platform's own review prompt, shown by the OS on top of the app so the user can rate without leaving it. Best-effort and quota-limited — the OS decides whether to show it and never reports back — so it is asked for silently at an engagement checkpoint, never behind a button.
_Avoid_: Rate dialog, review popup, rating prompt

**Engagement criteria**:
The conditions that make a user eligible for an in-app review — installed 14 days, launched at least 30 seconds ago, and at least 300 significant actions. Meeting them makes an attempt due; it does not guarantee a prompt is shown.
_Avoid_: Rating threshold, trigger conditions

**Significant action**:
A user action meaningful enough to count towards the engagement criteria, such as logging a play or editing a collection entry. Counted up to the criteria's ceiling and no further.
_Avoid_: Interaction, event, tap

**Review request**:
A single silent attempt to surface the in-app review. Its timestamp is recorded whether or not a prompt actually appears, because the OS never says. Attempts are capped at three a year and spaced roughly a third of a year apart.
_Avoid_: Review shown, rating impression, prompt

**Store listing**:
The app's full page on the App Store or Google Play, opened directly in response to a deliberate "rate us" action (the home drawer's Rate & Review item). Distinct from an in-app review, which the OS overlays without leaving the app.
_Avoid_: Store page, app page, product page
