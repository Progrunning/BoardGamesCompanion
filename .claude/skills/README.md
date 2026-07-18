# Vendored skills

These skills are committed into the repo (rather than living only in a developer's personal `~/.claude/skills/`) so that Claude Code running on a GitHub Actions runner can invoke them. The automated agent workflow (`.github/workflows/claude-issue-agent.yml`) relies on `/implement` being available on the runner.

## What's here

- **`implement/`** — the standard implementation flow: work test-first at the ticket's stated seams (via `/tdd`), run typechecking and tests, then commit.
- **`tdd/`** — test-driven development guidance and its supporting references.

## Intentionally NOT vendored: `/code-review`

`/implement`'s final step is normally `/code-review`. We deliberately do **not** vendor `/code-review` here, and the CI agent skips that step, because review is already handled by the separate PR-review workflow (`.github/workflows/claude-pr-review.yml`) which fires on every pull request the agent opens. Developers working locally retain their own personal `/code-review`. Do not "fix" this apparent omission.
