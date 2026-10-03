# Scores can be typed on a keypad, not only accumulated

The Enter Score dialog builds a total by **accumulating partial scores** — each tap of a `+1/+5/+10/+50` tile, or a spin of the circular dial, appends one increment and the running total is their sum ([#94](https://github.com/Progrunning/BoardGamesCompanion/issues/94)). This makes large totals painful: entering 1000 is twenty taps of `+50`, and money games reach far higher. We add a **keypad** so an exact value of any magnitude can be typed directly, and we drop the `+50` tile to make room for it without redesigning the dialog. The typed value is treated as one more partial score, honouring the `+/−` toggle, so a single number can be added or subtracted and Undo still pops it like any other entry.

## Status

superseded by [ADR-0007](0007-keypad-bottom-sheet-replaces-the-score-dial.md)

The keypad itself survives; its surface does not. The Discord poll this ADR gated the dial on has since run, and the dial is removed — so the keypad became the entry surface in a bottom sheet rather than a mode swapped into a centred dialog, the sticky `+/−` toggle became calculator commit keys, and the `50` tile sacrificed below was restored. The rejected alternatives recorded here still stand.

## Considered options

- **Add `100` and `1000` tiles** (the [#94](https://github.com/Progrunning/BoardGamesCompanion/issues/94) suggestion, rejected: it moves the wall rather than removing it — `1000` is still five taps for 5000 — and never reaches exact odd totals like 1350, which money and economic games need. It also does not fit: the instant-score row spends 252px of a 308px content width at the 340px minimum, so a fifth tile leaves ~4px of slack and a sixth overflows outright).
- **A `×10` multiplier tile** that scales every increment (rejected: buys one order of magnitude with a single tile, but still cannot land an arbitrary exact number, which was the point).
- **Per-game increment sets** — money games expose `{100, 500, 1000}`, point games keep `{1,5,10,50}` (rejected: there is no per-game score type to hang this on today; the model stores a single `scoreGameResult.points` and "no-score" means a co-op play, not a scoring style. It needs new configuration a keypad makes unnecessary).
- **The system numeric keyboard** via a focused `TextField` (rejected: it brings decimals, a minus key and locale noise we would have to filter back out against the integer-only, 6-digit, sign-from-toggle rules; and on a centred dialog the keyboard slides up over the card, forcing inset work to keep the score visible. A custom keypad — built from the tile widgets that already exist — gives exact control and matches the dialog's own visual language. Neither surface exists yet, so there is no reuse advantage to the system one).

## Consequences

- **The `+50` tile is gone.** With the keypad covering large jumps and the dial covering the middle, `50` is the most redundant increment, so `{1, 5, 10, keypad}` keeps the row's footprint identical to today. Point games that scored in 50s lose their fast big-step tile — an accepted, pragmatic trade for not redesigning the dialog now.
- **The keypad swaps in inside the dialog card**, replacing the 280px dial region, rather than opening as a bottom sheet. The score display and `+/−` toggle stay pinned at the top so the sign context is never hidden while typing, and there is no second modal layer or keyboard-inset maths. The card already sizes to its content, so the height change is clean.
- **A typed value is just another partial score.** It shows in the `(+…, +…)` history strip with no special treatment (`+1350`), preserving the sum-of-partials invariant and leaving Undo unchanged. Entering into an empty score therefore lands an exact total in one action.
- **Input is capped at six digits (≤ 999999) and integer-only**, and the sign comes from the existing `+/−` toggle rather than a key on the pad, matching how the score is displayed (`toStringAsFixed(0)`) everywhere else.
- **The circular dial is untouched by this decision.** Whether it is later demoted or removed is a separate question, deliberately gated on a Discord usage/sentiment poll rather than assumed here.
