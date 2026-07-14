# Triage Labels

The skills speak in terms of five canonical triage roles. This file maps those roles to the actual label strings used in this repo's issue tracker.

| Label in mattpocock/skills | Label in our tracker | Meaning                                  |
| -------------------------- | -------------------- | ---------------------------------------- |
| `needs-triage`             | `needs-triage`       | Maintainer needs to evaluate this issue  |
| `needs-info`               | `needs-info`         | Waiting on reporter for more information |
| `ready-for-agent`          | `ready-for-agent`    | Fully specified, ready for an AFK agent  |
| `ready-for-human`          | `ready-for-human`    | Requires human implementation            |
| `wontfix`                  | `wontfix`            | Will not be actioned                     |

When a skill mentions a role (e.g. "apply the AFK-ready triage label"), use the corresponding label string from this table.

Edit the right-hand column to match whatever vocabulary you actually use.

## Operational semantics

Two of these labels drive the automated agent workflow (`.github/workflows/claude-issue-agent.yml`):

- **`ready-for-agent` is a live trigger.** Adding it to an eligible issue — open, not labelled `spec`, and with no open blockers — automatically starts an AFK agent run that implements the issue and opens a pull request. The agent removes `ready-for-agent` once its PR is open. If the run cannot deliver a PR (underspecified ticket, unfixable tests), the agent comments with the specific blocker, removes `ready-for-agent`, and applies `needs-info` — routing the ticket back to the human triage lane.
- **Re-adding `ready-for-agent` is a deliberate re-run.** Re-applying the label starts a fresh run.

## Filter labels

Beyond the five canonical triage roles, one additional label filters what the agent workflow will pick up. It is not a sixth triage role:

| Label  | Meaning                                                                 |
| ------ | ---------------------------------------------------------------------- |
| `spec` | A PRD / spec issue. The agent trigger always skips it, even when `ready-for-agent` is also present. Specs are broken into implementation tickets by a human `/to-tickets` session, not implemented directly. |
