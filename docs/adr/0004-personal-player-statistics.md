# Personal player statistics: rival/nemesis model and split win rates

Tapping a player now opens a read-only statistics page describing that person across every game they have played. Almost all of it — total plays, games by plays, buddies — is arithmetic with one obvious answer. Two decisions are not, and both are hard to walk back once players start reading numbers and forming expectations about them: **how a rival and a nemesis are defined**, and **how a win rate is reported**. This ADR records those two.

All statistics are computed on demand from the players, playthroughs and scores already in memory, joined to each game's settings to resolve whether a result is a place or a shared outcome. Finished, non-deleted playthroughs only; deleted players stay in other players' numbers and keep a reachable page.

## Status

accepted

## Consequences

- **Rival and nemesis are pairwise within a competitive play, not derived from wins.** In each competitive play a player beats everyone they finish above and loses to everyone they finish below — placing third of six records two beats and two losses, not nothing. Beating is *finishing above*, decided by place when recorded and by score otherwise; a tie for a place is neither a beat nor a loss. Rival is the opponent beaten most, nemesis the opponent lost to most, each shown with the head-to-head record. Co-op plays contribute nothing here, because people you only cooperate with are not opponents.
- **The relation is directional and that is correct.** Your rival's rival is usually not you. Reviewers and users will read this as a bug; it is the definition. The page and this ADR both call it out so the asymmetry is not "fixed" into a symmetric relation later.
- **A three-play floor gates rivalry.** An opponent is only eligible once the two have met in at least three competitive plays, so one unlucky evening cannot crown a nemesis. The cost is that a genuinely new player shows only a header and totals — a truthful sparse page rather than a broken-looking one — and the feature is therefore hard to appreciate on a fresh install. That trade is deliberate.
- **Win rate is two figures, never one.** Competitive win rate and co-op win rate are reported side by side and never summed or averaged into a single percentage. A co-op outcome belongs to the whole table, so folding it into a competitive record would let a run of hard co-op games make a strong competitive player look weak.
- **Solo plays count as plays but not as competitive opposition.** A solo play is in total plays and can be an absolute win, but it is excluded from the competitive win rate denominator, because that number is meant to describe beating people.
- **Ties for first are wins for everyone tied, including imported plays.** This depends on the winners helper returning all tied top results rather than one — a prerequisite bug fix, since plays imported from BoardGameGeek record points but no place and previously contributed no clean winner.
- **Introducing a time period later is additive.** The page is all-time with no period selector. Adding one means giving the plays-tab period vocabulary an explicit "all time" option, so both surfaces describe periods identically — not reworking these definitions.

## Considered options

### Defining rival and nemesis

- **Pairwise "finishing above" within each competitive play, floored at three shared plays** (chosen: matches how players narrate a table — "I beat three of them" — and rewards a strong mid-pack finish rather than only outright wins)
- **Only the winner beats everyone; everyone else the winner beats** (rejected: throws away every result between non-winners, so a consistent second-place finisher has no recorded rivalry with the people they routinely edge out)
- **Rank purely by win count with no floor** (rejected: a single lucky or unlucky play crowns a rival or nemesis, which is exactly the noise the page should not amplify)
- **Symmetric rivalry — the pair's combined record decides both players' rival** (rejected: it reads as less surprising, but it is a different, weaker claim; "who do *I* beat most" is the question players actually ask, and it is inherently directional)
- **Include co-op plays as shared opposition** (rejected: cooperating with someone is not competing against them, and counting it would invent rivalries out of games nobody was playing to win)

### Reporting win rate

- **Two separate figures, competitive and co-op, never blended** (chosen: the two outcomes mean different things — one is personal, one is the table's — and a single number would silently mix them)
- **One overall win rate across all plays** (rejected: a co-op loss and a competitive loss are not the same event, and a combined rate hides which one a player is actually good or bad at)
- **Competitive win rate including solo plays** (rejected: a solo win has no opponent, so counting it inflates a number meant to describe beating people)
- **A separate solo win rate** (rejected: not asked for, and it would add a third number to a page whose point is legibility)

### Where the numbers come from

- **Compute on demand from the in-memory stores, uncached** (chosen: the stores already hold everything, the work is a linear pass with a pairwise pass inside each play, and caching would add an invalidation problem for no measurable gain)
- **Precompute and cache per player, invalidated on any playthrough or score change** (rejected: the invalidation surface is every write path, and the win it buys is unmeasurable at this data size)
- **Derive statistics from scores alone** (rejected: whether a recorded result is a place or a shared outcome is a property of the game's settings, so scores must be joined to settings — statistics cannot be read off scores by themselves)
