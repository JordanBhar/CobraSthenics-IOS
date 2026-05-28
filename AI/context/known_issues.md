# Known Issues

Categorized list of known gaps, technical debt, and rough edges in the current implementation. Update as items are resolved or new issues surface.

## Architecture Gaps

- **No use-cases layer.** Architecture spec (`Docs/Architecture/architecture.md` §4) prescribes use cases between view models and repositories. Current code skips them and calls repositories from view models directly.
- **View models use `ObservableObject` + `@Published`** instead of the prescribed `@Observable` macro (architecture.md ADR-001, `swift_style_guide.md`).
- **`Models/` is shared across Presentation and Data.** Architecture spec separates Domain entities into per-feature `Domain/Entities/` folders. Acceptable for the prototype but a future refactor target.
- **No typed domain failures.** `AppFailure` enum + `ErrorMapper` (architecture.md §10) are not implemented; errors propagate untyped from `FirebaseAppRepository.notImplemented`.
- **`DomainMapper` protocol is defined but unused.** No concrete mappers exist.
- **`RemoteDTO` marker protocol is defined but no DTO conforms to it.** Firestore DTOs (per database.md §6) are not yet built.

## Backend / Persistence

- **`FirebaseAppRepository` throws `notImplemented` for all 12 methods.** No Firebase SDK references anywhere in the project.
- **SwiftData `@Model` classes are unwired.** `LocalWorkoutSession`, `LocalSkillLog`, `LocalExerciseCache` exist with `pendingSync` flags but are never read or written.
- **No `ModelContainer` / `ModelContext` injection** anywhere in `App/AppEnvironment.swift` or `App/CobraSthenicsApp.swift`.
- **No sync queue.** The local-first → Firestore flow described in `database.md` §7 is unimplemented.
- **No Remote Config schema-version handling** for the exercise database refresh path (database.md §7).

## Feature Gaps (highest-impact)

- **No Auth.** No sign-in surface, no onboarding wizard. App boots straight into Home with sample data.
- **No active workout flow.** `TrainView` is a hub only — there is no `ActiveWorkoutView` for set logging (Spec S-10).
- **No timed-hold skill session.** `SkillDetailView` is a stub.
- **No paywall and no subscription enforcement.** `UserProfile.isPremium` exists but no UI gates premium features.
- **No progress photo capture or upload.**
- **No body weight / measurement logging.**
- **No push notifications.** `NotificationsView` shows preferences but nothing is delivered.

## UI / Design

- **`ExerciseVideoSection` is a placeholder.** No video playback wiring.
- **Splash screen not implemented** (Spec S-01).
- **Some settings detail routes return `EmptyView`** for unimplemented destinations — review `SettingsRoute` in `Models/User/SettingsModels.swift` to enumerate which.
- **No Dynamic Type validation** has been done across feature screens — copy may break at AX1+ sizes.
- **VoiceOver labels** for training controls (set rows, timers, completion CTAs) are not yet audited — required by `architecture.md` §6 and `product_spec.md` §7.8.

## Testing

- **No ViewModel tests.** All five feature view models lack `XCTestCase` coverage.
- **No UI tests.** XCUITest target may exist but no flows are covered.
- **No snapshot tests.** Critical screens (Home, Train, Profile) have no visual regression coverage.
- **No Firebase Rules tests.** Not applicable until Firestore is wired.

## Operational / Tooling

- **No CI configuration found.** `git_workflow.md` references PR-driven flow but no GitHub Actions or Xcode Cloud workflow files are in the repo.
- **No Firebase project linked.** `GoogleService-Info.plist` is not in the project.
- **No SwiftLint or SwiftFormat config.** Style is enforced by convention only.
- **No `.env` / secret management approach documented** for RevenueCat keys, Firebase API keys, etc.

## Risk Items

- **Schema versioning is referenced in models** (`schemaVersion` fields in `database.md`) but no client-side migration code exists. Once Firestore data starts flowing, a missed schema bump could break old clients.
- **Personal records are described as server-owned** (`database.md` §8) — once the client begins reading `personalRecords/{exerciseId}`, the client must not write to that path.
- **Subscription state is locally modeled** (`UserProfile.isPremium`). When RevenueCat integration lands, this must not be the security source of truth; entitlement must come from server-written fields.
