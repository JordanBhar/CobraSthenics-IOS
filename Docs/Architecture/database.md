# CobraSthenics — Data & Persistence Architecture

**Status:** Current implementation is sample-data only. SwiftData models and protocols are declared but not yet wired to a `ModelContainer`. This document describes both the present state and the intended target shape.

---

## 1. Current State

| Layer | What exists today |
|---|---|
| Remote backend | None. No Firebase SDK imported, no networking calls. |
| Local store | SwiftData `@Model` types declared in `Core/Persistence/`, but no `ModelContainer` is configured at app launch. |
| Source of truth at runtime | `Shared/SampleData/SampleData.swift`. Every `Sample*Repository` reads from it. |
| Key/value preferences | `Core/Storage/KeyValueStorage.swift` declares the protocol with `UserDefaults` conformance. No consumer wired up. |

The architecture below describes the target schema that the declared persistence types and repository protocols are designed to satisfy.

---

## 2. Local Persistence Models

Defined under `Core/Persistence/` (gated to `iOS 17.0` / `macOS 14.0` and above):

### `LocalExerciseCache`

```swift
@Model
public final class LocalExerciseCache {
    @Attribute(.unique) public var id: String
    public var name: String
    public var category: String
    public var encodedPayload: Data       // serialized Exercise DTO
    public var updatedAt: Date
}
```

Purpose: local cache for the global exercise catalogue. `encodedPayload` lets the cache evolve independently of the live `Exercise` struct shape.

### `LocalSkillLog`

```swift
@Model
public final class LocalSkillLog {
    @Attribute(.unique) public var id: String
    public var skillID: String
    public var skillName: String
    public var bestHoldSeconds: Int
    public var createdAt: Date
    public var pendingSync: Bool
}
```

Purpose: offline-first skill session records. `pendingSync = true` until a remote sync confirms the write.

### `LocalWorkoutSession`

```swift
@Model
public final class LocalWorkoutSession {
    @Attribute(.unique) public var id: String
    public var name: String
    public var startedAt: Date
    public var completedAt: Date?
    public var pendingSync: Bool
}
```

Purpose: offline-first workout sessions. Mirrors `LocalSkillLog` for sync semantics.

---

## 3. Domain Entities Backed by Persistence

Persistence models map to the following Domain entities (which are the types views render):

| Domain entity | File | Notes |
|---|---|---|
| `Exercise` | `Features/Exercise Library/Domain/Entities/ExerciseModels.swift` | Rendered from `ExerciseRepository`. Will hydrate from `LocalExerciseCache`. |
| `ExerciseCategory` | same file | Returned from `ExerciseRepository.getExerciseCategories()`. |
| `ProgressionChain` | same file | Embedded in `Exercise`. |
| `PersonalRecord` | same file | Embedded in `Exercise`. |
| `SkillModel` | `Features/Skills/Domain/Entities/SkillModels.swift` | Returned from `SkillRepository.getSkills()`. |
| `SkillSessionEntry` | same file | Returned from `SkillRepository.getSkillHistory(skillName:)`. |
| `Workout` | `Features/Workout/Domain/Entities/WorkoutModels.swift` | Returned from `WorkoutRepository.getWorkouts()`. |
| `RecentWorkout` | same file | Returned within `HomeModel.recentWorkouts`. |
| `ActiveProgram` | `Features/Program/Domain/Entities/ActiveProgram.swift` | Returned from `ProgramRepository.getFeaturedProgram()` and embedded in `HomeModel`. |
| `UserProfileModel` | `Features/Profile/Domain/Entities/UserProfileModel.swift` | Returned from `UserRepository.getUserProfile()`. |
| `Achievement` | same file | Embedded in `UserProfileModel.achievements`. |
| `ProfileSnapshot`, `MuscleStat`, `SkillTrend`, `PrEntry` | `Features/Profile/Domain/Entities/ProfileAnalyticsModels.swift` | Returned from `UserRepository.getProfileSnapshot()`. |
| `SettingGroupModel`, `SettingItemModel`, `SettingsRoute` | `Features/Settings/Domain/Entities/SettingsModels.swift` | Returned from `SettingsRepository.getSettingGroups()`. |
| `HomeModel` | `Features/Home/Domain/Entities/HomeModel.swift` | Composite snapshot returned from `HomeRepository.getHomeSnapshot()`. |

Domain entities are `Codable` `Hashable` structs. Several expose computed `Color` / `[Color]` from raw hex (`ColorPair`, `accentHex`) to keep view code small; the encoded representation remains hex.

---

## 4. Cross-Feature Value Types

Declared in `Shared/Models/DomainTypes.swift`:

