# Ask for a store rating with a silent, quota-aware in-app review, not a custom dialog

We ask for a store rating by triggering the platform's **native review prompt** silently at an engagement checkpoint, and never more than three times a year. The app no longer shows its own "Rate / Ask me later / Don't ask again" dialog before the review ([#39](https://github.com/Progrunning/BoardGamesCompanion/issues/39)).

## Status

accepted

## Context

The engagement criteria — app installed 14 days, launched 30 seconds ago, at least 300 significant actions — decide when we want a rating. Previously, meeting them raised a flag that made `BasePageState` show a custom `AlertDialog`, and only the **Rate** button called `InAppReview.requestReview()`.

That coupling is the bug. Both stores treat the in-app review flow as best-effort and quota-limited: Apple shows the prompt at most three times per app, per device, per 365-day period, and Google enforces its own undocumented quota. Neither reports back whether the prompt was actually shown. Both explicitly say the flow must fire at a natural moment and must **not** be attached to a button — so a user who has already been prompted three times, or whose quota is spent, taps our **Rate** button and sees nothing. The custom dialog manufactured exactly the anti-pattern the platforms warn against.

## Considered options

- **Custom dialog, Rate button opens the store listing** (rejected: it fixes the "nothing happens" symptom by abandoning the native in-app prompt entirely, sending every willing user out to the full store page. It keeps a modal that interrupts the user to ask a question the OS is designed to ask unobtrusively, and it still gates a review on a button — the thing both stores tell you not to do).
- **Silent native prompt at the checkpoint, no dialog** (accepted: the OS decides whether and how to show the prompt, at a moment the user is already engaged, with no interruption when the quota is spent. This is the intended pattern on both platforms from one `InAppReview.requestReview()` call).
- **No client-side rate limit, rely on OS quotas** (rejected: we would call `requestReview()` on many launches once eligible, spending OS quota slots on requests that get silently dropped and learning nothing. A client-side cadence keeps each attempt meaningful).

## Decision

- On reaching the engagement criteria, `BasePageState` calls `RateAndReviewService.requestReview()` after the launch animations settle. There is no dialog and no user-facing choice.
- `requestReview()` asks the OS to show its native prompt (guarded by `isAvailable()`) and records the attempt timestamp. It shows nothing itself.
- Eligibility additionally requires that the **last review request** was either never made or is older than a third of a year (`365 ~/ 3` ≈ 121 days), so we attempt at most three times a year and space the attempts evenly against the OS quota rather than bunching them.
- An explicit "rate us" affordance — the home drawer's **Rate & Review** item — deep-links to the store listing (`openStoreListing`), which is the correct response to a deliberate user action on both platforms and is unaffected by this decision.

## Consequences

- **"Ask me later" and "Don't ask again" no longer exist.** With no dialog there is nowhere to offer them, so `askMeLater`, `dontAskAgain`, the `remindMeLater` preference, and the dialog strings were removed. Users who dislike the prompt use the OS-level setting (Apple: App Store → In-App Ratings & Reviews) to turn it off globally.
- **"Seen" became a timestamp, not a boolean.** A permanent "dialog seen" flag is incompatible with prompting again three times a year, so the single source of truth for cadence is the **last review request** timestamp. The old boolean preference is gone.
- **We never learn whether a prompt was shown.** The OS gives no callback, so the recorded timestamp marks an *attempt*, not a confirmed impression. A spent quota looks identical to a shown prompt. This is inherent to both platforms and is why the client-side cadence exists.
- **The rate limit is time-based, not a counter.** Three attempts a year falls out of the ~121-day spacing rather than a "requests this year" count, which keeps the rule to one stored timestamp and no rollover bookkeeping.
