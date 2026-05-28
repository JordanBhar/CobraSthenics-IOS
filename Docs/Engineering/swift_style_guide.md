# CobraSthenics — Swift Style Guide

## Naming

- Types: `PascalCase` (`HomeViewModel`, `SkillRepository`, `AppCard`).
- Properties, methods, enum cases, locals: `camelCase`.
- Protocols describe capability (`HomeRepository`, `NetworkClient`, `Loadable`, `KeyValueStorage`, `DateProviding`).
- Sample-data implementations are prefixed `Sample` (e.g. `SampleHomeRepository`, `SampleUserRepository`).
- Constants are grouped on `enum` types — `AppConstants`, `AppColor`, `AppSpacing`, `AppRadius`, `AppLayout`, `AppAnimation`, `HomeConstants`, `LibraryConstants`, `ProfileConstants`, `SkillsConstants`, `TrainConstants`.

## Formatting

- 4-space indentation.
- Imports at the top of the file. Keep imports minimal — Domain files usually only need `Foundation`, with `SwiftUI` added when the entity exposes `Color` projections.
- One primary type per file. Local helper types and SwiftUI subviews may sit below the primary type when tightly scoped (`SkillCard` in `SkillsView.swift`, `BackChromeButton` in `SkillDetailView.swift`, `FlowLayout` in `ExerciseDetailView.swift`).
- Group private helpers and small subviews below the primary type body.
- Provide a `#Preview` block for every primary view; use `.environment(AppEnvironment.preview)` for previews that consume the app environment.

## Safety

- Avoid force unwraps.
- Prefer `guard` for early exits.
- Use explicit optionals for uncertain data.
- Use `clamped(_:to:)` for bounded numeric values.

## SwiftUI

- View models are `@Observable @MainActor final class`.
- Owning views hold them with `@State private var viewModel: <ViewModel>`.
- Inject dependencies via initializer; do not reach into singletons.
- Read `AppEnvironment` via `@Environment(AppEnvironment.self)` only where you need to pass a repository down.
- Style with `Shared/DesignSystem` tokens and components — `AppColor`, `AppSpacing`, `AppRadius`, `Font.appX`, `AppCard`, `GradientCard`, `SectionHeader`, `AppHeader`, etc.
- Use the modifiers in `AppNavigationModifiers.swift` (`appNavigationBarHidden`, `appNavigationBarTitleDisplayModeInline`, `appTextInputAutocapitalizationNever`) instead of platform-conditional `#if os(iOS)` blocks at the call site.

## Concurrency

- Prefer `async`/`await`.
- Use `AsyncSequence` for streams once they exist.
- Do not use Combine.
- Keep asynchronous data loading out of pure visual components — drive it from `.task { await viewModel.load() }`.

## Public API surface

- App-level types intended for SwiftUI composition (`AppShell`, `AppEnvironment`, every shared component) are declared `public` with `public init(...)`.
- Domain entities and repository protocols are `public` so they can be referenced across module-like boundaries when the project grows.
