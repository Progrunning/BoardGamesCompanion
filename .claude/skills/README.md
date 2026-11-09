# Vendored skills

These skills are committed into the repo (rather than living only in a developer's personal `~/.claude/skills/`) so that Claude Code can invoke them anywhere the repo is checked out: cloud sessions on claude.ai, and the GitHub Actions runner. The automated agent workflow (`.github/workflows/claude-issue-agent.yml`) relies on `/implement` being available on the runner.

## Source

Every skill here is Matt Pocock's, copied verbatim from the `mattpocock-skills` plugin (`.claude-plugin/plugin.json`) at <https://github.com/mattpocock/skills>.

- **Version:** plugin `1.3.2`, commit `4ae2317ddb22b046e26455e4f9c9b3aaaf62212d`
- **License:** MIT, see `LICENSE-mattpocock-skills`
- **Not copied:** each skill's `agents/openai.yaml` (Codex metadata, unused by Claude Code), and the upstream `in-progress/`, `misc/` and `deprecated/` skills, which aren't part of the published plugin.

To update: re-clone the upstream repo, then copy each directory listed in its `.claude-plugin/plugin.json` `skills` array over the matching directory here, and bump the version and commit above.

## What's here

- **Engineering:** `ask-matt`, `code-review`, `codebase-design`, `diagnosing-bugs`, `domain-modeling`, `grill-with-docs`, `implement`, `implement-spec`, `improve-codebase-architecture`, `pr`, `prototype`, `research`, `retro`, `setup-matt-pocock-skills`, `tdd`, `to-spec`, `to-tickets`, `triage`, `wayfinder`, `wizard`
- **Productivity:** `grill-me`, `grilling`, `handoff`, `teach`, `to-questionnaire`, `wait-what`, `writing-for-agents`

## The CI agent skips `/code-review`

`/implement`'s final step is `/code-review`. The CI agent's prompt tells it to skip that step, because the separate PR-review workflow (`.github/workflows/claude-pr-review.yml`) already reviews every pull request the agent opens. `/code-review` is vendored for interactive use only.
