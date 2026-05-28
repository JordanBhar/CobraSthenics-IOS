# Architecture Workflow

End-to-end workflow for proposing, reviewing, and landing an architectural change in CobraSthenics.

---

## When to use this workflow

Use this workflow when the change:

- Closes a tracked divergence in `AI/context/technical_decisions.md`
- Introduces a new layer or boundary (use cases, sync queue, persistence controller)
- Changes the dependency graph
- Moves files between layers
- Adds a new external service or SDK

Do **not** use this workflow for routine feature work — that belongs to `feature_workflow.md`.

## Step 1 — State the architectural problem

Write a one-paragraph problem statement. Include:

- The specific rule from `Docs/Architecture/architecture.md` (or another authoritative doc) that the change addresses
- The current shape (cite files and lines)
- The proposed end shape (cite the spec)
- Why the change is needed now (not later)

## Step 2 — Required reading

1. `Docs/Engineering/source_of_truth.md`
2. `Docs/Architecture/architecture.md`
3. `Docs/Architecture/backend_architecture.md`
4. `Docs/Architecture/database.md`
5. `AI/context/architecture_summary.md`
6. `AI/context/technical_decisions.md`
7. `Docs/Engineering/coding_guidelines.md`

## Step 3 — Use the architecture review prompt

Run `AI/prompts/architecture_review.md` against the scope to gather findings. Capture the output as the baseline.

## Step 4 — Design the change

Draft the change as a structured plan:

- **Scope:** which files / layers / features are touched
- **Migration steps:** ordered, atomic, each individually shippable when possible
- **Dependency direction proof:** show the new imports respect `Presentation -> Domain <- Data`
- **Concurrency posture:** which types become `Sendable`, which become `@MainActor`
- **Persistence implications:** if SwiftData / Firestore are touched, walk through the read + write paths
- **Sync implications:** if the change affects offline behavior
- **Backwards compatibility:** how existing features keep working during migration
- **Test plan:** which existing tests must still pass; which new tests must be added

## Step 5 — Land in small steps

Architectural changes land in multiple PRs whenever the work allows:

1. **Add the new pattern alongside the old** — both work simultaneously.
2. **Migrate one feature to the new pattern** — proves the pattern in production.
3. **Migrate remaining features** — one feature per PR.
4. **Remove the old pattern** — only after all consumers are migrated.

Do not mix the four phases in one PR.

## Step 6 — Update tracking

After each PR:

- [ ] Update `AI/context/technical_decisions.md` — narrow or close the divergence row as scope shrinks
- [ ] Update `AI/context/architecture_summary.md` if the "Current Implementation Shape" diagram changes
- [ ] Update `AI/context/project_status.md` if a system moves from STUB → wired
- [ ] If the change affects rules other people follow, consider updating `Docs/Architecture/architecture.md` itself (requires architecture team review per `git_workflow.md`)

## Step 7 — Validate

- [ ] `BuildProject` succeeds
- [ ] Full test suite (`RunAllTests`) passes
- [ ] No new SDK imports in Presentation
- [ ] No new SwiftUI imports in Domain
- [ ] `XcodeRefreshCodeIssuesInFile` shows zero diagnostics on touched files
- [ ] Walk through `AI/prompts/architecture_review.md` boundary audit on the changed scope

## Common architectural workflows in CobraSthenics

### Migrating view models to `@Observable`

1. PR 1: Migrate one feature (e.g., `Features/Home/`) — update `HomeViewModel` and `HomeView` together; verify preview + tests.
2. PR 2–6: Migrate Train, Library, Skills, Profile, Settings one at a time.
3. PR 7: Audit that `ObservableObject` is no longer used; close the divergence row in `AI/context/technical_decisions.md`.

### Introducing use cases

1. PR 1: Introduce one use case for an existing write path (e.g., `LogSetUseCase` once active workout is implemented). Document the pattern in `AI/context/technical_decisions.md`.
2. PR 2+: Apply the pattern to subsequent write paths as they're built.
3. Do not retroactively wrap every read path — use cases are for write paths and multi-repo coordination.

### Wiring SwiftData

1. PR 1: Add a `PersistenceController` in `Core/` that owns a `ModelContainer`. Inject `ModelContext` via `AppEnvironment`.
2. PR 2: Wire `LocalWorkoutSession` through `WorkoutRepository` (read path first).
3. PR 3: Wire write path for `WorkoutRepository`.
4. PR 4: Wire `LocalSkillLog` through `SkillRepository`.
5. PR 5: Wire `LocalExerciseCache` through `ExerciseRepository`.
6. PR 6: Introduce the sync queue (separate workflow — see below).

### Introducing the sync queue

1. PR 1: Define the `SyncQueue` protocol + a no-op implementation. Wire into write paths but make it a pass-through.
2. PR 2: Implement the persistent queue (SwiftData-backed) with retry policy.
3. PR 3: Wire Firestore uploads behind the queue.
4. PR 4: Add tests for offline write → reconnect → upload + retry on failure + conflict resolution.

### Adding Firebase SDKs

1. PR 1: Add Firebase iOS SDKs via Swift Package Manager. Add `GoogleService-Info.plist` for `staging` environment only. Wire `FirebaseApp.configure()` in `CobraSthenicsApp`.
2. PR 2: Wire Auth (Apple + Google + Email/Password).
3. PR 3: Wire Firestore reads for `exercises/` (lowest-risk collection — read-only globally).
4. PR 4: Wire Firestore reads for `users/{uid}`.
5. PR 5+: Wire writes once the sync queue exists.