```swift
public enum Difficulty: String, Codable, CaseIterable {
    case beginner, intermediate, advanced, elite, unknown
}

public struct ColorPair: Codable, Hashable {
    public let firstHex: UInt
    public let secondHex: UInt
    public var colors: [Color] { /* ... */ }
}

public struct WeekDay: Identifiable, Codable, Hashable {
    public let id: String
    public let label: String
    public let completed: Bool
    public let isToday: Bool
}
```

`Difficulty.init(from:)` and `WorkoutCategory.init(from:)` decode an unknown string to `.unknown` instead of throwing, which keeps the app resilient to additive backend changes.

---

## 5. Sample Data Catalogue

`Shared/SampleData/SampleData.swift` provides the in-memory fixtures used by every `Sample*Repository`:

| Static value | Type | Consumer |
|---|---|---|
| `user` | `UserProfileModel` | `SampleUserRepository`, `SampleHomeRepository` |
| `weekDays` | `[WeekDay]` | `SampleHomeRepository` |
| `activeProgram` | `ActiveProgram` | `SampleHomeRepository`, `SampleWorkoutRepository`, `SampleProgramRepository` |
| `recentWorkouts` | `[RecentWorkout]` | `SampleHomeRepository` |
| `workouts` | `[Workout]` | `SampleWorkoutRepository` |
| `categories` | `[ExerciseCategory]` | `SampleExerciseRepository` |
| `exercises` | `[Exercise]` | `SampleExerciseRepository` |
| `skills` | `[SkillModel]` | `SampleSkillRepository`, `SampleHomeRepository.featuredSkill` |
| `heatmap` | `[[Int]]` | `SampleUserRepository.getProfileSnapshot()` |
| `personalRecords` | `[PrEntry]` | same |
| `muscles` | `[MuscleStat]` | same |
| `skillTrends` | `[SkillTrend]` | same |
| `settingGroups` | `[SettingGroupModel]` | `SampleSettingsRepository` |

`SampleSkillRepository.getSkillHistory(skillName:)` returns a fixed four-entry array for any skill — it is purely a UI fixture for `SkillDetailView`.

---

## 6. Repository Interfaces (read-only today)

All repository protocols currently expose `async throws` reads only. There are no write methods because there is no place to persist a write — sample repositories return pure values.

When persistence is wired up, additional methods will be added per feature:

| Feature | Anticipated writes |
|---|---|
| Workout | `startWorkout`, `logSet`, `completeWorkout` |
| Skills | `logSkillSession`, `markTierComplete` |
| Profile | `updateProfile`, `updateAvatar` |
| Settings | `updateSetting(_:value:)` |
| Subscription | `purchase`, `restore` (new feature folder required) |

---

## 7. Sync Semantics (target)

The `pendingSync` flag on `LocalSkillLog` and `LocalWorkoutSession` encodes the intent for offline-first writes:

```text
User action
  → ViewModel calls repository.<write>()
  → Repository writes SwiftData record with pendingSync = true
  → UI re-renders from local state
  → Background SyncService processes pendingSync = true records
  → On success, pendingSync = false; remote ID stamped if needed
```

`SyncService` does not exist yet. The first place it will live is `Core/Persistence/` or a new `Core/Sync/` module.

---

## 8. Key/Value Preferences

`Core/Storage/KeyValueStorage.swift`:

```swift
public protocol KeyValueStorage {
    func string(forKey key: String) -> String?
    func set(_ value: String?, forKey key: String)
}

extension UserDefaults: KeyValueStorage { /* ... */ }
```

No consumer is wired today. Anticipated keys: rest-timer default, appearance, language, notification flags. These map to `SettingsRoute` cases (`.restTimer`, `.appearance`, `.language`, `.notifications`).

---

## 9. Date Source

`Core/SharedServices/DateProviding.swift`:

```swift
public protocol DateProviding {
    var now: Date { get }
}

public struct SystemDateProvider: DateProviding {
    public var now: Date { Date() }
}
```

`SystemDateProvider` is the only conformance. ViewModels do not currently inject a date provider; production code that computes streaks, week boundaries, or timestamps should adopt this protocol to keep tests deterministic.

---

## 10. Migration Strategy (target)

When SwiftData and remote storage are wired up:

- Prefer additive schema changes on `@Model` types.
- Each persisted record should carry a `schemaVersion` once the schema becomes stable.
- Domain entities tolerate missing optional data (already the case for `bestDisplay`, `bestHoldSeconds`, etc.).
- `Difficulty.unknown` and `WorkoutCategory.unknown` are the existing fallbacks for unrecognised enum values.

---

*Schema or persistence changes should update this document together with the affected SwiftData models, Domain entities, and repository protocols.*
