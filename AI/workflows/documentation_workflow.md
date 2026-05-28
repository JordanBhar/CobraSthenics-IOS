# Documentation Workflow

Workflow for keeping CobraSthenics docs and AI context files accurate as the codebase evolves.

---

## Documentation hierarchy (precedence)

Per `Docs/Engineering/source_of_truth.md`:

1. `Docs/Engineering/source_of_truth.md`
2. `Docs/Product/product_spec.md`
3. `Docs/Architecture/architecture.md`
4. `Docs/Engineering/coding_guidelines.md`
5. `Docs/Architecture/database.md`
6. `Docs/Architecture/backend_architecture.md`
7. `Docs/Design/ui_rules.md`
8. `Docs/Design/design_system.md`
9. `Docs/Design/animations.md`
10. `Docs/Design/branding.md`
11. `Docs/Engineering/swift_style_guide.md`
12. `Docs/Engineering/testing_strategy.md`
13. `Docs/Engineering/git_workflow.md`
14. `Docs/Features/*.md`
15. `AI/prompts/`, `AI/workflows/`, `AI/context/` when populated

If two docs conflict, prefer the more specific document for its domain. `AI/` files describe the **current state** of the project; they must never override `Docs/` rules. When the project evolves and the divergence closes, update `AI/` first — `Docs/` only when the rule changes.

## When to update which file

| Change type | File(s) to update |
|---|---|
| New feature shipped or partially shipped | `AI/context/feature_matrix.md`, `AI/context/project_status.md` |
| System newly wired (Firebase, SwiftData, sync, paywall) | `AI/context/project_status.md`, `AI/context/architecture_summary.md` |
| Architectural divergence introduced or closed | `AI/context/technical_decisions.md` |
| Bug resolved or new gap surfaced | `AI/context/known_issues.md` |
| Roadmap reshuffle | `AI/context/roadmap.md` |
| Brand / persona change | `Docs/Design/branding.md`, `AI/context/app_summary.md` |
| Design system primitive added | New file under `DesignSystem/Components/` + optional note in `Docs/Design/design_system.md` if it changes the rules |
| Architecture rule change | `Docs/Architecture/architecture.md` (requires architecture review per `git_workflow.md`) |
| Coding rule change | `Docs/Engineering/coding_guidelines.md` (requires engineering review) |
| UI rule change | `Docs/Design/ui_rules.md` (requires design review) |
| New external service / integration | `Docs/Architecture/architecture.md` + `Docs/Architecture/backend_architecture.md` + `AI/context/technical_decisions.md` |
| Firestore schema change | `Docs/Architecture/database.md` + migration plan |

## Quick rule

- `Docs/` describes **what should be true** (authoritative rules)
- `AI/context/` describes **what is currently true** (snapshot of the codebase)
- `AI/prompts/` and `AI/workflows/` describe **how to do things consistently** (procedures)

## Standard documentation update flow

### Step 1 — Identify

After every PR, ask:

- Did this PR change which features render? → update `feature_matrix.md`
- Did this PR change what systems are wired? → update `project_status.md` and `architecture_summary.md`
- Did this PR close or open an architectural divergence? → update `technical_decisions.md`
- Did this PR fix or surface an issue? → update `known_issues.md`
- Did this PR change a rule (design, architecture, engineering)? → update the relevant `Docs/` file with review

### Step 2 — Diff-driven update

Read the PR diff and the affected files. Update the AI context file to match reality — not aspiration.

Concrete examples:

- Migrated `HomeViewModel` to `@Observable` → narrow the "View model framework" divergence row in `technical_decisions.md` from "all view models" to "remaining feature view models"
- Implemented active workout set logging → update `feature_matrix.md` rows F-09 through F-14 and the corresponding S-10 screen status; add new tests row to `project_status.md`
- Added Firebase Auth → flip `Firebase Auth` row in `feature_matrix.md` and `project_status.md`; add a section to `architecture_summary.md` describing the auth flow

### Step 3 — Stay terse

`AI/context/` files are loaded into AI agent context windows. Keep them tight:

- Use tables for status and matrices
- One-line bullets, no paragraphs unless necessary
- Cite source docs (`Docs/...md` sections) instead of restating them
- Avoid duplication — link to authoritative docs

### Step 4 — Verify with the doc audit

Periodically (e.g., before each release), audit:

- [ ] `AI/context/feature_matrix.md` rows accurately reflect what renders in the running app
- [ ] `AI/context/project_status.md` accurately describes which systems are wired
- [ ] `AI/context/technical_decisions.md` divergences match the code
- [ ] `AI/context/known_issues.md` entries are still relevant (and removed when fixed)
- [ ] `AI/context/architecture_summary.md` "Current Implementation Shape" matches the actual file tree
- [ ] `AI/context/roadmap.md` reflects current priorities

## Doc audit prompt template

Use this when running an audit:

```
Audit CobraSthenics AI context files against current code state:

1. For each row in AI/context/feature_matrix.md, verify the status matches the running app.
2. For each system in AI/context/project_status.md, verify it's actually wired in code (search for the SDK import or @Model integration).
3. For each divergence row in AI/context/technical_decisions.md, verify the current code still diverges as described.
4. For each entry in AI/context/known_issues.md, verify it's still present.
5. Report differences. Do not edit files — produce a punch list.
```

## Authoritative doc changes

Changes to `Docs/Architecture/`, `Docs/Engineering/`, or `Docs/Design/` files require:

- A separate PR (do not bundle with feature work)
- Review by the relevant team (architecture / engineering / design)
- Update of any downstream files (a UI rule change may require updating components; a database change requires a migration plan)
- Update of `Docs/Engineering/source_of_truth.md` if precedence shifts

## New AI context file

If a new AI context file is needed (e.g., `AI/context/glossary.md`, `AI/context/integrations.md`):

1. Confirm it can't be folded into an existing file
2. Add it under `AI/context/`
3. Reference it from the appropriate prompts and workflows
4. Optionally cite it in `Docs/Engineering/source_of_truth.md` "AI Workflow Prompts" section

## Linkage check

After updating any AI context file, make sure prompts and workflows that reference it still align. For example:

- `AI/prompts/new_feature.md` lists `AI/context/feature_matrix.md` as required reading — if the matrix structure changes, the prompt's instructions should reflect it.
- `AI/workflows/feature_workflow.md` Step 6 lists which context files to update — keep that list current.
