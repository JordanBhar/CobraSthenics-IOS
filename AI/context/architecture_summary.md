# Architecture Summary

## Prescribed Architecture (from `Docs/Architecture/architecture.md`)

Clean Architecture, feature-first, dependencies pointing inward:

```
Presentation -> Domain <- Data
```

- **Domain** — pure Swift: entities, value objects, use cases, repository protocols, domain failures. No SwiftUI, Firebase, SwiftData, URLSession, RevenueCat, or StoreKit imports.
- **Data** — repository implementations, Firebase/SwiftData/CoreData adapters, DTOs, mappers, sync queues, error mapping.
- **Presentation** — SwiftUI views + `@Observable` `@MainActor` view models + typed navigation routes.

Feature-first folders group `Domain/`, `Data/`, `Presentation/` inside each product area (Workout, Skills, ExerciseDatabase, Analytics, Subscription).

## Current Implementation Shape

The codebase currently runs a **simplified MVVM + Repository** pattern, not the full Clean Architecture with use cases. See `project_status.md` and `technical_decisions.md` for the deliberate decisions and gaps.

```
CobraSthenics/
├── App/                      AppEnvironment, AppShell (TabView), CobraSthenicsApp
├── Core/                     Utilities, Networking stub, KeyValueStorage, AppConstants
├── Data/
│   ├── Repositories/         Protocols: User, Workout, Exercise, Skill, Program, App
│   ├── Firebase/             FirebaseAppRepository (all methods throw .notImplemented)
│   ├── DTOs/                 RemoteDTO marker protocol only
│   ├── Mappers/              DomainMapper protocol only (unused)
│   └── Persistence/          SwiftData @Model: LocalWorkoutSession, LocalSkillLog, LocalExerciseCache (not wired)
├── DesignSystem/             Theme, Typography, 15 components, animations, layout, modifiers
├── Features/
│   ├── Home/                 ViewModels/ + Views/
│   ├── Exercise Library/     ViewModels/ + Views/
│   ├── Profile/              ViewModels/ + Views/
│   ├── Skills/               ViewModels/ + Views/
│   ├── Train/                ViewModels/ + Views/
│   └── Settings/             Views/ (sub-screens reachable from Profile)
└── Models/                   Shared domain types (also used directly by views)
```

## Key Differences vs. Prescribed Spec

| Concern | Prescribed | Current |
|---|---|---|
| Layering | Domain / Data / Presentation per feature | Flat: ViewModels + Views per feature, shared `Models/` |
| Use cases | `LogSetUseCase`, `LogSkillSessionUseCase`, etc. | None — view models call repositories directly |
| View model | `@Observable` `@MainActor` | `ObservableObject` + `@Published` + `@MainActor` |
| Repositories | Per-feature protocols + Firebase + SwiftData impls | Six small protocols, only `SampleDataRepository` populated; `FirebaseAppRepository` stubbed |
| Local persistence | SwiftData wired through repositories | SwiftData `@Model` classes exist but unwired |
| Navigation | Typed `NavigationStack` routes per feature | TabView root + per-feature `NavigationStack`; settings routing via `SettingsRoute` enum |

## Composition Root

`App/AppEnvironment.swift` holds a single `AppRepository` typealias (`UserRepository & WorkoutRepository & ExerciseRepository & SkillRepository & ProgramRepository`) and seeds it with `SampleDataRepository` for previews. `AppShell.swift` instantiates each feature ViewModel with the shared repository.

## External Services

- **Firebase Auth / Firestore / Storage / FCM / Remote Config / Cloud Functions / Crashlytics / Analytics** — referenced in docs and stubbed in code; no SDK integration yet.
- **RevenueCat / StoreKit 2** — referenced in docs; no implementation.

## Tests

`CobraSthenicsTests/` contains `ModelMappingTests` (4 tests covering Difficulty / SkillStatus decoding fallbacks, XP math, PR display priority) and `RepositoryTests` (3 async tests against `SampleDataRepository`). No ViewModel, Firebase, persistence, or UI tests yet.
