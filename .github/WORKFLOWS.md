# GitHub Actions: Claude PR Review

[workflows/claude-pr-review.yml](workflows/claude-pr-review.yml) automatically reviews every pull request using Claude (via [anthropics/claude-code-action](https://github.com/anthropics/claude-code-action)). It runs on `pull_request` events (`opened`, `synchronize`) and posts feedback as PR/inline comments.

## Prerequisite: Claude GitHub App

The [Claude GitHub App](https://github.com/apps/claude) must be installed on this repository. A repo admin only needs to do this once. If PR reviews stop appearing entirely (not just erroring), check that the app is still installed under the org/repo's **Settings → Integrations → GitHub Apps**.

## Creating the `ANTHROPIC_API_KEY` secret

1. Go to [console.anthropic.com](https://console.anthropic.com) and sign in with an account that has billing enabled for this project.
2. Navigate to **API Keys** → **Create Key**. Give it a recognizable name, e.g. `boardgamescompanion-github-actions`.
3. Copy the key value immediately — it is only shown once.
4. In GitHub, go to this repo's **Settings → Secrets and variables → Actions → Repository secrets**.
5. If `ANTHROPIC_API_KEY` already exists, click it → **Update** and paste the new value. Otherwise, click **New repository secret**, name it `ANTHROPIC_API_KEY`, and paste the value.

Note: this is a pay-per-token API key, billed separately from any Claude.ai/Pro/Max subscription. See [console.anthropic.com/settings/billing](https://console.anthropic.com/settings/billing) for usage and cost.

## Renewing / rotating the key

Rotate the key if it's been exposed (e.g. leaked in a log or committed by mistake) or on a routine security schedule:

1. Create a **new** key in the console first (don't delete the old one yet), following the steps above.
2. Update the `ANTHROPIC_API_KEY` repository secret with the new value (step 4–5 above).
3. Open a test PR (or push a commit to an existing one) and confirm the `Claude PR Review` workflow run succeeds under the **Actions** tab.
4. Once confirmed working, go back to the console and **revoke/delete the old key**.

## Alternative: subscription-based auth (no API cost)

If you'd rather use an existing Claude Pro/Max subscription instead of a pay-per-token API key:

1. Install the standalone CLI locally: `npm install -g @anthropic-ai/claude-code`.
2. Run `claude setup-token` and complete the browser login. It prints a long-lived OAuth token.
3. Save it as a repository secret named `CLAUDE_CODE_OAUTH_TOKEN` (same Settings path as above).
4. Update [workflows/claude-pr-review.yml](workflows/claude-pr-review.yml) to pass `claude_code_oauth_token: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}` instead of `anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}`.

This token is tied to the subscription and will need to be regenerated (repeat the steps above) if it expires or is revoked.
