# Exercise Library Feature

The Library tab is the calisthenics exercise catalogue. Athletes browse categories (Chest, Back, Shoulders, Arms, Core, Legs, Full Body, Mobility), drill into a category, and open a per-exercise detail with instructions, cues, mistakes, muscles, and a progression chain.

The on-disk folder name is `Features/Exercise Library/` (with a space) to match the Xcode group.

## Feature Layout

```
Features/Exercise Library/
├── Domain/
│   ├── Entities/ExerciseModels.swift        (SetType, ExerciseCategory, ProgressionChain, PersonalRecord, Exercise)
│   └── Repositories/ExerciseRepository.swift
├── Data/
│   └── Repositories/SampleExerciseRepository.swift
└── Presentation/
    ├── ViewModels/LibraryViewModel.swift
    └── Views/
        ├── LibraryView.swift
        ├── CategoryView.swift
        ├── ExerciseDetailView.swift
        └── ExerciseVideoSection.swift
```

## Domain

### Entities

```swift
public enum SetType: String, Codable {
    case reps, timed, amrap, repsOrTimed, unknown
}

public struct ExerciseCategory: Identifiable, Codable, Hashable {
    public let id: String
    public let name: String
    public let tag: String              // "Push" / "Pull" / "Stretch" / …
    public let exerciseCount: Int
    public let colorPair: ColorPair
    public let accentHex: UInt
}

public struct ProgressionChain: Codable, Hashable {
    public let previousID: String?
    public let nextID: String?
}

public struct PersonalRecord: Codable, Hashable {
    public let bestReps: Int?
    public let bestHoldSeconds: Double?
    public let bestWeightKg: Double?
    public var primaryDisplay: String { /* "12.0s" / "20 reps" / "+20.0kg" / "-" */ }
}

public struct Exercise: Identifiable, Codable, Hashable {
    public let id, name, category, mechanics, force: String
    public let primaryMuscles, secondaryMuscles: [String]
    public let equipment: String
    public let difficulty: Difficulty
    public let defaultSetType: SetType
    public let isSkillExercise: Bool
    public let progression: ProgressionChain
    public let description: String
    public let instructions, tips, commonMistakes: [String]
    public let personalRecord: PersonalRecord?
    public let colorPair: ColorPair
    public let accentHex: UInt
    public var setTypeLabel: String { /* "Timed Hold" / "AMRAP" / "Rep Based" */ }
}
```

### Repository

```swift
public protocol ExerciseRepository {
    func getExerciseCategories() async throws -> [ExerciseCategory]
    func getExercises(categoryID: String) async throws -> [Exercise]
    func getExercise(id: String) async throws -> Exercise?
}
```

## Data

`SampleExerciseRepository`:

- `getExerciseCategories()` → `SampleData.categories` (8 categories).
- `getExercises(categoryID:)` → filtered slice of `SampleData.exercises` (3 entries: Push-Up, Pull-Up, L-Sit).
- `getExercise(id:)` → first matching exercise by id; used by `ExerciseDetailView` to hydrate the progression chain.

## Presentation

### `LibraryViewModel`

```swift
@Observable @MainActor
public final class LibraryViewModel {
    var categories: [ExerciseCategory] = []
    var searchText = ""

    var filteredCategories: [ExerciseCategory] {
        searchText.isEmpty ? categories
            : categories.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.tag.localizedCaseInsensitiveContains(searchText)
            }
    }
}
```

### `LibraryView`

Layout:

1. `AppHeader(eyebrow: "Browse", title: "Library", subtitle: "400+ calisthenics exercises · filter by category")`.
2. `SearchField` bound to `viewModel.searchText`.
3. Two-column `LazyVGrid` of `GradientCard` category tiles. Each tile shows an `AccentPill` (tag), the category name, and an inline monospaced exercise count.

Each tile is wrapped in `NavigationLink { CategoryView(category:, exerciseRepository:) }`.

