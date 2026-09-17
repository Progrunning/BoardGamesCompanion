# A Tip never unlocks app functionality, and a Supporter perk is never app functionality or BGG data

The app is adding a voluntary tip jar: a one-time, non-consumable purchase across three tiers that grants a single lifetime "Supporter" entitlement. There are no subscriptions, no consumables, and no repeatable tips — a user either has tipped once, ever, or has not. Purchases run through RevenueCat against anonymous app user IDs; there are no user accounts and no backend changes. The decision this ADR records is narrower than the feature itself: every feature of the app must remain free and identical regardless of tip status, and Supporter perks must be cosmetic or community-facing only — never a gate in front of functionality, and never a wrapper around BoardGameGeek (BGG) data.

This invariant exists to protect the app's BGG XML API license, which is a free, non-commercial license. Gating any functionality behind payment, or showing ads, would require moving to a paid commercial BGG license whose cost could exceed everything the tip jar will ever earn. There is also no fallback data source to migrate to if BGG revoked the free license — Board Game Atlas, the one comparable alternative, has already shut down. The invariant has to be explicit and written down, not just understood, because the natural next request after shipping a tip jar is "let's gate just this one feature" — and a single exception is enough to reclassify the app as commercial.

## Status

accepted

## Consequences

- **Perks are limited to cosmetic and community rewards.** A Supporter badge and alternate app icons are cosmetic; a private Discord invite revealed after tipping is community. Neither touches app functionality or BGG data. An exclusive theme was scoped in the parent spec (#297) but deferred to a separate ticket (#334) pending a human decision on theming infrastructure — it is not implemented here.
- **No feature, screen, or dataset can ever check tip status to decide what to show.** Any future PR that reads Supporter/tip state to conditionally enable a feature, raise a limit, or unlock BGG data is a violation of this ADR, not a judgment call — it should be rejected or escalated, not merged as a reasonable-sounding exception.
- **No ads.** Ads are the other path to funding the app, and they carry the same commercial-license problem as gated functionality. This ADR forecloses that option too, not just paywalls.
- **RevenueCat is the entire payment surface.** Anonymous app user IDs mean no accounts, no login, and no backend changes are needed to grant or check entitlement — Supporter status lives in RevenueCat and on-device, not in a system the app's data pipeline touches.
- **The BGG free/non-commercial license remains intact.** As long as no purchase changes what any user can see or do with BGG data, the app stays within the license it already operates under, with no renegotiation and no new cost.

## Considered options

- **Gate a low-traffic feature (e.g. an advanced filter or export) behind Supporter status** (rejected: this is exactly the drift this ADR exists to stop — any gated feature makes the app commercial and triggers the paid BGG license)
- **Show ads instead of, or alongside, a tip jar** (rejected: same commercial-license consequence as gating; also degrades the experience for every user, not just non-tippers)
- **Let Supporters see additional or higher-fidelity BGG data (e.g. extra fields, higher rate limits)** (rejected: BGG data itself must never be the reward — that is monetizing someone else's free-licensed data)
- **Cosmetic and community perks only, with no functional or data-access perks** (adopted as the shape of the tip jar: badge, alternate icons, and a Discord invite, none of which change what the app does or shows)
- **Subscriptions or repeatable/consumable tips** (rejected: adds recurring billing, refund, and entitlement-lapse complexity for a feature meant to be a one-time thank-you, not a revenue product)
