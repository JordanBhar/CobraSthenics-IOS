# CobraSthenics — Testing Strategy

## Test Targets

The project ships two test bundles:

| Target | Framework | Scope |
|---|---|---|
| `CobraSthenicsTests` | XCTest | Unit tests for domain logic, repositories, view models. |
| `CobraSthenicsUITests` | XCUITest | High-value UI flows + launch test. |

Both targets are currently scaffolded with the default Xcode templates (`CobraSthenicsTests.swift`, `CobraSthenicsUITests.swift`, `CobraSthenicsUITestsLaunchTests.swift`). Expand these as features mature.

---

## Unit Tests (XCTest)

Areas to cover as they land:

- **Repository implementations.** Verify `SampleHomeRepository`, `SampleWorkoutRepository`, `SampleSkillRepository`, `SampleExerciseRepository`, `SampleUserRepository`, `SampleProgramRepository`, `SampleSettingsRepository` return the expected `SampleData` shapes.
- **ViewModel state transitions.** Run on `@MainActor`. Verify `load()` idempotency (each view model short-circuits when data is already loaded), filtering (`TrainViewModel.filteredWorkouts`, `LibraryViewModel.filteredCategories`, `SkillsViewModel.filteredSkills`), and counts (`SkillsViewModel.count(_:)`).
- **Domain decoding fallbacks.** Verify `Difficulty.init(from:)` and `WorkoutCategory.init(from:)` decode unknown enum values as `.unknown`.
- **Difficulty mapping.** `AppColor.difficulty(_:)` returns the strict mapping documented in `Docs/Design/ui_rules.md`.
- **PR formatting.** `PersonalRecord.primaryDisplay` produces the expected hold / reps / weight string.
- **Domain projections.** `SkillModel.colors / .accent`, `Exercise.colors / .accent`, `ColorPair.colors`.

When a Use Case layer is introduced, add unit tests against fake repositories conforming to the existing Domain protocols.

---

## UI Tests (XCUITest)

High-value flows to invest in:

- App launch and the five-tab bottom nav (`AppShell`).
- Home tab loads with the streak card, day strip, active program hero, skill focus, and recent activity.
- Library → category → exercise detail navigation.
- Skills tab → skill detail with the Instructions / Muscles / History tab switcher.
- Profile → Settings → at least one detail destination (`SettingsScreen`).

`CobraSthenicsUITestsLaunchTests.swift` already takes a launch screenshot — extend it with critical-screen attachments per release.

---

## Test Data

- Use real exercise / skill / program names (`Push-Up`, `Pull-Up`, `L-Sit`, `Front Lever`, `Beginner Calisthenics`).
- Use the canonical persona from `Shared/SampleData/SampleData.swift` (Jordan Bhar, `@ObsidianCobra`, Level 12 "Ring God", 14-day streak).
- Cover edge cases: missing best hold (`bestDisplay = nil`), locked skills (`status == .locked`), empty workout filters, empty skill histories.

---

## Validation Before Shipping

For code changes:

1. Run relevant unit tests via Xcode (`Cmd + U` on the affected target).
2. Build the project (`BuildProject`).
3. For UI changes, inspect the affected screen with the SwiftUI preview (every primary view ships a `#Preview`).
4. Check against `Docs/Design/ui_rules.md` before accepting visual changes.

For documentation-only changes, no build is required.
