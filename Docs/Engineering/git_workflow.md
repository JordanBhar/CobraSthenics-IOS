# CobraSthenics — Git Workflow

## Branches

Use short, descriptive branches:

- `feature/skill-progress`
- `fix/session-mapping`
- `docs/design-system`

## Commits

Commit focused changes. A commit should explain one coherent change.

Good commit subjects:

- `Add skill progress mapping tests`
- `Move UI rules into Docs structure`
- `Fix active program empty state`

## Pull Requests

Each PR should include:

- What changed
- Why it changed
- Screenshots for UI changes
- Tests or validation performed
- Known follow-up work

## Review Standard

Reviews should prioritize correctness, architecture boundaries, UI rule compliance, and missing tests. Avoid broad refactors inside feature PRs unless the refactor is necessary for the change.

## Generated Or Tool Edits

When AI or code generation changes files, review the diff before committing. Confirm no unrelated styling, project metadata, or file movement slipped in.
