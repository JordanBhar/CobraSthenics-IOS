# CobraSthenics — iOS Architecture

**Version:** 4.0.0
**Date:** 2026-05-28
**Status:** Reflects current implementation
**Platform:** Native iOS · SwiftUI · Observation framework · Swift Concurrency

---

## 1. Overview

CobraSthenics is a native SwiftUI iOS application for calisthenics and gymnastic-rings athletes. The current implementation runs entirely from in-memory sample repositories, follows a feature-first Clean Architecture layout, and renders a dark-themed five-tab shell.

The codebase is organized into four top-level layers under `CobraSthenics/`:

```text
App/        - app composition, environment, tab shell
Core/       - cross-cutting protocols, constants, persistence models, utilities
Shared/     - design system, shared domain primitives, sample data
Features/   - vertical product slices (Domain / Data / Presentation)
Resources/  - Assets.xcassets
```

There is no Firebase, network, or SwiftData store wired into runtime today. `Core/Persistence` declares SwiftData `@Model` types and `Core/Networking` declares a `NetworkClient` protocol — these are scaffolding for the future production data layer described in `backend_architecture.md`.

---

## 2. Architectural Principles

### Clean Architecture (feature slices)

Dependencies point inward:

```text
Presentation ──▶ Domain ◀── Data
```

Each feature folder is a self-contained vertical slice:

```text
Features/<Feature>/
├── Domain/
│   ├── Entities/        - pure Swift value types
│   └── Repositories/    - protocols
├── Data/
│   └── Repositories/    - sample implementations
└── Presentation/
    ├── ViewModels/      - @Observable @MainActor
    └── Views/           - SwiftUI views
```

### ViewModel ▶ Repository (no Use Case layer today)

The current implementation skips Use Cases. ViewModels hold a repository protocol and call it directly:

```swift
@Observable @MainActor
public final class HomeViewModel {
    var homedata: HomeModel?
    var isLoading = false

    private let homeRepository: any HomeRepository

    public init(homeRepository: any HomeRepository) {
        self.homeRepository = homeRepository
    }

    func load() async {
        guard homedata == nil else { return }
        isLoading = true
        defer { isLoading = false }
        homedata = try? await homeRepository.getHomeSnapshot()
    }
}
```

A Use Case layer may be introduced when business logic outgrows what fits naturally on a repository method.

### Dependency Inversion

Domain defines repository protocols. Data implements them. `AppEnvironment` wires concrete repositories and the SwiftUI environment delivers them to the views that own ViewModels.

---

## 3. Actual Project Layout

```text
CobraSthenics/
├── App/
│   ├── CobraSthenicsApp.swift       - @main, builds AppEnvironment.preview
│   ├── AppShell.swift               - TabView with 5 NavigationStacks
│   ├── AppEnvironment.swift         - @Observable container of repository protocols
│   ├── AppRouter.swift              - placeholder
│   ├── AppCoordinator.swift         - placeholder
│   └── DependancyContainer.swift    - placeholder
│
├── Core/
│   ├── Constants/                   - AppConstants, HomeConstants, LibraryConstants,
│   │                                  ProfileConstants, SkillsConstants, TrainConstants
│   ├── Extensions/Array+SafeAccess.swift
│   ├── Firebase/FirebaseAdapterError.swift
│   ├── Networking/NetworkClient.swift
│   ├── Persistence/                 - LocalExerciseCache, LocalSkillLog,
│   │                                  LocalWorkoutSession (SwiftData @Model)
│   ├── Protocols/Loadable.swift
│   ├── SharedServices/DateProviding.swift
│   ├── Storage/KeyValueStorage.swift
│   └── Utilities/Clamp.swift
│
├── Shared/
│   ├── DesignSystem/
│   │   ├── Animations/AppAnimation.swift
│   │   ├── Components/
│   │   │   ├── Buttons/             - PrimaryButton, OutlineButton
│   │   │   ├── Cards/               - AppCard, GradientCard
│   │   │   ├── Charts/              - HeatmapGrid, MiniBarChart
│   │   │   ├── Inputs/              - AppToggle, FilterChips, SearchField
│   │   │   ├── Lists/               - SettingsList (Header/Group/Row/Chevron)
│   │   │   ├── Navigation/          - AppHeader, AppNavBar, SectionHeader
│   │   │   ├── Overlays/            - AccentPill
│   │   │   ├── Progress/            - AppProgressBar, RingProgress, TierDots
│   │   │   └── Sheets/              - SheetHandle
│   │   ├── Extensions/Color+Hex.swift
│   │   ├── Icons/AppIcons.swift     - placeholder
│   │   ├── Layout/AppLayout.swift
│   │   ├── Modifiers/AppNavigationModifiers.swift
│   │   └── Theme/                   - AppColors, Spacing, Theme (AppRadius),
│   │                                  Typography (Font.appX extensions)
│   ├── Models/DomainTypes.swift     - Difficulty, ColorPair, WeekDay
│   └── SampleData/SampleData.swift
│
├── Features/
│   ├── Home/                        - Domain · Data · Presentation
│   ├── Workout/                     - Domain · Data · Presentation  (Train tab)
│   ├── Skills/                      - Domain · Data · Presentation
│   ├── Exercise Library/            - Domain · Data · Presentation  (Library tab)
│   ├── Profile/                     - Domain · Data · Presentation
│   ├── Program/                     - Domain · Data only (no Presentation today)
│   └── Settings/                    - Domain · Data · Presentation (multiple screens)
│
└── Resources/Assets.xcassets
```