### `CategoryView`

State held locally with `@State`:

- `exercises: [Exercise]`
- `searchText: String`
- `difficulty: DifficultyFilter` (`enum` with `.all` and `.level(Difficulty)`)

Layout:

1. **Hero** — `GradientCard` with category tag pill, name, and three stat tiles (`Exercises`, `Logged`, `PRs`). Logged/PR values are placeholder-derived from `exercises.count`.
2. **Search** — `SearchField` placeholder uses the current `exercises.count`.
3. **Difficulty `FilterChips`** — options from `DifficultyFilter.allOptions`.
4. **Result count** — uppercase label.
5. **Exercise list** — vertical stack of `exerciseTile(_:)`. Each tile shows a difficulty `AccentPill` resolved by `AppColor.difficulty(_:)`, the equipment name, and primary/secondary muscles. Tiles use `NavigationLink { ExerciseDetailView(exercise:, exerciseRepository:) }`.
6. **Empty state** — message switches between "No exercises in this difficulty" and `"No results for "<text>""` depending on whether the search bar is empty.

Loads exercises in `.task` by calling `exerciseRepository.getExercises(categoryID: category.id)`.

### `ExerciseDetailView`

Hydrates the progression chain on appear (fetches previous/next exercises by id).

Layout:

1. **Hero** — `GradientCard` with difficulty pill, exercise name (24pt black), equipment + `setTypeLabel`.
2. **Stat row** — three `AppCard` stats: `Target` (`3 × hold` / `3 × max` / `3 × 8–12`), best hold or best reps (from `PersonalRecord.primaryDisplay`), `Sets` (hard-coded `3`).
3. **`ExerciseVideoSection`** — styled 16:9 placeholder for a form-demo video (radial accent glow, form-demo pill, HD pill, play button, mock coach badge).
4. **Progression chain** — three tiles (Easier / Current / Harder) showing exercise names from `prevExercise`, the current exercise, and `nextExercise`. Empty positions render a dashed placeholder ("Start here" / "Mastered").
5. **Tab selector** — three segments (`Instructions`, `Cues & Mistakes`, `Muscles`) animated with `AppAnimation.quick`.
6. **Tab content**:
   - **Instructions** — numbered `AppCard` rows from `exercise.instructions`.
   - **Cues & Mistakes** — two tinted `AppCard`s using `AppColor.green` for tips and `AppColor.red` for `commonMistakes`.
   - **Muscles** — `FlowLayout` pills for `primaryMuscles` + `secondaryMuscles`. An "EXERCISE TYPE" callout describes the set type.
7. **Sticky CTAs** — `PrimaryButton("Add to Workout")` + `OutlineButton("Log Set")` over a vertical background fade.

Helper types defined in this file: `DetailTab` (`enum`), `FlowLayout` (reused by `SkillDetailView`).

### `ExerciseVideoSection`

Pure visual component. No video playback today — it is a styled placeholder built to slot in a `VideoPlayer` later. Public so it can be reused outside the library if needed.

## Dependencies

- `Shared/DesignSystem`: `AppHeader`, `AppCard`, `GradientCard`, `SearchField`, `FilterChips`, `AccentPill`, `PrimaryButton`, `OutlineButton`, plus tokens.
- `Core/Constants/LibraryConstants.swift` for content strings.
- `Shared/Models/DomainTypes.swift` — `Difficulty`, `ColorPair`.

## Data Flow

```
LibraryView .task
  → LibraryViewModel.load()
    → ExerciseRepository.getExerciseCategories()
  → grid of categories

NavigationLink → CategoryView (category, repo)
  → .task fetches exerciseRepository.getExercises(categoryID:)
  → list of Exercise tiles

NavigationLink → ExerciseDetailView (exercise, repo)
  → .task fetches previous/next via exerciseRepository.getExercise(id:)
  → hero, video placeholder, chain, tabbed detail
```
