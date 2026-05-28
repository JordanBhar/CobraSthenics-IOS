# CobraSthenics — Design System

The design system is implemented under `CobraSthenics/Shared/DesignSystem/`. Feature code must compose these primitives — it must not introduce one-off styling.

This document mirrors the actual source. When a token or component name appears below, it exists in the codebase and is callable from feature views.

---

## 1. Tokens

### 1.1 Colors — `Shared/DesignSystem/Theme/AppColors.swift`

```swift
public enum AppColor {
    // Surfaces
    public static let background  = Color(hex: 0x080808)
    public static let card        = Color(hex: 0x111111)
    public static let elevated    = Color(hex: 0x1A1A1A)
    public static let elevated2   = Color(hex: 0x222222)
    public static let border      = Color(hex: 0x242424)
    public static let border2     = Color(hex: 0x2E2E2E)

    // Accents
    public static let brand   = Color(hex: 0x0A84FF)
    public static let green   = Color(hex: 0x30D158)
    public static let red     = Color(hex: 0xFF453A)
    public static let gold    = Color(hex: 0xFFB800)
    public static let orange  = Color(hex: 0xFF9F0A)
    public static let purple  = Color(hex: 0xBF5AF2)
    public static let teal    = Color(hex: 0x4DD0E1)

    // Text
    public static let textPrimary   = Color.white
    public static let textSecondary = Color(hex: 0x8A8A8E)
    public static let textHint      = Color(hex: 0x48484A)

    public static func difficulty(_ value: Difficulty) -> Color { /* fixed mapping */ }
}
```

`AppColor.difficulty(_:)` resolves the strict difficulty mapping:

| `Difficulty` | Color |
|---|---|
| `.beginner` | `AppColor.green` |
| `.intermediate` | `AppColor.orange` |
| `.advanced` | `AppColor.red` |
| `.elite` | `AppColor.purple` |
| `.unknown` | `AppColor.textSecondary` |

### 1.2 Spacing — `Shared/DesignSystem/Theme/Spacing.swift`

```swift
public enum AppSpacing {
    public static let xxs: CGFloat = 4
    public static let xs:  CGFloat = 8
    public static let sm:  CGFloat = 12
    public static let md:  CGFloat = 16
    public static let lg:  CGFloat = 20
    public static let xl:  CGFloat = 24
    public static let xxl: CGFloat = 32
}
```

Default screen horizontal padding across feature roots is `AppSpacing.lg` (20pt).

### 1.3 Radii — `Shared/DesignSystem/Theme/Theme.swift`

```swift
public enum AppRadius {
    public static let xs: CGFloat = 8
    public static let sm: CGFloat = 12
    public static let md: CGFloat = 16   // default card
    public static let lg: CGFloat = 20   // hero / gradient card
    public static let xl: CGFloat = 24
}
```

`PrimaryButton` and `OutlineButton` use a literal `15` radius (intentional half-step).

### 1.4 Typography — `Shared/DesignSystem/Theme/Typography.swift`

```swift
public extension Font {
    static let appDisplay     = Font.system(size: 38, weight: .black,    design: .default)
    static let appH1          = Font.system(size: 28, weight: .black,    design: .default)
    static let appH2          = Font.system(size: 22, weight: .heavy,    design: .default)
    static let appH3          = Font.system(size: 17, weight: .heavy,    design: .default)
    static let appBodyLarge   = Font.system(size: 15, weight: .semibold, design: .default)
    static let appBody        = Font.system(size: 13, weight: .regular,  design: .default)
    static let appLabel       = Font.system(size: 11, weight: .bold,     design: .default)
    static let appCaption     = Font.system(size: 10, weight: .semibold, design: .default)
    static let appMono        = Font.system(size: 13, weight: .medium,   design: .monospaced)
    static let appMonoLarge   = Font.system(size: 20, weight: .black,    design: .monospaced)
}
```

Monospaced fonts are used for every numeric value (stat blocks, hold times, percentages, dates, billing values).

### 1.5 Layout — `Shared/DesignSystem/Layout/AppLayout.swift`

```swift
public enum AppLayout {
    public static let contentMaxWidth:    CGFloat = 720
    public static let bottomBarClearance: CGFloat = 100
}
```

`bottomBarClearance` is the bottom padding feature roots leave for the tab bar.

### 1.6 Animation — `Shared/DesignSystem/Animations/AppAnimation.swift`

