# Home Feature

Surfaces the athlete's daily dashboard: greeting, weekly day strip, streak, active program hero, featured skill, and recent activity.

## Feature Layout

```
Features/Home/
├── Domain/
│   ├── Entities/HomeModel.swift
│   └── Repositories/HomeRepository.swift
├── Data/
│   └── Repositories/SampleHomeRepository.swift
└── Presentation/
    ├── ViewModels/HomeViewModel.swift
    └── Views/HomeView.swift
```

## Domain

### `HomeModel`

```swift
public struct HomeModel: Codable {
    public let user: UserProfileModel
    public let weekDays: [WeekDay]
    public let activeProgram: ActiveProgram?
    public let featuredSkill: SkillModel?
    public let recentWorkouts: [RecentWorkout]
    public let streakDays: Int
}
```

The Home surface composes entities from the Profile, Program, Skills, and Workout features into a single snapshot. It is intentionally read-only and immutable.

### `HomeRepository`

```swift
public protocol HomeRepository {
    func getHomeSnapshot() async throws -> HomeModel
}
```

## Data

`SampleHomeRepository.getHomeSnapshot()` returns a `HomeModel` composed of `SampleData.user`, `SampleData.weekDays`, `SampleData.activeProgram`, `SampleData.skills.first` as the featured skill, and `SampleData.recentWorkouts`. `streakDays` is hard-coded to `14`.

## Presentation

### `HomeViewModel`

```swift
@Observable @MainActor
public final class HomeViewModel {
    var homedata: HomeModel?
    var isLoading = false

    private let homeRepository: any HomeRepository
}
```

`load()` short-circuits when `homedata` is already set.

### `HomeView`

The view stack (top to bottom):

1. **Greeting** — `HomeConstants.greeting` ("Good morning 👋") + first name pulled from `user.displayName`. Right-aligned bell `iconButton`.
2. **Day strip** — `AppCard` row of `WeekDay` tiles. Completed days fill with `AppColor.brand`. Today's empty day gets a brand-blue stroke.
3. **Streak row** — `GradientCard` showing the streak count with the 🔥 emoji plus two stacked stat cards (`3 / 5 sessions`, `2,840 total sets`). Both values are hard-coded in the view.
4. **Active program card** — `GradientCard` with an `AccentPill` (level), program name, `RingProgress` adherence ring, two metric chips (week, day), and a `PrimaryButton` "Continue Today's Session".
5. **Skill focus** — `SectionHeader("Skill Focus", actionTitle: "All Skills")` followed by an `AppCard` showing the featured skill's name, last / target stats, and an `AppProgressBar`.
6. **Recent activity** — `SectionHeader("Recent Activity", actionTitle: "History")` followed by a vertical stack of `recentWorkoutTile`s. Each tile uses the workout's accent color and the 🎯 / 💪 emoji marker.

Loading state renders a `ProgressView().tint(AppColor.brand)` until `homedata` is set.

Navigation: today none of the Home tiles push to a detail screen — they are visual only. The "All Skills" / "History" / "Continue Today's Session" CTAs are wired without destinations.

## Dependencies

- `Shared/DesignSystem`: `AppCard`, `GradientCard`, `SectionHeader`, `AppProgressBar`, `RingProgress`, `PrimaryButton`, `AccentPill`, `AppColor`, `AppSpacing`, `AppRadius`, `Font.appX`.
- `Core/Constants/HomeConstants.swift` — content strings and SF Symbol names.
- `AppLayout.bottomBarClearance` for bottom padding.

## Data flow

```
HomeView .task
  → HomeViewModel.load()
    → HomeRepository.getHomeSnapshot()
      → SampleHomeRepository pulls from SampleData
  → HomeModel rendered into the view
```
