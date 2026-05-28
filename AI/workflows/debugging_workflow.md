# Debugging Workflow

Workflow for diagnosing and fixing a bug in CobraSthenics. Designed for MCP-assisted debugging inside Xcode.

---

## Step 1 — Reproduce

Before opening any source file:

- [ ] Reproduce the bug deterministically in the simulator, a `#Preview`, or via `ExecuteSnippet`.
- [ ] Capture: exact symptom (screenshot / log / stack trace), the steps to reproduce, the smallest input that triggers it, and the iOS / device target.
- [ ] If you cannot reproduce: document the gap and stop. Do not speculate-fix.

## Step 2 — Classify

Identify the bug's layer:

| Bug class | Likely layer | Likely files |
|---|---|---|
| Wrong number / wrong label rendered | Presentation or mapper | `Features/<X>/Views/`, `Models/`, mappers |
| Crash on input | Domain or mapper | `Models/`, `Data/Mappers/`, view model |
| Crash on launch | App layer | `App/CobraSthenicsApp.swift`, `App/AppEnvironment.swift`, `App/AppShell.swift` |
| Wrong visual | Design system or view | `DesignSystem/`, view file |
| Stale data | View model loading logic or repository | `Features/<X>/ViewModels/`, `Data/Repositories/` |
| Lost write | Persistence or sync | `Data/Persistence/`, sync queue (not yet implemented) |
| Auth failure | Auth adapter (not yet implemented) | future `Data/Firebase/Auth*` |
| Subscription gate misbehaving | Premium gating logic | UI gate + entitlement read |

## Step 3 — Cross-reference known issues

Open `AI/context/known_issues.md` and check whether the bug is a tracked gap rather than a regression.

- If tracked gap: the fix is a feature implementation, not a bug fix. Switch to `feature_workflow.md`.
- If regression: continue.

## Step 4 — Locate the root cause

Use MCP tools to navigate without re-running the app:

1. `XcodeGrep` for the symptom string, the type name, or the unique identifier in the bug report.
2. `Grep` (project-wide) for cross-file usage.
3. `XcodeRefreshCodeIssuesInFile` on the suspect file for live diagnostics.
4. Read top-down: view → view model → repository → mapper → DTO / model.
5. For state bugs, walk the explicit state machine in the view model.

Do not patch the symptom — find where the wrong value originates.

## Step 5 — Write a failing test first

Where possible:

- Mapping bug → add a `ModelMappingTests` case that reproduces the bug.
- Domain logic bug → add a unit test against the use case (or view model, until use cases exist).
- Repository bug → add a `RepositoryTests` case against fake data sources.
- ViewModel state bug → add a `@MainActor` test asserting the broken transition.

Confirm the test fails before fixing.

## Step 6 — Fix at the root

- Edit the file at the root cause, not a downstream consumer.
- Keep the fix minimal — no opportunistic refactoring.
- If the bug exposes an architectural gap (e.g., should have been a use case all along), file it in `AI/context/known_issues.md` and address separately.

## Step 7 — Verify

- [ ] Failing test now passes
- [ ] Bug no longer reproduces in the original repro steps
- [ ] `BuildProject` succeeds
- [ ] `RunAllTests` or `RunSomeTests` covering the affected area still passes
- [ ] `XcodeRefreshCodeIssuesInFile` clean on changed files
- [ ] If UI: visually re-check on canvas at default + AX1 Dynamic Type

## Step 8 — Update tracking

- [ ] Remove the bug from `AI/context/known_issues.md` if it was tracked there
- [ ] If the fix exposed a new gap: add it to `AI/context/known_issues.md`
- [ ] If the fix updated a state machine or behavior contract: confirm `AI/context/feature_matrix.md` still reflects reality

## Step 9 — Commit and PR

Follow `Docs/Engineering/git_workflow.md`:

- Branch: `fix/<short-name>` (e.g., `fix/session-mapping`)
- Commit subject: imperative, one-line (e.g., `Fix active program empty state`)
- PR body: what / why / how reproduced / how verified / linked test

## Common debugging traps in CobraSthenics

- **Bug actually a missing feature.** Check `AI/context/feature_matrix.md` — if the row is TODO or PARTIAL, the missing behavior is intentional. Use the feature workflow instead.
- **Sample data discrepancy.** Many "wrong number" bugs trace to `SampleDataRepository`, not a logic bug. Confirm the rendered value matches the sample input.
- **Stale preview canvas.** Xcode previews can cache; force a rebuild before assuming the bug.
- **`ObservableObject` not republishing.** Ensure `@Published` is on the property and the consuming view uses `@StateObject` / `@ObservedObject` consistently. (This goes away once we migrate to `@Observable`.)
- **Force unwrap on optional model field.** `Models/` types include optionals (e.g., `PersonalRecord.reps`); ensure callers use `??` or `if let`.
- **Color used without going through `AppColor`.** Visual bugs often come from inline `Color(hex:...)` instead of an `AppColor` token. Replace, then verify against `Docs/Design/ui_rules.md` §2.