```swift
public enum AppAnimation {
    public static let quick    = Animation.easeOut(duration: 0.18)
    public static let standard = Animation.easeInOut(duration: 0.28)
}
```

`AppAnimation.quick` is used for tab/segmented selector flips (e.g. `SkillDetailView`, `ExerciseDetailView`). `AppAnimation.standard` is used for FAQ accordion expand and the rest-timer ring (`RestTimerSettingsView`, `HelpFAQView`).

---

## 2. Color Initializer & Modifiers

### 2.1 `Color+Hex` — `Shared/DesignSystem/Extensions/Color+Hex.swift`

```swift
public extension Color {
    init(hex: UInt, alpha: Double = 1) { /* … */ }
}

public extension ShapeStyle where Self == Color {
    static var appBackground: Color { AppColor.background }
}
```

Use `Color(hex: 0x…)` only when reaching for a brand-specific token that is not already exposed by `AppColor`. Feature code should prefer `AppColor.*` tokens.

### 2.2 `AppNavigationModifiers` — `Shared/DesignSystem/Modifiers/AppNavigationModifiers.swift`

Platform-conditional view modifiers used across feature views:

| Modifier | Behaviour |
|---|---|
| `.appNavigationBarHidden(_:)` | iOS `navigationBarHidden(_:)`; no-op on macOS. Used by every tab root. |
| `.appNavigationBarTitleDisplayModeInline()` | iOS `navigationBarTitleDisplayMode(.inline)`; no-op on macOS. Used by every detail screen. |
| `.appTextInputAutocapitalizationNever()` | iOS `textInputAutocapitalization(.never)`; no-op on macOS. Used by `SearchField`, `FieldCard`, `DeleteAccountView`. |

---

## 3. Components

All components live under `Shared/DesignSystem/Components/`.

### 3.1 Buttons

| File | Component | API |
|---|---|---|
| `Buttons/PrimaryButton.swift` | `PrimaryButton` | `(_ title:, systemImage:, color:, action:)`. Solid `color` (default `AppColor.brand`), white text, 50pt tall, 15pt radius. |
| `Buttons/OutlineButton.swift` | `OutlineButton` | `(_ title:, systemImage:, color:, fullWidth:, action:)`. 14% accent fill, 35% accent border, accent text. Same 50pt height as `PrimaryButton`. |

### 3.2 Cards

| File | Component | API |
|---|---|---|
| `Cards/AppCard.swift` | `AppCard` | `(radius:, padding:, background:, border:, content:)`. Default `AppRadius.md`, `AppSpacing.md`, `AppColor.card`, `AppColor.border`. The base surface for every information block in the app. |
| `Cards/GradientCard.swift` | `GradientCard` | `(colors:, accent:, radius:, padding:, content:)`. Two-stop top-left → bottom-right linear gradient with a 22% accent border. Used for hero surfaces (active program, featured skill, category tiles, subscription hero, exercise detail hero). |

### 3.3 Charts

| File | Component | Notes |
|---|---|---|
| `Charts/HeatmapGrid.swift` | `HeatmapGrid` | `(grid: [[Int]], color: Color)`. Renders a workout heatmap; cell intensity from raw `0..2` values. |
| `Charts/MiniBarChart.swift` | `MiniBarChart` | `(values: [Double], color: Color, height: CGFloat = 56)`. Inline bar chart used in profile/analytics surfaces. |

### 3.4 Inputs

| File | Component | Notes |
|---|---|---|
| `Inputs/AppToggle.swift` | `AppToggle` | `(isOn: Binding<Bool>)`. SwiftUI `Toggle` with `AppColor.green` tint. |
| `Inputs/FilterChips.swift` | `FilterChips<T: Hashable>` | `(options:, selected:, label:, onSelect:)`. Horizontal scrolling capsule selector used by `TrainView`, `SkillsView`, `CategoryView`, `ExportDataView`, `RestTimerSettingsView`, `WorkoutRemindersView`, `SendFeedbackView`. |
| `Inputs/SearchField.swift` | `SearchField` | `(text: Binding<String>, placeholder:)`. 48pt-tall capsule textfield with `magnifyingglass` glyph. Used by `LibraryView`, `CategoryView`, `LanguageSettingsView`, `HelpFAQView`. |

### 3.5 Lists — `Components/Lists/SettingsList.swift`

