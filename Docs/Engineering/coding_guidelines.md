# CobraSthenics — SwiftUI Coding Guidelines

**Status:** Enforced for all native iOS code
**Reflects:** Current implementation as of 2026-05-28

---

## 1. Core Principles

### Dependency Rule

Dependencies point inward, per feature:

```text
Presentation ──▶ Domain ◀── Data
```

- Domain entities and repository protocols have no dependency on Firebase, SwiftData, or URLSession.
- Presentation depends only on Domain (entities + repository protocol).
- Data implements Domain repository protocols.

### ViewModel → Repository (no Use Case layer today)

The codebase calls repository methods directly from view models. Use cases are not used at present. Introduce a use case only when one of these applies:

- Business logic coordinates more than one repository.
- The same calculation appears in two or more view models.
- The logic has non-trivial rules that benefit from being testable in isolation.

### UI Does Not Perform I/O

SwiftUI views do not call Firebase, write SwiftData, or perform URL requests directly. Views render state and send intents to view models. View models call repositories.

### Prefer Explicit, Typed Code

Use clear domain types, enums, protocols, and small functions. Avoid untyped dictionaries outside DTO boundaries.

### Failures Are Quiet Today, Will Become First-Class

The current codebase uses `try? await repo.<method>()` and falls back to `nil` / empty arrays. This is acceptable while data is sample-only. When real adapters land, repository implementations must convert SDK errors into a typed failure and view models must expose a user-readable error state.

---

## 2. Project Structure

Real layout (see `Docs/Architecture/architecture.md` §3 for the full tree):

```text
CobraSthenics/
├── App/                              composition root + AppShell
├── Core/                             cross-cutting Constants / Persistence / Storage / Networking / SharedServices / Utilities
├── Shared/                           DesignSystem, Models (Difficulty, ColorPair, WeekDay), SampleData
├── Features/<Feature>/
│   ├── Domain/Entities/              pure value types
│   ├── Domain/Repositories/          async-throws protocols
│   ├── Data/Repositories/            Sample* implementations today
│   └── Presentation/{ViewModels,Views}
└── Resources/Assets.xcassets
```

Each feature owns its vertical slice. Shared code must be genuinely reusable and must not know about a specific feature workflow.

---

## 3. Layer Rules

### Domain

Allowed:

- Swift standard library and Foundation value types.
- `SwiftUI` is imported by some Domain entities so they can expose `Color` projections from raw hex (`ColorPair.colors`, `Exercise.accent`). Keep this read-only and minimal.

Not allowed:

- Firebase, SwiftData, CoreData, URLSession, RevenueCat, StoreKit.

Example (already in the codebase):

```swift
public protocol SkillRepository {
    func getSkills() async throws -> [SkillModel]
    func getSkillHistory(skillName: String) async throws -> [SkillSessionEntry]
}
```

### Data

Allowed:

- Foundation, `Shared/SampleData` (today).
- In the future: Firebase iOS SDKs, SwiftData, URLSession.

Responsibilities:

- Implement Domain repository protocols.
- Translate raw data sources into Domain entities.
- Eventually: convert SDK errors into typed failures and manage sync state on the `LocalSkillLog` / `LocalWorkoutSession` SwiftData models.

### Presentation

Allowed:

- SwiftUI, Observation framework, `Shared/DesignSystem`, `Core/Constants`.

Forbidden:

- Direct Firestore paths, DTO mapping, persistence queries, URL requests.
- Domain-laden logic that should live on the entity or in a use case.

---

## 4. State Management

Every UI-facing view model is `@Observable @MainActor`. The pattern in the codebase:

