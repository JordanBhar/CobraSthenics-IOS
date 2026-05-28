# Code Review

Use this prompt to review a pull request or proposed change against the project's authoritative standards.

---

## Required reading

1. `Docs/Engineering/source_of_truth.md` — authority hierarchy
2. `AI/context/architecture_summary.md` — current shape vs. spec
3. `Docs/Architecture/architecture.md` — layer rules
4. `Docs/Engineering/coding_guidelines.md` — enforced rules
5. `Docs/Engineering/swift_style_guide.md` — naming, formatting, concurrency
6. `Docs/Design/ui_rules.md` — visual rules (if UI changed)
7. `Docs/Design/design_system.md` — component recipes (if UI changed)

## Review priorities (in order)

1. **Correctness** — does the change do what it claims?
2. **Architecture boundary integrity** — no SDK leaks, dependencies still point inward
3. **Design system + UI rule compliance** for any visible change
4. **Concurrency safety** — `@MainActor`, `Sendable`, structured tasks
5. **Test coverage** for new logic and edited behavior
6. **Doc + tracking updates** — was `AI/context/feature_matrix.md` updated?

## Architecture & layer checks

- [ ] Presentation does not import Firebase, SwiftData, CoreData, URLSession, RevenueCat, or StoreKit
- [ ] Domain models do not import any SDK or `SwiftUI`
- [ ] View models are `@MainActor`. Prefer `@Observable`; if the file uses `ObservableObject`, the rest of the feature should be consistent
- [ ] View models call use cases (or repositories where use cases don't exist yet — see `AI/context/technical_decisions.md`); they do not call Firebase or SwiftData directly
- [ ] No persistence queries or Firestore paths inside SwiftUI views
- [ ] Repository protocols live in `Data/Repositories/`; implementations stay in `Data/`
- [ ] DTOs are `Codable` and stay in the Data layer; no DTOs cross into Presentation
- [ ] Repository methods that perform writes follow the offline-first pattern (local-first, queued sync)

## SwiftUI checks

- [ ] Views are value types and small (extract sub-views if the body is hard to scan)
- [ ] Local view state uses `@State private var`
- [ ] Owned view models use `@State private var viewModel: MyViewModel` (Observation) or `@StateObject` (`ObservableObject`) — consistent with surrounding code
- [ ] No closures capturing `self` strongly inside `Task` blocks where lifetime is at risk
- [ ] Navigation uses `NavigationStack` + typed routes
- [ ] No string-based navigation
- [ ] Async actions use `async` / `await` and `Task { }`; no Combine unless integrating with a publisher API

## Concurrency checks

- [ ] Repositories and services are `Sendable` (or have explicit reasons not to be)
- [ ] No detached tasks unless ownership + cancellation are explicit
- [ ] No data races on `var` properties accessed from non-`MainActor` contexts
- [ ] `AsyncStream` / `AsyncSequence` used for streaming auth / sync / listener updates

## Design / UI checks (if change is visible)

- [ ] Background `#080808`, card `#111111` + 1px `#242424` border + 16px radius + 16px padding
- [ ] Only brand blue `#0A84FF` for interactive accents
- [ ] All numerical values in DM Mono (`appMono*`)
- [ ] Spacing uses `AppSpacing` tokens only (no off-grid pixels)
- [ ] Difficulty pills follow the strict mapping (BEGINNER green / INTERMEDIATE orange / ADVANCED red / ELITE purple)
- [ ] Reuses existing design system primitives where possible
- [ ] No emoji outside `ui_rules.md` §5 inventory; no lorem ipsum
- [ ] Real exercise names + Alex Carter persona in sample copy
- [ ] No backdrop blur / frosted glass
- [ ] Motion durations within 160 / 240 / 360 ms (800 ms exception for progress fills only)
- [ ] No drop shadows except the single bottom-nav lift and the brand-button glow

## Data & persistence checks

- [ ] Firestore-bound DTOs use `Codable`
- [ ] Mappers are explicit; no DTOs returned from repository methods
- [ ] SwiftData `@Model` classes stay in `Data/Persistence/`; never exposed to Presentation
- [ ] `pendingSync` / sync state is tracked on user-authored local records
- [ ] No server-owned aggregate written from the client (PRs, subscription state)
- [ ] `schemaVersion` set on new DTOs / persisted records

## Test checks

- [ ] Domain logic changes have unit tests with fake repositories
- [ ] Mapping changes have `ModelMappingTests` coverage (including missing optional cases)
- [ ] View model state transitions have `@MainActor` tests (where the test infrastructure supports it)
- [ ] Repository behavior changes have tests against fake local + remote data sources
- [ ] Sync changes have tests for offline write → reconnect → upload paths

## Doc checks

- [ ] `AI/context/feature_matrix.md` updated if implementation status changed
- [ ] `AI/context/project_status.md` updated if a system was newly wired
- [ ] `AI/context/known_issues.md` updated if a tracked issue was resolved (or a new one surfaced)
- [ ] `AI/context/technical_decisions.md` updated if an architectural divergence was introduced or closed
- [ ] Public-facing docs (`Docs/`) only change when the author has explicit ownership

## Things to call out (not necessarily block)

- Magic numbers / hex values in views — should use `AppColor` / `AppSpacing`
- Unused `print` / `debugPrint` statements
- New files with no `#Preview` for SwiftUI views
- Repository implementations that block (sync) — should be `async`
- Missed opportunity to reuse an existing design-system primitive

## Things that should always block

- Light-mode variant introduced
- Bottom-tab count, order, or labels changed
- Firebase / SwiftData / RevenueCat types imported into Presentation
- Lorem ipsum or `Workout 1` / `Exercise 1` placeholders
- `force unwrap` (`!`) on values that can be nil under normal user behavior
- Generic `try?` swallowing errors silently in a flow that should surface failure
- `dispatchMain` / `DispatchQueue.main` instead of `@MainActor` or `await MainActor.run`
- Tests deleted without replacement