| Component | Purpose |
|---|---|
| `SettingsListHeader` | Uppercased section caption above grouped rows. |
| `SettingsListGroup` | Rounded card container that wraps grouped rows. |
| `SettingsListRow<Trailing: View>` | Tappable row with icon, label, optional sub-text, custom trailing view, and a 1pt hairline divider. Action defaults to nil; row is `.disabled` when no action is supplied. |
| `SettingsListRow where Trailing == DisclosureChevron` | Convenience initializer that auto-applies a `DisclosureChevron`. |
| `DisclosureChevron` | Right-pointing chevron in `AppColor.textHint`. |

### 3.6 Navigation

| File | Component | Notes |
|---|---|---|
| `Navigation/AppHeader.swift` | `AppHeader` | `(eyebrow:, title:, subtitle:, trailing:)`. The header used at the top of every tab root. |
| `Navigation/AppHeader.swift` | `AppNavBar` | Custom 48pt nav bar with chevron-left back button + optional right action. Reserved for screens that hide the system nav. |
| `Navigation/SectionHeader.swift` | `SectionHeader` | `(_ title:, actionTitle:, action:)`. H3 title with an optional brand-blue action label. |

### 3.7 Overlays

| File | Component | Notes |
|---|---|---|
| `Overlays/AccentPill.swift` | `AccentPill` | `(_ title:, color:)`. Uppercase pill: 14% accent fill, 32% accent border, monospaced text. Used for difficulty pills, tier labels, badges. |

### 3.8 Progress

| File | Component | Notes |
|---|---|---|
| `Progress/AppProgressBar.swift` | `AppProgressBar` | `(progress:, color:, height:)`. Capsule track on `AppColor.elevated` with an accent fill. Progress is clamped 0…1. |
| `Progress/RingProgress.swift` | `RingProgress` | `(progress:, color:, size:, label:)`. Donut ring with a centered monospaced label. Used for program adherence rings. |
| `Progress/TierDots.swift` | `TierDots` | `(current:, total:, accent:, height:)`. Capsule sequence for skill tiers; left-to-right fill. |

### 3.9 Sheets

| File | Component | Notes |
|---|---|---|
| `Sheets/SheetHandle.swift` | `SheetHandle` | `Capsule` indicator for any modal sheet header. |

---

## 4. Per-Feature Containers

Some feature surfaces ship their own container/composition primitives that compose the design system:

| File | Component | Purpose |
|---|---|---|
| `Features/Settings/Presentation/Views/SettingsScreen.swift` | `SettingsScreen` | Standard settings layout: scroll body, optional sticky `PrimaryButton` CTA, navigation title + optional trailing toolbar action. |
| `Features/Settings/Presentation/Views/AccountSettingsViews.swift` | `FieldCard` | Labelled text/secure/multiline field used by `EditProfileView`, `ChangePasswordView`, `SendFeedbackView`. |
| `Features/Skills/Presentation/Views/SkillDetailView.swift` | `BackChromeButton` | Translucent back chevron overlaid on the skill hero. |
| `Features/Exercise Library/Presentation/Views/ExerciseDetailView.swift` | `FlowLayout` | Wrapping grid of accent pills for muscle lists. |

These are not promoted to `Shared/DesignSystem/` because they only have one consumer each.

---

## 5. Composition Rules

- Reach for `AppColor.*`, `AppSpacing.*`, `AppRadius.*`, `Font.appX`, and the design-system components before introducing local styling.
- Cards have a 1pt `AppColor.border` border in every standard usage. Hero gradient cards use a 22% accent border instead.
- Buttons use action verbs. `PrimaryButton` and `OutlineButton` come in a 50pt height, 15pt radius pair.
- Numeric values use a monospaced font (`Font.appMono`, `Font.appMonoLarge`, or `Font.system(... design: .monospaced)`).
- Difficulty pills must call `AppColor.difficulty(_:)`.
- Bottom-tab clearance is `AppLayout.bottomBarClearance`.
- Screen horizontal padding is `AppSpacing.lg`.

---

## 6. When To Add A New Component

Promote a view to the design system only when:

- It appears in two or more features, or
- It encodes a product invariant (stat formatting, difficulty color, tier dots), and
- It can be expressed as a small reusable struct with explicit inputs.

Until then, keep one-off composition inside the feature's `Presentation/Views/` folder.
