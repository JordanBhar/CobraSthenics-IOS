# Architecture Review

Use this prompt to audit a part of the codebase for architectural compliance, or to evaluate whether a proposed structural change fits the project.

---

## Required reading

1. `Docs/Engineering/source_of_truth.md` — full document
2. `Docs/Architecture/architecture.md` — full document
3. `Docs/Architecture/backend_architecture.md`
4. `Docs/Architecture/database.md`
5. `AI/context/architecture_summary.md` — current shape vs. spec
6. `AI/context/technical_decisions.md` — deliberate divergences
7. `Docs/Engineering/coding_guidelines.md`

## Review scope

State up front what you are reviewing:

- A feature module (e.g., `Features/Train/`)
- A layer (e.g., all of `Data/Repositories/`)
- A proposed change (e.g., introducing use cases for the active workout flow)

## Boundary audit

For each file in scope, classify it by layer (Presentation / Domain / Data) and verify allowed imports:

| Layer | Allowed | Forbidden |
|---|---|---|
| Presentation (`Features/<X>/Views/`, `Features/<X>/ViewModels/`) | SwiftUI, Observation, design system, domain models, view-model-local types | Firebase, SwiftData, CoreData, URLSession, RevenueCat, StoreKit |
| Domain (`Models/`, future `Features/<X>/Domain/`) | Foundation value types, domain entities, repository protocols, use cases, failures | Everything in Forbidden + `SwiftUI` |
| Data (`Data/`, `Features/<X>/Data/`) | Firebase iOS SDKs, SwiftData / CoreData, URLSession, DTOs, mappers, repository implementations | None — Data may import anything |

Flag any cross-layer import violations explicitly.

## Dependency direction audit

Verify: `Presentation -> Domain <- Data`. Specifically:

- [ ] No Domain file imports `SwiftUI`, `FirebaseFirestore`, `SwiftData`, `CoreData`, `URLSession`, `RevenueCat`, `StoreKit`
- [ ] No Presentation file imports any Data implementation directly (only protocol types from `Data/Repositories/` are acceptable today; future state should isolate domain protocols)
- [ ] Repository protocols are referenced via the `AppRepository` typealias from `App/AppEnvironment.swift`

## State + Observation audit

- [ ] View models are `@MainActor`
- [ ] View models are `@Observable` (preferred) or `ObservableObject` (currently used) — call out the migration target
- [ ] View models expose explicit state machines (idle / loading / loaded / empty / failed / saving)
- [ ] No business logic inside views

## Data layer audit

- [ ] Repositories return domain entities (never DTOs)
- [ ] DTOs are `Codable`, live in `Data/DTOs/`, and convert via mappers in `Data/Mappers/`
- [ ] SwiftData `@Model` classes stay in `Data/Persistence/` and map to domain via dedicated mappers
- [ ] Writes follow offline-first: SwiftData first → queued Firestore upload
- [ ] No view model touches a Firestore path or a SwiftData `ModelContext` directly

## Use cases audit (current vs. future)

The current code skips use cases (see `AI/context/technical_decisions.md`). For the scope under review, determine:

- [ ] Are use cases needed here? (Yes if the flow is write-heavy or coordinates multiple repositories)
- [ ] If yes, define them: `LogSetUseCase`, `CompleteWorkoutUseCase`, `LogSkillSessionUseCase`, etc.
- [ ] Each use case is `Sendable`, takes its dependencies via init, exposes `callAsFunction`
- [ ] View models inject use cases, not repositories, for write paths

## Navigation audit

- [ ] Navigation uses `NavigationStack` + typed `Hashable` routes
- [ ] No string-based deep links
- [ ] Bottom-tab structure unchanged (5 tabs, locked order)
- [ ] Intra-tab navigation is owned by the feature root view

## Concurrency audit

- [ ] Async work uses `async` / `await`
- [ ] Streaming updates use `AsyncSequence` / `AsyncStream`
- [ ] Combine appears only where integrating with a publisher API
- [ ] Repositories and services are `Sendable` where feasible
- [ ] No detached tasks without explicit cancellation strategy

## Error handling audit

- [ ] Repository methods throw or return `Result<T, AppFailure>` (or document why not)
- [ ] SDK errors converted in the Data layer; never reach Presentation as raw `NSError`
- [ ] Views surface user-friendly messages via the view model, not raw errors

## Sync / consistency audit (if persistence is involved)

- [ ] Local writes are immediate, UI does not wait for network
- [ ] Server-owned aggregates (personal records, entitlement) are read-only from the client
- [ ] Conflict resolution rule documented: newest non-deleted client edit wins for user-authored fields
- [ ] `schemaVersion` present on persisted records and DTOs

## Anti-pattern sweep

From `coding_guidelines.md` §10:

- [ ] No Firebase imports in SwiftUI views
- [ ] No SwiftData `@Model` objects passed to Domain
- [ ] No Firestore paths constructed in view models
- [ ] No JSON parsing in views
- [ ] No global singletons for repositories
- [ ] No generic error strings hiding network/persistence failures
- [ ] RevenueCat / StoreKit client state is not the security source of truth
- [ ] App launch does not block on full DB sync

## Output format

Write the review as a structured report:

1. **Scope** — what you reviewed
2. **Findings** — grouped by severity (Block / Should-Fix / Nice-to-Have)
3. **Boundary violations** — explicit list with file + line references
4. **Migration suggestions** — if applicable
5. **Updates needed in AI context files** — flag any `AI/context/*.md` that should be updated based on findings