```swift
@Observable
@MainActor
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

Rules:

- Repository is held as `any <Protocol>` and passed via initializer.
- `load()` short-circuits if data is already present (one-shot loading).
- View-local state (search text, selected tab) stays on the view as `@State`.
- Do not introduce Combine. Use Swift Concurrency + Observation.

---

## 5. SwiftUI Rules

Views are value types and should stay focused. The current pattern for every tab root:

```swift
public struct HomeView: View {
    @State private var viewModel: HomeViewModel

    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack {
            AppColor.background.ignoresSafeArea()
            if let _homeData = viewModel.homedata {
                ScrollView { /* … */ }
            } else {
                ProgressView().tint(AppColor.brand)
            }
        }
        .task { await viewModel.load() }
        .appNavigationBarHidden(true)
    }
}
```

Guidelines:

- Use `@State private var viewModel: <ViewModel>` on the owning view.
- Call `viewModel.load()` from `.task { … }`.
- Compose with `Shared/DesignSystem` primitives (`AppCard`, `GradientCard`, `SectionHeader`, `AppHeader`, `FilterChips`, `SearchField`, …).
- Read `AppEnvironment` via `@Environment(AppEnvironment.self)` only when the view needs to pass a repository down to a child detail screen (see `LibraryView`, `SkillsView`, `ProfileView`).
- Use typed enums for local navigation choices (`AppTab`, `DetailTab`, `SkillDetailTab`, `DifficultyFilter`, `SettingsRoute`).
- Use `.appNavigationBarHidden(true)` on tab roots; use `.navigationTitle(_)` + `.appNavigationBarTitleDisplayModeInline()` on detail screens.

---

## 6. Data Modeling

Domain entities follow the same recipe:

- `public struct`
- `Codable`, `Hashable`, `Identifiable` where applicable
- Computed projections (`accent: Color`, `colors: [Color]`) for hex-encoded fields
- Raw decoding tolerant of unknown enum values (`Difficulty.init(from:)`, `WorkoutCategory.init(from:)` decode `unknown` instead of throwing)

Example (current):

```swift
public struct SkillModel: Identifiable, Codable, Hashable {
    public var id: String { name }
    public let name: String
    public let family: String
    public let currentTier: String
    public let nextTier: String
    public let tierIndex: Int
    public let totalTiers: Int
    public let bestDisplay: String?
    public let target: String
    public let progressPercent: Int
    public let colorPair: ColorPair
    public let accentHex: UInt
    public let status: SkillStatus
    public let isStaticHold: Bool
    public let instructions: [String]
    public let primaryMuscles: [String]
    public let secondaryMuscles: [String]

    public var colors: [Color] { colorPair.colors }
    public var accent: Color { Color(hex: accentHex) }
}
```

SwiftData persistence models (`LocalExerciseCache`, `LocalSkillLog`, `LocalWorkoutSession`) live in `Core/Persistence/` — never confuse them with Domain entities.

---

## 7. Concurrency

- Use Swift `async`/`await`.
- Mark UI-facing view models `@MainActor`.
- Keep repositories `Sendable`-friendly when possible (avoid mutable shared state).
- Do not use Combine.
- Do not use detached tasks unless ownership and cancellation are explicit.

---

## 8. Networking

Today the codebase has no live networking. The contract is:

```swift
public protocol NetworkClient {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkClient {}
```

When non-Firebase HTTP is added, write the implementation against `NetworkClient` and inject it through `AppEnvironment` rather than calling `URLSession.shared` directly.

---

## 9. Dependency Injection

- Composition root: `AppEnvironment.preview` (see `App/AppEnvironment.swift`).
- Repositories are wired in `AppEnvironment.init(...)` and exposed as `public let <name>: any <Protocol>` properties.
- `CobraSthenicsApp` injects the environment with `.environment(environment)`.
- `AppShell` constructs the root view model of each tab inline using `environment.<repository>`.
- Sub-views that need their own ViewModel or that pass a repository to a detail screen read `@Environment(AppEnvironment.self)` and forward the relevant repository explicitly.

A `live` `AppEnvironment` will be added alongside Firebase adapters.

---

## 10. Testing Standards

See `Docs/Engineering/testing_strategy.md`. Use XCTest for unit tests and XCUITest for the UI bundle. View-model tests run on `@MainActor` and use fake repositories conforming to the existing protocols.

---

## 11. Anti-Patterns

- Importing Firebase in SwiftUI views.
- Passing SwiftData `@Model` objects into Domain.
- Building Firestore paths in view models.
- Doing JSON parsing in views.
- Using global singletons for repositories.
- Hiding network or persistence failures behind generic strings indefinitely (acceptable while sample-only; not acceptable once real adapters land).
- Treating RevenueCat or StoreKit client state as the security source of truth.
- Blocking app launch on full database synchronization.
- Reaching for raw hex (`Color(hex: 0x…)`) when an `AppColor.*` token already exists.
- Introducing one-off durations instead of adding to `AppAnimation`.

---

*Exceptions require architecture review.*
