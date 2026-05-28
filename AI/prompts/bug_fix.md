# Bug Fix

Use this prompt to fix a defect — UI regression, crash, incorrect state, mapping bug, or visual rule violation.

---

## Required reading

1. `Docs/Engineering/source_of_truth.md` — authority hierarchy
2. `AI/context/known_issues.md` — confirm this isn't a tracked gap (vs. a regression)
3. `AI/context/architecture_summary.md` — understand which layer owns the bug
4. The relevant doc for the affected area:
   - UI bug → `Docs/Design/ui_rules.md` + `Docs/Design/design_system.md`
   - State bug → `Docs/Architecture/architecture.md` §4, §6 + `Docs/Engineering/coding_guidelines.md` §4
   - Mapping / data bug → `Docs/Architecture/database.md` §6
   - Sync bug → `Docs/Architecture/database.md` §7

## Reproduction first

Before changing code:

- [ ] Reproduce the bug in a `#Preview` or via `XcodeRefreshCodeIssuesInFile` or `ExecuteSnippet`
- [ ] Capture the exact symptom (crash log, screenshot, mis-rendered state, wrong value)
- [ ] Identify the smallest input that triggers it
- [ ] If the bug is reported but cannot be reproduced, document the gap and stop — do not speculate-fix

## Root cause

Diagnose, don't patch:

- [ ] Identify the layer where the bug originates (Presentation / view model / repository / mapper / model)
- [ ] Trace the data flow from source to render
- [ ] Confirm whether the bug is the symptom of a deeper architectural gap (e.g., missing use-case, untyped error) — if so, log it in `AI/context/known_issues.md` even if you fix only the surface

## Scope discipline

Do not refactor unrelated code. From `git_workflow.md`:

> Avoid broad refactors inside feature PRs unless the refactor is necessary for the change.

- [ ] Fix only the bug
- [ ] Do not rename, restyle, or "improve" code that wasn't broken
- [ ] If you find a second bug, log it in `AI/context/known_issues.md` and leave it for a separate PR (unless it's blocking the current fix)

## Visual bug specifics

- [ ] Re-check the violated UI rule (cite the section, e.g., "card missing 1px `#242424` border per `ui_rules.md` §8.1")
- [ ] Fix by using the appropriate design-system primitive — do not inline the correct hex value
- [ ] Verify the fix in `#Preview` for: default state, Dynamic Type AX1, and the failing repro state

## State bug specifics

- [ ] Add or update a ViewModel test that reproduces the bug before the fix
- [ ] Confirm the test fails on the broken code
- [ ] Apply the fix and confirm the test passes
- [ ] Add an additional test for the boundary case if not covered

## Mapping bug specifics

- [ ] Add a `ModelMappingTests` case covering the broken transformation
- [ ] If the bug came from missing optional handling, also add the "field missing" case
- [ ] Confirm the model still decodes when an unknown enum value appears (test for fallback behavior — see existing `Difficulty` / `SkillStatus` patterns)

## Sync / persistence bug specifics

- [ ] Confirm the bug isn't a "we never implemented this yet" — see `AI/context/known_issues.md` Backend / Persistence section
- [ ] If real: add a test that exercises the failing path with a fake local + remote data source
- [ ] Never relax server-owned aggregate rules (PRs, entitlement) to work around a client-side bug

## Done criteria

- [ ] Bug no longer reproduces in the failing scenario
- [ ] At least one new test covers the fix (where applicable)
- [ ] No unrelated files modified
- [ ] If the bug exposed a doc inaccuracy, update the doc in the same PR
- [ ] If the bug surfaced an architectural gap, append it to `AI/context/known_issues.md`
