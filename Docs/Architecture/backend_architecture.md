# CobraSthenics — Backend Architecture

**Status:** Current implementation is sample-only. Backend adapters are planned but not wired.

## Current State

There is no production backend wired into the app today. Every repository protocol in `Features/*/Domain/Repositories/` is satisfied by a `Sample*Repository` in `Features/*/Data/Repositories/` that returns values from `Shared/SampleData/SampleData.swift`.

Scaffolding that anticipates production backends:

| File | Purpose |
|---|---|
| `Core/Firebase/FirebaseAdapterError.swift` | Single-case `FirebaseAdapterError.notImplemented`. Will grow into a typed failure surface for Firebase-backed adapters. |
| `Core/Networking/NetworkClient.swift` | `NetworkClient` protocol with `URLSession` conformance. Reserved for non-Firebase HTTP. |
| `Core/Persistence/LocalExerciseCache.swift` | SwiftData `@Model` for cached exercises. |
| `Core/Persistence/LocalSkillLog.swift` | SwiftData `@Model` for offline skill log writes with `pendingSync: Bool`. |
| `Core/Persistence/LocalWorkoutSession.swift` | SwiftData `@Model` for offline workout sessions with `pendingSync: Bool`. |
| `Core/Storage/KeyValueStorage.swift` | `KeyValueStorage` protocol over `UserDefaults`. |
| `Core/SharedServices/DateProviding.swift` | `DateProviding` protocol + `SystemDateProvider` for deterministic timestamps. |

No `ModelContainer` is configured at app launch; no Firebase SDK is imported; no remote data source exists today.

## Boundary

The contract that backend code must satisfy is fixed by the repository protocols already in the codebase:

```swift
// Features/Home/Domain/Repositories/HomeRepository.swift
public protocol HomeRepository {
    func getHomeSnapshot() async throws -> HomeModel
}

// Features/Workout/Domain/Repositories/WorkoutRepository.swift
public protocol WorkoutRepository {
    func getActiveProgram() async throws -> ActiveProgram?
    func getWorkouts() async throws -> [Workout]
}

// Features/Skills/Domain/Repositories/SkillRepository.swift
public protocol SkillRepository {
    func getSkills() async throws -> [SkillModel]
    func getSkillHistory(skillName: String) async throws -> [SkillSessionEntry]
}

// Features/Exercise Library/Domain/Repositories/ExerciseRepository.swift
public protocol ExerciseRepository {
    func getExerciseCategories() async throws -> [ExerciseCategory]
    func getExercises(categoryID: String) async throws -> [Exercise]
    func getExercise(id: String) async throws -> Exercise?
}

// Features/Profile/Domain/Repositories/UserRepository.swift
public protocol UserRepository {
    func getUserProfile() async throws -> UserProfileModel
    func getProfileSnapshot() async throws -> ProfileSnapshot
}

// Features/Program/Domain/Repositories/ProgramRepository.swift
public protocol ProgramRepository {
    func getFeaturedProgram() async throws -> ActiveProgram?
}

// Features/Settings/Domain/Repositories/SettingsRepository.swift
public protocol SettingsRepository {
    func getSettingGroups() async throws -> [SettingGroupModel]
}
```

Backend adapters must not change the shape of these protocols without updating consumers.

## Layer Rules

- SwiftUI views and `@Observable` view models never import Firebase, SwiftData, or URLSession.
- Backend code is allowed only inside `Features/*/Data/` (per-feature concrete repositories) and `Core/Firebase/`, `Core/Networking/`, `Core/Persistence/`, `Core/Storage/`.
- Backend implementations translate SDK-native types into the domain entities defined under `Features/*/Domain/Entities/`.

## Sample vs Production Implementations

When production adapters land they should sit alongside the sample implementation:

```text
Features/Home/Data/Repositories/
├── SampleHomeRepository.swift      (already present)
└── FirebaseHomeRepository.swift    (planned)
```

`AppEnvironment.preview` keeps using `Sample*Repository`. A future `AppEnvironment.live` will compose the production adapters and be injected from `CobraSthenicsApp`.

## Error Handling Plan

When backend adapters are introduced:

- Convert SDK errors (`NSError`, Firebase `FirebaseError`, `URLError`) at the repository implementation boundary into a typed failure (extension of `FirebaseAdapterError` or a new `AppFailure` enum).
- Surface a user-readable error string on the view model. Today every view model uses `try?` and falls back to `nil` / empty arrays; this is acceptable while data is sample-only but must change when remote calls can actually fail.
- Never let `DocumentSnapshot`, `URLResponse`, `StorageReference`, or other SDK types cross into Presentation or Domain.

## Offline-First Plan

The SwiftData `@Model` types already carry `pendingSync: Bool` and `updatedAt: Date`. The intended flow when the data layer is wired up:

```text
User action
  → ViewModel calls repository.<write>()
  → Repository writes SwiftData record (pendingSync = true)
  → UI re-renders from local state immediately
  → Background SyncService uploads to backend, sets pendingSync = false on success
```

## Subscription Boundary

`SubscriptionView` in `Features/Settings/Presentation/Views/SubscriptionView.swift` is currently a static layout. There is no StoreKit or RevenueCat integration in the project. When entitlement validation is added it belongs behind a `SubscriptionRepository` protocol authored in `Features/Subscription/Domain/Repositories/` with a Data-layer adapter.