Notes on current state:

- `AppRouter.swift`, `AppCoordinator.swift`, `DependancyContainer.swift`, and `AppIcons.swift` exist as empty placeholders. Navigation today is handled directly via the per-tab `NavigationStack` and SwiftUI `NavigationLink`. Dependency wiring is centralized in `AppEnvironment`.
- The `Program` feature has Domain and Data only (`ActiveProgram`, `ProgramRepository`, `SampleProgramRepository`). Active-program rendering is delivered through `HomeRepository` and `WorkoutRepository` snapshots.
- The folder is named `Exercise Library/` (with a space) on disk to match the Xcode group.

---

## 4. App Layer Responsibilities

### `CobraSthenicsApp`

Application entry point. Initialises `AppEnvironment.preview`, injects it into the SwiftUI environment, and forces `.dark` color scheme:

```swift
@main
struct CobraSthenicsApp: App {
    @State private var environment = AppEnvironment.preview

    var body: some Scene {
        WindowGroup {
            AppShell()
                .environment(environment)
                .preferredColorScheme(.dark)
        }
    }
}
```

### `AppShell`

The single root view. Owns the `TabView` and the per-tab `NavigationStack`. Reads `AppEnvironment` from the SwiftUI environment and constructs each tab's root ViewModel with the relevant repository. Tabs (fixed order):

| Tag | Label | Icon | Root View | ViewModel | Repository |
|---|---|---|---|---|---|
| `.home` | Home | `house.fill` | `HomeView` | `HomeViewModel` | `HomeRepository` |
| `.train` | Train | `calendar` | `TrainView` | `TrainViewModel` | `WorkoutRepository` |
| `.library` | Library | `book.closed` | `LibraryView` | `LibraryViewModel` | `ExerciseRepository` |
| `.skills` | Skills | `chart.xyaxis.line` | `SkillsView` | `SkillsViewModel` | `SkillRepository` |
| `.profile` | Profile | `person.fill` | `ProfileView` | `ProfileViewModel` | `UserRepository`, `SettingsRepository` |

The tab order is fixed by product rule and by `AppShell.body`.

### `AppEnvironment`

`@Observable @MainActor` container that holds the seven repository protocols the app currently wires:

```swift
public final class AppEnvironment {
    public let homeRepository: any HomeRepository
    public let userRepository: any UserRepository
    public let settingsRepository: any SettingsRepository
    public let workoutRepository: any WorkoutRepository
    public let skillRepository: any SkillRepository
    public let exerciseRepository: any ExerciseRepository
    public let programRepository: any ProgramRepository
}
```

`AppEnvironment.preview` is the only composition root in the codebase today. It instantiates every `Sample*Repository` and is used by both the app entry point and SwiftUI previews.

