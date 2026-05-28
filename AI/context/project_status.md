# Project Status

Last reviewed: 2026-05-25.

## High-Level State

CobraSthenics is currently a **high-fidelity SwiftUI prototype** powered entirely by `SampleDataRepository`. The visual system and primary feature screens are production-quality. Backend integration (Firebase), local persistence wiring (SwiftData), and the architecture-prescribed use-cases layer are not yet implemented.

## What Works End-to-End

- App launches into `AppShell` with the five locked tabs: Home, Train, Library, Skills, Profile.
- All five tabs render real, branded UI populated from `SampleDataRepository`.
- Library tab supports drill-down: categories → exercise list → exercise detail.
- Profile tab supports drill-down into Settings sub-screens (Notifications, Rest Timer, Appearance & Language, Account, Support, Subscription).
- Design system primitives (`AppCard`, `GradientCard`, `PrimaryButton`, `OutlineButton`, `TierDots`, etc.) are used consistently across features.
- Dark-only theme, brand-blue accent, DM Mono numerics, and the strict card border (`#242424`) are honored.

## What's Missing or Stubbed

### Backend & Persistence

- **Firebase SDKs not integrated.** `FirebaseAppRepository.swift` exists with all 12 methods throwing `FirebaseAdapterError.notImplemented`. No Firebase iOS SDK references in code.
- **SwiftData not wired.** `LocalWorkoutSession`, `LocalSkillLog`, `LocalExerciseCache` `@Model` classes exist with `pendingSync` flags but are never instantiated, queried, or injected.
- **No sync queue.** The offline-first write path described in `Docs/Architecture/database.md` §4–§7 is not implemented.
- **No DTOs or mappers.** `DTOs.swift` and `Data/Mappers/DomainMapper.swift` contain only marker protocols.

### Domain Layer

- **No use-cases.** Architecture spec calls for `LogSetUseCase`, `LogSkillSessionUseCase`, `CompleteWorkoutUseCase`, etc. None exist. ViewModels call repositories directly.
- **Models live in a shared `Models/` folder** rather than per-feature `Domain/Entities/` directories. They are reused by both Presentation and Data — acceptable for the current MVVM shape but a refactor target if Clean Architecture is enforced.
- **No domain failures.** `AppFailure` enum described in architecture §10 is not implemented.

### Observation Framework

- ViewModels currently use **`ObservableObject` + `@Published`** instead of the prescribed `@Observable` macro. Migration is straightforward (per-file change + `@State` ownership in views).

### Authentication

- No sign-in surface. No Firebase Auth wiring. No onboarding wizard (Spec F-03 – F-05).

### Active Workout Execution

- The most product-critical flow — logging sets in an active workout — is not implemented. `TrainView` is a hub, not an active-session screen.

### Skill Sessions

- Timed-hold session mode (Spec F-30) and hold-time charts (F-31) are not implemented. `SkillDetailView` is a stub.

### Subscriptions

- No RevenueCat or StoreKit 2 integration. Premium gating is referenced by `UserProfile.isPremium` but not enforced anywhere in the UI.

### Notifications

- No FCM integration. `NotificationsView` is a preferences UI only.

### Tests

- 7 tests total in `CobraSthenicsTests/` (model mapping + sample-data repository). No ViewModel, view, Firebase, or persistence tests.

## Implementation Progress Snapshot

| Area | Estimate |
|---|---|
| Design system | ~100% |
| Primary screen scaffolding | ~80% (5 tabs + settings sub-screens; active workout, skill detail, onboarding missing) |
| Sample data fixtures | ~100% |
| Domain models | ~85% |
| Repository protocols | ~70% |
| Sample data repository | ~100% |
| Firebase integration | 0% |
| SwiftData integration | ~10% (models declared, not used) |
| Use cases layer | 0% |
| Sync queue / offline-first | 0% |
| Subscription gating | 0% |
| Auth + onboarding | 0% |
| Test coverage | ~20% |

## Recommended Next Engineering Priorities

In rough order:

1. **Migrate view models to `@Observable`** so future feature work matches architecture spec.
2. **Wire SwiftData** through a `PersistenceController` and connect `LocalWorkoutSession` + `LocalSkillLog` to repository implementations.
3. **Implement the active workout flow** (S-10): set logging UI, rest timer, completion summary — all writing to SwiftData first.
4. **Implement the timed-hold skill session** (S-20): start/stop timer, per-set hold log, session summary.
5. **Introduce use cases** for the two flows above (`LogSetUseCase`, `CompleteWorkoutUseCase`, `LogSkillSessionUseCase`) so the architecture pattern is established before further feature work.
6. **Begin Firebase integration**: Auth (Apple + Google + Email/Password) and Firestore reads for `exercises/` and `globalPrograms/`.
7. **Implement onboarding wizard** (F-03 – F-05) once Auth is in place.
8. **Add ViewModel tests** for active workout and skill session flows.
9. **Add a sync queue** layered between SwiftData and Firestore once both ends exist.
10. **Subscription integration** (RevenueCat) and paywall — gate Premium features defined in `feature_matrix.md`.
