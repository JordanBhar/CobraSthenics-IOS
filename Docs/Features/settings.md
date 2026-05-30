# Settings Feature

The Settings feature owns the list model returned to `ProfileView` plus a family of detail screens reached through `NavigationLink`s. Settings does not have its own tab — it is reached via the Profile tab's settings groups.

## Feature Layout

```
Features/Settings/
├── Domain/
│   ├── Entities/SettingsModels.swift         (SettingsRoute, SettingGroupModel, SettingItemModel)
│   └── Repositories/SettingsRepository.swift
├── Data/
│   └── Repositories/SampleSettingsRepository.swift
└── Presentation/
    └── Views/
        ├── SettingsScreen.swift              (container)
        ├── AccountSettingsViews.swift        (EditProfileView, ChangePasswordView, ConnectedAppsView, ExportDataView, FieldCard)
        ├── AppearanceLanguageView.swift      (AppearanceSettingsView, LanguageSettingsView)
        ├── NotificationsView.swift           (NotificationsSettingsView, WorkoutRemindersView)
        ├── RestTimerView.swift               (RestTimerSettingsView)
        ├── SupportSettingsViews.swift        (HelpFAQView, SendFeedbackView, DeleteAccountView)
        └── SubscriptionView.swift            (SubscriptionView)
```

There is no dedicated `SettingsViewModel`. The groups are loaded by `ProfileViewModel` and each detail screen owns its own `@State` for form fields.

## Domain

### Entities

```swift
public enum SettingsRoute: String, Hashable {
    case notifications, workoutReminders, restTimer,
         appearance, language,
         editProfile, changePassword, connectedApps, exportData,
         helpFAQ, feedback, deleteAccount,
         subscription,
         none
}

public struct SettingGroupModel: Identifiable, Hashable {
    public var id: String { label }
    public let label: String
    public let items: [SettingItemModel]
}

public struct SettingItemModel: Identifiable, Hashable {
    public var id: String { label }
    public let systemImage: String
    public let colorHex: UInt
    public let label: String
    public let value: String?
    public let badge: String?
    public let destructive: Bool
    public let route: SettingsRoute
    public var color: Color { Color(hex: colorHex) }
}
```

### Repository

```swift
public protocol SettingsRepository {
    func getSettingGroups() async throws -> [SettingGroupModel]
}
```

## Data

`SampleSettingsRepository` returns `SampleData.settingGroups`, which ships three groups:

| Group | Items |
|---|---|
| Account | Edit Profile, Change Password, Notifications, Default Rest Timer (`2:00`), Workout Reminders (`Mon · Wed · Fri`) |
| App | Appearance (`Dark`), Language (`English`), Connected Apps (`2 active`), Export Data, Subscription (`Premium` badge) |
| Support | Help & FAQ, Send Feedback, Delete Account (destructive) |

Each item is rendered by `ProfileView.settingRow(_:showsDivider:)` using its `systemImage`, tinted background, label, optional value text, optional badge (`AccentPill`), and a chevron unless destructive.

## Presentation Container

### `SettingsScreen<Content>`

A shared screen wrapper used by every settings detail view:

```swift
public struct SettingsScreen<Content: View>: View {
    public init(
        title: String,
        rightAction: AnyView? = nil,
        showsSaveCTA: Bool = false,
        ctaTitle: String = "Save",
        ctaAction: @escaping () -> Void = {},
        @ViewBuilder content: () -> Content
    )
}
```

Behaviour:

- Sets a navigation title with `.appNavigationBarTitleDisplayModeInline()`.
- Adds an optional trailing toolbar action.
- Renders the supplied content in a `ScrollView` with `AppSpacing.lg` horizontal padding.
- When `showsSaveCTA` is true, overlays a sticky `PrimaryButton` CTA over a vertical fade-up gradient.

## Detail Screens

| Screen | Source | Notable behaviour |
|---|---|---|
| `EditProfileView` | `AccountSettingsViews.swift` | Avatar editor, four `FieldCard`s (display name, username, bio, location), two `AppToggle` rows for profile visibility. Sticky CTA + toolbar Save. |
| `ChangePasswordView` | same file | Three secure `FieldCard`s with reveal toggles, custom strength meter, requirements checklist. |
| `ConnectedAppsView` | same file | Apple Health, Google Fit (connected) + Garmin Connect, Strava (available). Uses `AppToggle` for connected apps. |
| `ExportDataView` | same file | Format selector (`FilterChips`), include checklist (`SettingsListRow`), date-range chips, info callout. Sticky `Request Export` CTA. |
| `FieldCard` | same file | Internal labelled input used by Edit Profile, Change Password, Send Feedback. Supports single-line, multiline, and secure variants. |
| `AppearanceSettingsView` | `AppearanceLanguageView.swift` | Three options (Dark, Light "Coming Soon", System "Coming Soon"). Renders mini theme previews. Only Dark is selectable. |
| `LanguageSettingsView` | same file | Searchable list of ten locales. |
| `NotificationsSettingsView` | `NotificationsView.swift` | Four toggle sections (Workouts, Skills, Coach, Social) backed by local `@State`. Strings live inline. |
| `WorkoutRemindersView` | same file | Day selector buttons + custom AM/PM time wheel + lead-time `FilterChips`. Sticky `Save Reminder` CTA. |
| `RestTimerSettingsView` | `RestTimerView.swift` | Animated ring display, preset chips, custom stepper, per-category override toggle + override rows. Uses `AppAnimation.standard` on the ring trim. |
| `HelpFAQView` | `SupportSettingsViews.swift` | `SearchField`, accordion FAQ list with four entries, contact cards. Uses `AppAnimation.standard` for accordion expand. |
| `SendFeedbackView` | same file | Type chips, subject `FieldCard`, multiline message field with `count / 500` indicator, attach-screenshot toggle, 5-star satisfaction picker. |
| `DeleteAccountView` | same file | Warning card, deletion list, "Before you go" cards, `DELETE` confirmation input, sticky destructive CTA gated by `typed == "DELETE"`. |
| `SubscriptionView` | `SubscriptionView.swift` | Premium hero (`GradientCard`), billing rows, unlocked feature list, monthly/annual plan selector, manage rows, cancel card. Static layout — no StoreKit integration. |

All detail views own their own form `@State`. No state currently persists between sessions (no `KeyValueStorage` consumer is wired today).

## Dependencies

- `Shared/DesignSystem`: `SettingsListHeader`, `SettingsListGroup`, `SettingsListRow`, `DisclosureChevron`, `AppCard`, `GradientCard`, `AccentPill`, `AppToggle`, `FilterChips`, `SearchField`, `PrimaryButton`, plus tokens.
- `SettingsScreen` is the shared container.
- No `Core` constants file is dedicated to Settings; strings live inline per screen.

## Subscription Note

`SubscriptionView` is the only entry point that shows entitlement state today, and it's static — no StoreKit or RevenueCat integration. When real subscriptions are added they should live behind a `SubscriptionRepository` in a new `Features/Subscription/` folder rather than expanding `SettingsRepository`.
