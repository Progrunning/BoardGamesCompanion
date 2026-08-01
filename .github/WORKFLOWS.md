# GitHub Actions Workflows

---

## Claude PR Review (`workflows/claude-pr-review.yml`)

Reviews an open pull request on demand using Claude (via [anthropics/claude-code-action](https://github.com/anthropics/claude-code-action)).

### Triggering a review

A repository maintainer (author association `OWNER`, `MEMBER`, or `COLLABORATOR`) posts a comment on a pull request containing:

```
/claude review
```

The phrase can appear anywhere in the comment body. Comments from external contributors are ignored. Posting `/claude review` more than once on the same PR is fine — each comment starts a fresh run.

Claude posts top-level feedback via `gh pr comment` and inline comments directly on the diff. The workflow does **not** trigger automatically when a PR is opened or updated.

### Prerequisite: Claude GitHub App

The [Claude GitHub App](https://github.com/apps/claude) must be installed on this repository. A repo admin only needs to do this once. If PR reviews stop appearing entirely (not just erroring), check that the app is still installed under the org/repo's **Settings → Integrations → GitHub Apps**.

### Creating the `ANTHROPIC_API_KEY` secret

1. Go to [console.anthropic.com](https://console.anthropic.com) and sign in with an account that has billing enabled for this project.
2. Navigate to **API Keys** → **Create Key**. Give it a recognizable name, e.g. `boardgamescompanion-github-actions`.
3. Copy the key value immediately — it is only shown once.
4. In GitHub, go to this repo's **Settings → Secrets and variables → Actions → Repository secrets**.
5. If `ANTHROPIC_API_KEY` already exists, click it → **Update** and paste the new value. Otherwise, click **New repository secret**, name it `ANTHROPIC_API_KEY`, and paste the value.

Note: this is a pay-per-token API key, billed separately from any Claude.ai/Pro/Max subscription. See [console.anthropic.com/settings/billing](https://console.anthropic.com/settings/billing) for usage and cost.

### Renewing / rotating the key

Rotate the key if it's been exposed (e.g. leaked in a log or committed by mistake) or on a routine security schedule:

1. Create a **new** key in the console first (don't delete the old one yet), following the steps above.
2. Update the `ANTHROPIC_API_KEY` repository secret with the new value (step 4–5 above).
3. Post `/claude review` on any open PR and confirm the `Claude PR Review` workflow run succeeds under the **Actions** tab.
4. Once confirmed working, go back to the console and **revoke/delete the old key**.

### Alternative: subscription-based auth (no API cost)

If you'd rather use an existing Claude Pro/Max subscription instead of a pay-per-token API key:

1. Install the standalone CLI locally: `npm install -g @anthropic-ai/claude-code`.
2. Run `claude setup-token` and complete the browser login. It prints a long-lived OAuth token.
3. Save it as a repository secret named `CLAUDE_CODE_OAUTH_TOKEN` (same Settings path as above).
4. Update [workflows/claude-pr-review.yml](workflows/claude-pr-review.yml) to pass `claude_code_oauth_token: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}` instead of `anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}`.

This token is tied to the subscription and will need to be regenerated (repeat the steps above) if it expires or is revoked.

---

## Claude Issue Agent (`workflows/claude-issue-agent.yml`)

Implements a ticket autonomously and opens a pull request.

### Triggering the agent

- **Label trigger:** add the `ready-for-agent` label to an open, non-`spec` issue.
- **Frontier auto-advance:** closing an issue dispatches any issue it was blocking that is now fully unblocked (`ready-for-agent`, no remaining open blockers). No manual action needed.
- **Manual dispatch:** `gh workflow run claude-issue-agent.yml -f issue_number=<n>`, or via **Actions → Claude Issue Agent → Run workflow** in the GitHub UI.

### What it does

Checks out the repo, sets up .NET and Flutter toolchains, then runs the `/implement` skill against the ticket. On success it opens a non-draft PR whose body starts with `Fixes #<n>` and removes the `ready-for-agent` label. On failure it comments on the issue explaining the blocker and re-routes the ticket to `needs-info`.

### Prerequisite: `AGENT_PAT` secret

Frontier auto-advance (dispatching newly unblocked issues when one closes) requires a workflow-triggering token — GitHub's recursion guard blocks the default `GITHUB_TOKEN` from dispatching other workflow runs. Set repository secret `AGENT_PAT` to a PAT (or GitHub App token) with `actions: write` and `issues: read`. Without it the frontier dispatch is a silent no-op and must be triggered manually.
