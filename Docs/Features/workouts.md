# Workout / Train Feature

The Train tab is the workout-side dashboard: quick actions, active program hero, category filter, and a list of available workouts. Active set logging, rest timer, and workout history are planned but not implemented in the current codebase.

## Feature Layout

```
Features/Workout/
├── Domain/
│   ├── Entities/WorkoutModels.swift     (WorkoutCategory, RecentWorkout, Workout)
│   └── Repositories/WorkoutRepository.swift
├── Data/
│   └── Repositories/SampleWorkoutRepository.swift
└── Presentation/
    ├── ViewModels/TrainViewModel.swift
    └── Views/TrainView.swift
```

## Domain

### Entities

```swift
public enum WorkoutCategory: String, Codable, CaseIterable {
    case all, strength, skill, mobility, rings, unknown
    public var title: String { /* "All Workouts" / "Strength" / … */ }
}

public struct RecentWorkout: Identifiable, Codable, Hashable {
    public let id: String
    public let name: String
    public let dateLabel: String
    public let setCount: Int
    public let duration: String
    public let isSkillSession: Bool
    public let backgroundHex: UInt
    public let accentHex: UInt
}

public struct Workout: Identifiable, Codable, Hashable {
    public let id: String
    public let name: String
    public let duration: String
    public let exerciseCount: Int
    public let muscles: [String]
    public let level: String
    public let colorPair: ColorPair
    public let accentHex: UInt
    public let category: WorkoutCategory
    public let exercises: [Exercise]
}
```

`WorkoutCategory.init(from:)` decodes unknown values as `.unknown`.

`Workout.exercises` is `[Exercise]` (from the Exercise Library feature). Sample workouts ship with an empty `exercises` array — exercise content is rendered from the Exercise Library, not from the Train tab.

### Repository

```swift
public protocol WorkoutRepository {
    func getActiveProgram() async throws -> ActiveProgram?
    func getWorkouts() async throws -> [Workout]
}
```

`getActiveProgram()` returns the same `ActiveProgram` used by `HomeRepository` and `ProgramRepository`; the Train tab renders it as a hero card.

## Data

`SampleWorkoutRepository` returns `SampleData.activeProgram` and `SampleData.workouts` (5 entries: Pull Day, Push Day, Core Foundations, Leg Power, Ring Strength).

## Presentation

### `TrainViewModel`

```swift
@Observable @MainActor
public final class TrainViewModel {
    var activeProgram: ActiveProgram?
    var workouts: [Workout] = []
    var selectedCategory: WorkoutCategory = .all

    var filteredWorkouts: [Workout] {
        selectedCategory == .all ? workouts : workouts.filter { $0.category == selectedCategory }
    }

    func load() async {
        guard workouts.isEmpty else { return }
        activeProgram = try? await workoutRepository.getActiveProgram()
        workouts = (try? await workoutRepository.getWorkouts()) ?? []
    }
}
```

`filteredWorkouts` is the only derived state; everything else is straight pass-through.

### `TrainView`

Layout (top to bottom):

1. **Header** — `AppHeader(eyebrow: "Cobrasthenics", title: "Train")`.
2. **Quick actions** — three tile buttons (`Quick Start`, `Custom Build`, `Calendar`). Strings from `TrainConstants.QuickActions`.
3. **My Program section** — `SectionHeader("My Program", actionTitle: "All Programs")` followed by either:
   - The `GradientCard` program hero (level pill, name, adherence `RingProgress`, week/day chips, `PrimaryButton("Continue Today's Session")`).
   - Or `noProgram` — a plus-circle empty state with `PrimaryButton("Browse Programs")` when `activeProgram` is nil.
4. **Filter chips** — `FilterChips` over `WorkoutCategory.filterOptions` (`.all, .strength, .skill, .mobility, .rings`).
5. **Workout tiles** — vertical stack of `workoutTile(_:)` rendered from `filteredWorkouts`. Each tile shows the workout's `GradientCard`-style icon, name, exercise count + duration, primary muscle chips, and a difficulty pill resolved by `difficultyColor(_:)`.

Navigation: tiles do not push to a detail screen in the current implementation — they are visual only.

## Dependencies

- `Shared/DesignSystem`: `AppHeader`, `AppCard`, `GradientCard`, `SectionHeader`, `FilterChips`, `RingProgress`, `PrimaryButton`, `AccentPill`, plus tokens.
- `Core/Constants/TrainConstants.swift` for content strings and SF Symbols.
- `Features/Program/Domain/Entities/ActiveProgram.swift` for the program model.

## Data Flow

```
TrainView .task
  → TrainViewModel.load()
    → WorkoutRepository.getActiveProgram()
    → WorkoutRepository.getWorkouts()
  → TrainView renders activeProgram and filteredWorkouts
  → User toggles category → selectedCategory changes
  → filteredWorkouts recomputes
```

## Not Yet Implemented

- Active workout execution screen (set logging, rest timer, finish workout).
- Workout history.
- Quick Start / Custom Build / Calendar destinations.
- Sets/reps/holds entry. The Domain types exist for `Workout.exercises: [Exercise]` but the runtime sample passes an empty array.
