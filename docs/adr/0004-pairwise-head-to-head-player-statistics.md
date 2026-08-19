# Player statistics are pairwise, and win rate is split by play type

Personal player statistics ([#164](https://github.com/Progrunning/BoardGamesCompanion/issues/164)) report a **rival**, a **nemesis** and a **competitive win rate** — three numbers that only exist once you decide what "beating someone" means. We count **head-to-head records** pairwise: within each **competitive play**, a player beats everyone placed below them and loses to everyone above, so a fifth-place finish in a six-player game still produces a win. And we report **competitive win rate** and **co-op win rate** as two separate figures rather than one blended percentage.

## Status

accepted

## Considered options

- **Winner-takes-all head-to-heads** (rejected: only the first place records anything, so everyone at a table shares the same nemesis — whoever wins most — and the stat says nothing about the player it is shown to). Pairwise is O(players²) per play instead of O(players), which is irrelevant at the table sizes board games have.
- **A single blended win rate over all plays** (rejected: a **co-op play** outcome belongs to the table, so a player whose history is mostly co-op has a win rate driven by the groups they join. Two players' blended rates are not comparable, and users would read the difference as a bug rather than as a difference in what they play).
- **Ranking rival and nemesis by rate instead of count** (rejected: a rate crowns a nemesis off one unlucky evening. Count matches the plain-English "person I lost to most", with a floor of three shared **competitive plays** to suppress the same one-off result, and the record displayed alongside the name so the rate stays visible without driving the ranking).

## Consequences

- **Ties at first place count as a win for every tied player.** The alternative — splitting a win, or awarding it to nobody — makes the wins column stop summing to anything a user can verify against their own play history.
- **A play's `GameFamily` is an input to every win statistic.** Whether a **recorded result** means a place or a shared outcome is a property of the board game's settings, not of the score, so aggregating a player across their whole history joins scores to playthroughs to board game settings. There is no path to these numbers from the scores alone.
- **Plays imported from BGG carry points but no place.** `playthroughs_view_model.dart` builds `ScoreGameResult` without one, so `Score.isWinner` — defined as `place == 1` — is false for every imported competitive play. Win statistics must derive the winner by ordering scores within the play, as `ScoresExtesions.winners` already does. That fallback currently returns a single winner and so drops ties; it has one production caller, which already accepts a list, and fixing it is a prerequisite for this work rather than a refactor alongside it.
- **Soft-deleted players stay in the aggregates.** A deleted player really did win those games, and dropping them would make one screen's totals disagree with another's. Soft-deleted playthroughs are excluded everywhere — those are retracted history, not history about someone who left.
- **Sections below their threshold are hidden, not shown empty.** With the three-play floor on rivalry, a new player's page would otherwise be five cards of placeholders, which reads as a broken screen rather than as a young history.
- **Statistics are all-time.** The period selector on the Plays statistics tab is deliberately not reused here yet; adding it later means introducing an "all time" option to the shared period vocabulary so both surfaces describe periods the same way.