### `AppRouter` / `AppCoordinator` / `DependancyContainer`

Empty placeholder files. Navigation is currently expressed through SwiftUI's `NavigationStack` + `NavigationLink` inside views (e.g. `SkillsView` → `SkillDetailView`, `LibraryView` → `CategoryView` → `ExerciseDetailView`, `ProfileView` → settings destinations).

---

## 5. Core Layer

`Core/` contains framework-level utilities and contracts that are not feature-specific.

| File | Purpose |
|---|---|
| `Constants/AppConstants.swift` | `AppConstants.appName` and `NavigationTabConstants` (tab labels + SF Symbols). |
| `Constants/{Home,Library,Profile,Skills,Train}Constants.swift` | UI string and icon constants per feature surface. |
| `Extensions/Array+SafeAccess.swift` | `subscript(safe:)` returns optional element. |
| `Firebase/FirebaseAdapterError.swift` | Single-case error enum (`.notImplemented`) reserved for future Firebase adapters. |
| `Networking/NetworkClient.swift` | `protocol NetworkClient` with `URLSession` conformance. |
| `Persistence/LocalExerciseCache.swift` | SwiftData `@Model` for cached exercises. |
| `Persistence/LocalSkillLog.swift` | SwiftData `@Model` for offline skill log writes. |
| `Persistence/LocalWorkoutSession.swift` | SwiftData `@Model` for offline workout sessions. |
| `Protocols/Loadable.swift` | `protocol Loadable { func load() async }`. |
| `SharedServices/DateProviding.swift` | `DateProviding` protocol + `SystemDateProvider`. |
| `Storage/KeyValueStorage.swift` | `KeyValueStorage` protocol with `UserDefaults` conformance. |
| `Utilities/Clamp.swift` | `clamped(_:to:)` generic helper. |

The SwiftData `@Model` classes are declared but no `ModelContainer` is configured at app startup yet — they are scaffolding for the offline-first data layer described in `database.md` and `backend_architecture.md`.

---

## 6. Shared Layer

`Shared/` holds primitives used by more than one feature.

- `DesignSystem/` — see `Docs/Design/design_system.md` for the component catalogue. Owns colors (`AppColor`), spacing (`AppSpacing`), radii (`AppRadius`), typography (`Font.appH1` … `Font.appMonoLarge`), layout (`AppLayout`), animations (`AppAnimation`), the `Color+Hex` initializer, the platform-conditional `appNavigationBarHidden` / `appNavigationBarTitleDisplayModeInline` / `appTextInputAutocapitalizationNever` modifiers, and every shared SwiftUI component.
- `Models/DomainTypes.swift` — cross-feature value types: `Difficulty` enum (with `unknown` fallback), `ColorPair` (two hex codes that resolve to `[Color]`), `WeekDay`.
- `SampleData/SampleData.swift` — every preview/runtime value: `user`, `weekDays`, `activeProgram`, `recentWorkouts`, `workouts`, `categories`, `exercises`, `skills`, `heatmap`, `personalRecords`, `muscles`, `skillTrends`, `settingGroups`. All `Sample*Repository` implementations read from this file.

---

## 7. Feature Architecture

Every feature folder follows the same three-layer shape.

### Domain

Pure Swift. Contains:

- **Entities** — `Codable` `Hashable` structs that hold the data the UI renders. Where a model needs to project SwiftUI types (e.g. `Color`), it stores raw `UInt` hex and exposes a computed `Color` (`accent`, `colors`).
- **Repository protocols** — small async-throws surfaces named in product language (`getHomeSnapshot`, `getActiveProgram`, `getSkills`, `getExerciseCategories`, etc.).

Domain code does not import SwiftUI in entities that are pure data, but several entities import `SwiftUI` to publish convenience color properties. The convention is acceptable today because all data ships from in-memory sample sources; production Firebase adapters will keep Color projections in the Presentation layer.

### Data

Holds repository implementations. Today every concrete implementation is a `Sample*Repository` that returns values from `SampleData`. Future Firebase or SwiftData implementations live here and continue to satisfy the same Domain protocol.

### Presentation

