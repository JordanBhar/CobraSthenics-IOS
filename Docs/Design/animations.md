# CobraSthenics — Animation Rules

Motion is restrained, fast, and functional. It exists to make state changes legible without making the app feel playful.

The implementation lives in `Shared/DesignSystem/Animations/AppAnimation.swift`.

---

## 1. Available Animations

The codebase exposes exactly two helpers today. Reach for these by default — do not introduce ad-hoc durations inline.

```swift
public enum AppAnimation {
    public static let quick    = Animation.easeOut(duration: 0.18)
    public static let standard = Animation.easeInOut(duration: 0.28)
}
```

| Helper | Curve | Current usage |
|---|---|---|
| `AppAnimation.quick` | `easeOut(duration: 0.18)` | Segmented tab flips in `SkillDetailView` and `ExerciseDetailView`. |
| `AppAnimation.standard` | `easeInOut(duration: 0.28)` | FAQ accordion expansion in `HelpFAQView`; rest-timer ring update in `RestTimerSettingsView`. |

When new motion is required, add a named static on `AppAnimation` rather than reaching for `.easeInOut(duration: ...)` at the call site.

---

## 2. Easing

Use SwiftUI's `easeOut` and `easeInOut` as exposed via `AppAnimation`. Custom cubic-Bezier curves are not part of the system today.

If a future surface needs a spring or interactive interpolation, name it explicitly on `AppAnimation` (e.g. `AppAnimation.pressPop`).

---

## 3. Required Motions

- **Tab/segmented selector flips** (`SkillDetailView.tabSelector`, `ExerciseDetailView.tabSelector`) use `withAnimation(AppAnimation.quick) { ... }`.
- **FAQ accordion** (`HelpFAQView.faqRow`) uses `withAnimation(AppAnimation.standard) { ... }`.
- **Rest-timer ring** (`RestTimerSettingsView.ringDisplay`) applies `.animation(AppAnimation.standard, value: seconds)` to its `Circle().trim`.

---

## 4. Prohibited Motions

- No animations longer than 360ms.
- No hover lightening or hover darkening as a primary interaction response.
- No frosted glass / backdrop blur transitions.
- No decorative looping motion unless it is an explicit loading affordance.
- No bouncing page transitions.

---

## 5. SwiftUI Guidance

- Keep animations attached to the state that drives them — prefer `.animation(..., value: someState)` or `withAnimation(...) { someState = ... }` over implicit animation modifiers.
- If the same timing appears in more than one feature, promote it to `AppAnimation` instead of duplicating literals.
- Respect Reduce Motion. Preserve the state change; remove decorative movement.
- Do not animate layout in ways that cause text overlap or unstable card heights — `AppCard` heights must remain visually stable.
