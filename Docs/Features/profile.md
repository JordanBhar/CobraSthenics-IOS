# Profile Feature

The Profile tab surfaces the athlete's identity, level/XP, key counters, achievements, personal records, and the grouped settings list. The settings rows push into the Settings feature's detail screens.

## Feature Layout

```
Features/Profile/
├── Domain/
│   ├── Entities/UserProfileModel.swift                     (UserProfileModel, Achievement)
│   ├── Entities/ProfileAnalyticsModels.swift               (MuscleStat, SkillTrend, PrEntry, ProfileSnapshot)
│   └── Repositories/UserRepository.swift
├── Data/
│   └── Repositories/SampleUserRepository.swift
└── Presentation/
    ├── ViewModels/ProfileViewModel.swift
    └── Views/ProfileView.swift
```

## Domain

### Entities

```swift
public struct UserProfileModel: Identifiable, Codable, Hashable {
    public let id, displayName, username: String
    public let avatarURL: URL?
    public let level: Int
    public let levelTitle: String
    public let currentXP, xpToNextLevel: Int
    public let workoutCount, streakDays, activeSkills, prCount: Int
    public let isPremium: Bool
    public let bio: String?
    public let achievements: [Achievement]

    public var xpProgress: Double { /* currentXP / xpToNextLevel */ }
}

public struct Achievement: Identifiable, Codable, Hashable {
    public let id, emoji, name: String
    public let isEarned: Bool
}

public struct MuscleStat: Identifiable, Codable, Hashable {
    public var id: String { name }
    public let name: String
    public let percent: Int
}

public struct SkillTrend: Identifiable, Codable, Hashable {
    public var id: String { skillName }
    public let skillName: String
    public let values: [Double]
    public let unit: String
    public let colorHex: UInt
    public var latest: Double { values.last ?? 0 }
    public var gain: Double { (values.last ?? 0) - (values.first ?? 0) }
    public var color: Color { Color(hex: colorHex) }
}

public struct PrEntry: Identifiable, Codable, Hashable {
    public var id: String { exerciseName }
    public let exerciseName, valueDisplay: String
    public let accentHex: UInt
    public var accent: Color { Color(hex: accentHex) }
}

public struct ProfileSnapshot: Codable {
    public let user: UserProfileModel
    public let heatmapGrid: [[Int]]
    public let weeklyVolume: [Double]
    public let personalRecords: [PrEntry]
    public let muscleBreakdown: [MuscleStat]
    public let skillTrends: [SkillTrend]
}
```

`ProfileSnapshot` is the composite payload the view consumes. The analytics-style fields (`heatmapGrid`, `weeklyVolume`, `muscleBreakdown`, `skillTrends`) are declared in Domain but not currently rendered by `ProfileView` — the view renders user identity, quick stats, achievements, personal records, and settings groups. The analytics fields are available for future analytics surfaces.

### Repository

```swift
public protocol UserRepository {
    func getUserProfile() async throws -> UserProfileModel
    func getProfileSnapshot() async throws -> ProfileSnapshot
}
```

## Data

`SampleUserRepository`:

- `getUserProfile()` → `SampleData.user`.
- `getProfileSnapshot()` → composite from `SampleData.user`, `SampleData.heatmap`, hard-coded `[18, 24, 20, 31, 28, 35, 30]` weekly volume, `SampleData.personalRecords`, `SampleData.muscles`, `SampleData.skillTrends`.

## Presentation

### `ProfileViewModel`

`ProfileViewModel` is the only view model in the app that holds two repositories. It loads both the profile snapshot and the settings groups in `load()`.

```swift
@MainActor @Observable
public final class ProfileViewModel {
    var snapshot: ProfileSnapshot?
    var settingGroups: [SettingGroupModel] = []
    var selectedProgressTab = 0   // reserved for future progress sub-tabs

    private let userRepository: any UserRepository
    private let settingsRepository: any SettingsRepository

    func load() async {
        guard snapshot == nil else { return }
        snapshot = try? await userRepository.getProfileSnapshot()
        settingGroups = (try? await settingsRepository.getSettingGroups()) ?? []
    }
}
```

### `ProfileView`

Layout (top to bottom):

1. **User card** — `AppCard` with avatar (initials over a brand gradient), display name, `"@\(username) · Lvl \(level) \(levelTitle)"`, a settings cog icon button, and an `AppProgressBar` for XP to next level with the monospaced value `"\(currentXP) / \(xpToNextLevel)"`.
2. **Quick stats** — four `AppCard` tiles: `Workouts`, `Day streak`, `Skills`, `PRs` (driven by `UserProfileModel.workoutCount / streakDays / activeSkills / prCount`).
3. **Achievements** — `SectionHeader("Achievements", actionTitle: "All")` followed by a 3-column `LazyVGrid` of achievement cards. Earned achievements are full opacity; unearned ones drop to `0.4`.
4. **Personal records** — `SectionHeader("Personal Records", actionTitle: "All PRs")` followed by a vertical stack of `AppCard` rows showing trophy icon + exercise name + monospaced value.
5. **Settings groups** — `SectionHeader("Settings")` followed by one `AppCard` per `SettingGroupModel`. Each row is a `NavigationLink { destination(for: route) }` resolved by `ProfileView.destination(for:)` over `SettingsRoute`. Destinations are the views in `Features/Settings/Presentation/Views/`.

Loading state: `ProgressView().tint(AppColor.brand)` until `snapshot` is set.

### `destination(for:)`

The `SettingsRoute` switch is the only routing surface in the app today:

```swift
case .notifications:    NotificationsSettingsView()
case .workoutReminders: WorkoutRemindersView()
case .restTimer:        RestTimerSettingsView()
case .appearance:       AppearanceSettingsView()
case .language:         LanguageSettingsView()
case .editProfile:      EditProfileView()
case .changePassword:   ChangePasswordView()
case .connectedApps:    ConnectedAppsView()
case .exportData:       ExportDataView()
case .helpFAQ:          HelpFAQView()
case .feedback:         SendFeedbackView()
case .deleteAccount:    DeleteAccountView()
case .subscription:     SubscriptionView()
case .none:             EmptyView()
```

## Dependencies

- `Shared/DesignSystem`: `AppCard`, `SectionHeader`, `AppProgressBar`, `AccentPill`, plus tokens.
- `Core/Constants/ProfileConstants.swift` for content strings.
- `Features/Settings/Presentation/Views/*` — all destination views.

## Data Flow

```
ProfileView .task
  → ProfileViewModel.load()
    → UserRepository.getProfileSnapshot()
    → SettingsRepository.getSettingGroups()
  → ProfileView renders user card + stats + achievements + PRs + settings groups
  → NavigationLink routes by SettingsRoute into Features/Settings/...
```