- **ViewModels** are `@Observable @MainActor final class` types. They store view-ready state (`var` properties) and expose `async` methods (`load()`, `selectedCategory`, `count(.active)` etc.). They hold the repository protocol via `any <Protocol>`.
- **Views** are `struct` `View` types. The root view of each tab uses `@State private var viewModel: <ViewModel>` and calls `viewModel.load()` from `.task { … }`. Sub-views (e.g. `SkillDetailView`, `ExerciseDetailView`, `CategoryView`) receive the relevant repository explicitly from the parent (read off `AppEnvironment` via `@Environment(AppEnvironment.self)`).

### Per-feature summary

| Feature | Domain entities | Repository | ViewModel | Primary view(s) |
|---|---|---|---|---|
| Home | `HomeModel` | `HomeRepository` | `HomeViewModel` | `HomeView` |
| Workout | `Workout`, `RecentWorkout`, `WorkoutCategory` | `WorkoutRepository` | `TrainViewModel` | `TrainView` |
| Skills | `SkillModel`, `SkillStatus`, `SkillSessionEntry` | `SkillRepository` | `SkillsViewModel` | `SkillsView`, `SkillDetailView` |
| Exercise Library | `ExerciseCategory`, `Exercise`, `ProgressionChain`, `PersonalRecord`, `SetType` | `ExerciseRepository` | `LibraryViewModel` | `LibraryView`, `CategoryView`, `ExerciseDetailView`, `ExerciseVideoSection` |
| Profile | `UserProfileModel`, `Achievement`, `ProfileSnapshot`, `MuscleStat`, `SkillTrend`, `PrEntry` | `UserRepository` | `ProfileViewModel` | `ProfileView` |
| Program | `ActiveProgram` | `ProgramRepository` | — | — (consumed by Home / Workout) |
| Settings | `SettingItemModel`, `SettingGroupModel`, `SettingsRoute` | `SettingsRepository` | — (loaded by `ProfileViewModel`) | `SettingsScreen` + 12 detail screens |

Details for each feature live in `Docs/Features/*.md`.

---

## 8. Dependency Injection Flow

There is no DI framework. Composition is explicit and centralized:

```text
CobraSthenicsApp
  └── AppEnvironment.preview   ← composition root
        └── Sample*Repository  ← Domain protocols implemented here
              ↓
        environment(\.AppEnvironment)
              ↓
  AppShell ── reads AppEnvironment from SwiftUI environment
        ↓
  Tab body: constructs ViewModel(<repository>: environment.<repo>)
        ↓
  RootView(viewModel:)
        ↓
  Subviews read AppEnvironment when they need to construct another
  child ViewModel or pass a repository to a detail screen
  (e.g. SkillsView → SkillDetailView(skill:, skillRepository:))
```

Rules:

- Only `AppEnvironment.preview` exists today. A `live` environment will be added when Firebase adapters land.
- ViewModels never reference `AppEnvironment` themselves — they receive their dependencies via initializer.
- Views may read `AppEnvironment` only to pass a repository down to a child that needs to build its own ViewModel or perform a load.

---

## 9. Navigation Architecture

Navigation is implemented with stock SwiftUI primitives:

- The root contains five independent `NavigationStack`s — one per tab. Tab-level state is preserved across switches.
- Push navigation uses `NavigationLink { Destination(...) } label: { Tile(...) }`.
- No global typed route enum (`AppRoute`) exists yet. `AppRouter.swift` is reserved for that direction.
- `SettingsRoute` enum (`Features/Settings/Domain/Entities/SettingsModels.swift`) is used as the route value for the Profile → settings sub-tree; the destination is resolved by `ProfileView.destination(for:)` which switches over the enum.

Header chrome:

- Tab roots set `.appNavigationBarHidden(true)` and render their own `AppHeader`.
- Detail screens (e.g. `CategoryView`, `SkillDetailView`, `ExerciseDetailView`, `SettingsScreen`) use `.navigationTitle(_)` plus `.appNavigationBarTitleDisplayModeInline()`. `SkillDetailView` further hides the system nav bar and overlays its own `BackChromeButton`.

---

## 10. State Management

