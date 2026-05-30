# Skills Feature

Tracks long-term calisthenics progressions (Front Lever, Handstand, L-Sit, Planche, Muscle-Up). Exposes a skill index, per-skill detail with instructions/muscles/history tabs, and per-tier progress.

## Feature Layout

```
Features/Skills/
├── Domain/
│   ├── Entities/SkillModels.swift     (SkillStatus, SkillModel, SkillSessionEntry)
│   └── Repositories/SkillRepository.swift
├── Data/
│   └── Repositories/SampleSkillRepository.swift
└── Presentation/
    ├── ViewModels/SkillsViewModel.swift
    └── Views/
        ├── SkillsView.swift
        └── SkillDetailView.swift
```

## Domain

### Entities

```swift
public enum SkillStatus: String, Codable, CaseIterable {
    case active, started, locked, mastered, unknown
}

public struct SkillModel: Identifiable, Codable, Hashable {
    public var id: String { name }
    public let name: String
    public let family: String          // "pull" | "push" | "core" | …
    public let currentTier: String
    public let nextTier: String
    public let tierIndex: Int
    public let totalTiers: Int
    public let bestDisplay: String?    // e.g. "8s"
    public let target: String          // e.g. "10s"
    public let progressPercent: Int    // 0…100
    public let colorPair: ColorPair
    public let accentHex: UInt
    public let status: SkillStatus
    public let isStaticHold: Bool
    public let instructions: [String]
    public let primaryMuscles: [String]
    public let secondaryMuscles: [String]
}

public struct SkillSessionEntry: Identifiable, Codable, Hashable {
    public let dateLabel: String
    public let valueDisplay: String
    public let isPR: Bool
}
```

`SkillStatus.init(from:)` decodes unknown values as `.unknown`.

### Repository

```swift
public protocol SkillRepository {
    func getSkills() async throws -> [SkillModel]
    func getSkillHistory(skillName: String) async throws -> [SkillSessionEntry]
}
```

## Data

`SampleSkillRepository`:

- `getSkills()` → `SampleData.skills` (5 entries: Front Lever, Handstand, L-Sit, Planche, Muscle-Up).
- `getSkillHistory(skillName:)` → a fixed 4-entry array (`Today 8.2s PR`, `May 12 7.1s`, `May 10 6.8s`, `May 8 5.5s`). The skill name is currently ignored.

## Presentation

### `SkillsViewModel`

```swift
@Observable @MainActor
public final class SkillsViewModel {
    var skills: [SkillModel] = []
    var selectedFamily = "all"

    var families: [String] {
        ["all"] + Array(Set(skills.map(\.family))).sorted()
    }

    var filteredSkills: [SkillModel] {
        selectedFamily == "all" ? skills : skills.filter { $0.family == selectedFamily }
    }

    func count(_ status: SkillStatus) -> Int {
        skills.filter { $0.status == status }.count
    }
}
```

### `SkillsView`

Layout:

1. **Header** — `AppHeader` with subtitle `"\(active) active · \(locked) locked · \(mastered) mastered"`.
2. **Stats row** — three `AppCard` stat tiles: `Active`, `Sessions` (hard-coded `47`), `PRs Set` (hard-coded `12`).
3. **Family filter** — `FilterChips` over `viewModel.families` derived from the skills list.
4. **Skill cards** — vertical stack of `SkillCard`s wrapped in `NavigationLink { SkillDetailView(…) }`. Locked skills are disabled (`.disabled(skill.status == .locked)`).

#### `SkillCard` (private to the file)

- Icon tile (`lock.fill` when locked, `target` otherwise) in a `GradientCard`-style gradient.
- Tier subtitle (`"Tier \(tierIndex) of \(totalTiers) · \(currentTier)"`) or "Complete prerequisites to unlock" when locked.
- `TierDots(current: tierIndex, total: totalTiers, accent:)` for progress.
- For unlocked skills only: `BEST` / `TARGET` / `PROGRESS` tiles + two action tiles (`Train`, `Analyse Form`).

### `SkillDetailView`

`SkillDetailView` is opened from `SkillsView`'s `NavigationLink`. It receives the `SkillModel` and `SkillRepository`.

Layout:

1. **Hero** — full-bleed gradient using `skill.colors` with a radial glow. Shows `AccentPill("FAMILY · TIER X OF Y")`, skill name (30pt black), and `"\(currentTier) → \(nextTier)"`. A `BackChromeButton` overlays the top-left.
2. **Stats row** — three `AppCard`s for `Best`, `Target`, `Progress`.
3. **Tier card** — current tier label + `TierDots`.
4. **Tab selector** — three segments (`Instructions`, `Muscles`, `History`) animated with `AppAnimation.quick`.
5. **Tab content**:
   - **Instructions** — numbered `AppCard` rows from `skill.instructions`.
   - **Muscles** — `FlowLayout` (defined in `ExerciseDetailView.swift`) for primary/secondary muscles. When `isStaticHold` is true, a tinted "HOLD TYPE" callout card is appended.
   - **History** — `AppCard` rows from the repository's `SkillSessionEntry` list. PR entries get a `PR` pill + accent border.
6. **Sticky CTA bar** — `PrimaryButton("Train Skill")` + `OutlineButton("Analyse Form")` over a vertical fade.

Navigation chrome: hides the system nav bar (`.toolbar(.hidden, for: .navigationBar)`) and uses the overlaid `BackChromeButton` instead.

## Dependencies

- `Shared/DesignSystem`: `AppCard`, `GradientCard`, `SectionHeader`, `AppHeader`, `FilterChips`, `TierDots`, `AppProgressBar`, `AccentPill`, `PrimaryButton`, `OutlineButton`.
- `Core/Constants/SkillsConstants.swift` for content strings.
- `FlowLayout` from `Features/Exercise Library/Presentation/Views/ExerciseDetailView.swift`.

## Data Flow

```
SkillsView .task
  → SkillsViewModel.load()
    → SkillRepository.getSkills()
  → SkillsView renders filteredSkills

NavigationLink → SkillDetailView (skill, repository)
  → .task fetches skillRepository.getSkillHistory(skillName:)
  → history tab renders the result
```

## Difficulty Rule

Difficulty pills in skill cards must follow the fixed mapping `AppColor.difficulty(_:)`:

| `Difficulty` | Color |
|---|---|
| `.beginner` | green |
| `.intermediate` | orange |
| `.advanced` | red |
| `.elite` | purple |
