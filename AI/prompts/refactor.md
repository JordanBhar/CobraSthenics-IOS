# Refactor

Use this prompt to plan and execute a structural change — extracting a component, splitting a view, introducing a use case, migrating to `@Observable`, splitting a repository, etc.

---

## Required reading

1. `Docs/Engineering/source_of_truth.md`
2. `AI/context/architecture_summary.md`
3. `AI/context/technical_decisions.md` — the divergences are deliberate; understand them before "fixing" them
4. `Docs/Architecture/architecture.md`
5. `Docs/Engineering/coding_guidelines.md`
6. `Docs/Engineering/git_workflow.md`

## Pre-refactor questions

Answer before touching code:

- What is the user-visible behavior change? **It should be zero.** A refactor that changes behavior is not a refactor.
- What architectural rule is being closed? Cite the doc + section.
- Is this divergence currently *deliberate* (see `AI/context/technical_decisions.md`)? If yes, this may not be a refactor — it may be a migration that needs broader buy-in.
- Is the surrounding code consistent? Refactoring one file out of step with a feature is usually worse than the divergence.

## Scope discipline

From `git_workflow.md`:

> Avoid broad refactors inside feature PRs unless the refactor is necessary for the change.

- [ ] One refactor per PR
- [ ] No drive-by renames in unrelated files
- [ ] No format-only edits mixed in
- [ ] The PR title is the refactor name (e.g., "Extract `ExerciseFilterChips` from `LibraryView`")

## Common refactors and their checklists

### Migrate a view model to `@Observable`

- [ ] Replace `class X: ObservableObject` with `@Observable final class X`
- [ ] Remove `@Published` from properties
- [ ] Keep `@MainActor`
- [ ] In consuming views, change `@StateObject` → `@State` for owned view models
- [ ] In consuming views, change `@ObservedObject` → bare `let viewModel: X` (or remove the property wrapper)
- [ ] Run the build; fix call sites
- [ ] Add or update view-model tests if they previously used Combine's `objectWillChange`

### Extract a reusable component

- [ ] Confirm the visual appears in ≥2 features (or is about to)
- [ ] Follow `AI/prompts/reusable_component.md`
- [ ] Move the source to `DesignSystem/Components/<group>/`
- [ ] Replace inline usage with the new primitive
- [ ] Provide a `#Preview`
- [ ] Update consuming views

### Introduce use cases for a write path

- [ ] Identify the write path (e.g., active workout set logging)
- [ ] Create the use-case struct in `Models/UseCases/` (or future per-feature `Domain/UseCases/`)
- [ ] Use case is `Sendable`, takes the repository via init, exposes `callAsFunction`
- [ ] View model now holds the use case, not the repository
- [ ] Update `App/AppEnvironment.swift` to wire the use case
- [ ] Update view model tests to inject a fake use case
- [ ] Update `AI/context/technical_decisions.md` to note this divergence is being closed for this flow

### Split a repository

- [ ] Confirm the new split aligns with a real product boundary (not just file size)
- [ ] Define the new protocol in `Data/Repositories/`
- [ ] Add the new responsibility to `AppRepository` typealias
- [ ] Implement in `SampleDataRepository`
- [ ] Stub in `FirebaseAppRepository`
- [ ] Update all call sites
- [ ] Run all tests

### Wire SwiftData into a repository

- [ ] Define the `@Model` class in `Data/Persistence/` (already done for `LocalWorkoutSession`, `LocalSkillLog`, `LocalExerciseCache`)
- [ ] Add a `PersistenceController` that owns a `ModelContainer`
- [ ] Inject `ModelContext` into the repository implementation via init
- [ ] Implement read + write paths using `FetchDescriptor`
- [ ] Map `@Model` records to domain entities via a mapper
- [ ] Add tests using an in-memory `ModelConfiguration`
- [ ] Update `AI/context/project_status.md` SwiftData line

## Quality bar

- [ ] Build passes
- [ ] All existing tests still pass
- [ ] At least one test exercises the refactored boundary (if applicable)
- [ ] No unrelated files modified
- [ ] No design system rules violated
- [ ] No behavior change in `#Preview` for affected views

## Documentation

- [ ] If the refactor closes a tracked divergence: remove the row in `AI/context/technical_decisions.md`
- [ ] If the refactor introduces a new pattern others should follow: add a brief note to the relevant `Docs/` file (only if the doc explicitly opens that pattern)
- [ ] If the refactor adds a new design system primitive: update `Docs/Design/design_system.md` is **not** required, but the file in `DesignSystem/Components/` must follow the naming + recipe rules

## Done criteria

- Behavior unchanged
- Build + tests pass
- One coherent change, one PR
- Divergence in `AI/context/technical_decisions.md` updated (closed or scoped)