- View models use the Observation framework (`@Observable` + `@MainActor`). They are owned by their root view via `@State private var viewModel: <T>`.
- Loading is one-shot today: every `load()` short-circuits if data is already present (`guard homedata == nil else { return }`, `guard workouts.isEmpty else { return }`, etc.).
- View state is plain `var` properties on the view model. No separate `Loadable<T>` wrapper is used yet, despite `Core/Protocols/Loadable.swift` reserving the name.
- View-local state (search text, selected detail tab, expansion flags) uses `@State` inside the view.
- All async work is `async`/`await` with `try?` swallowing errors at the view model boundary. There is no UI-facing error surface today.

---

## 11. Design System Integration

The design system is the only source of styling for feature code. Feature views reach for `AppColor`, `AppSpacing`, `AppRadius`, `Font.appX`, `AppAnimation`, and the component primitives directly — they never define one-off palettes, radii, or font sizes.

See `Docs/Design/design_system.md`, `Docs/Design/ui_rules.md`, `Docs/Design/animations.md`, and `Docs/Design/branding.md`.

---

## 12. Error Handling (current state)

Today:

- ViewModels use `try? await repo.<method>()` and surface `nil` to the view. Loading falls back to a `ProgressView` (`HomeView`, `ProfileView`) or an empty list.
- `FirebaseAdapterError.notImplemented` is the only typed failure declared in `Core/`.

When a real data layer lands the plan is to convert SDK errors at the repository implementation boundary into a typed app failure and expose `errorMessage` / `state` on the view model (see `backend_architecture.md`).

---

## 13. Testing

The project ships two test bundles:

- `CobraSthenicsTests` — XCTest unit tests.
- `CobraSthenicsUITests` — XCUITest UI tests plus launch tests.

See `Docs/Engineering/testing_strategy.md` for the current scope.

---

## 14. Architecture Decisions

### ADR-001 — Observation framework for view models

`@Observable @MainActor` view models are the default. No Combine is used. Observation integrates directly with SwiftUI without the boilerplate of `ObservableObject`.

### ADR-002 — Repository protocol called directly from view models

Use cases were intentionally omitted to keep the surface area small while features are still scaffolding from sample data. A use case is introduced only when business logic needs to coordinate multiple repositories or has non-trivial rules.

### ADR-003 — Centralized composition through `AppEnvironment`

`AppEnvironment` is the single composition root. Each tab constructs its root view model inline using `environment.<repository>`. This avoids a service-locator pattern and keeps dependency wiring visible at the call site.

### ADR-004 — SwiftData reserved for the offline cache

Local persistence types live in `Core/Persistence` as SwiftData `@Model` classes but are not yet wired to a `ModelContainer`. They were authored ahead of the data layer so the offline-first shape (`pendingSync`, `updatedAt`) is fixed.

### ADR-005 — Dark mode only

`CobraSthenicsApp` forces `.preferredColorScheme(.dark)`. The design system has no light-mode tokens.

### ADR-006 — Five-tab `AppShell`

Tab count, labels, order, and SF Symbol icons are encoded in `NavigationTabConstants` (`Core/Constants/AppConstants.swift`) and `AppShell`. The order is a hard product rule.

---

## 15. Dependency Graph

```text
App (CobraSthenicsApp, AppShell, AppEnvironment)
  uses: Foundation, SwiftUI, Observation
  composes: Sample*Repository implementations
  exposes: AppEnvironment to all views

Features/<X>/Presentation
  depends on: Features/<X>/Domain (entities + repository protocol)
  uses: SwiftUI, Observation, Shared/DesignSystem, Core/Constants
  receives: repository via initializer

Features/<X>/Data
  depends on: Features/<X>/Domain
  uses: Foundation, Shared/SampleData (today)
  will use: Firebase iOS SDKs, SwiftData ModelContainer, URLSession (planned)

Features/<X>/Domain
  uses: Foundation (and SwiftUI where Color projections are exposed)

Shared/DesignSystem
  uses: SwiftUI
  exposes: components, tokens, modifiers, fonts

Core
  uses: Foundation, SwiftData (Persistence only), SwiftUI (Modifiers only)
```

---

*Maintained alongside the source. Update this file when the App layer, repository surface, or feature folder shape changes.*
