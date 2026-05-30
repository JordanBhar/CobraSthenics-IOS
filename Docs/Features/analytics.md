# Analytics

There is no dedicated Analytics tab or feature folder in the current codebase. Analytics-style data is exposed in two places:

1. **Profile snapshot.** `ProfileSnapshot` (in `Features/Profile/Domain/Entities/ProfileAnalyticsModels.swift`) declares `heatmapGrid`, `weeklyVolume`, `personalRecords`, `muscleBreakdown`, and `skillTrends`. `SampleUserRepository.getProfileSnapshot()` returns real data for all of these. `ProfileView` currently renders `personalRecords` (in the Personal Records section) but does not render heatmap, weekly volume, muscle breakdown, or skill trends.
2. **Home dashboard.** `HomeView` renders the day strip (`WeekDay` array) and the streak count from `HomeModel.streakDays` — but `sessions` / `total sets` are hard-coded strings inside the view.

Charts are implemented as design-system primitives:

- `Shared/DesignSystem/Components/Charts/HeatmapGrid.swift` — `(grid: [[Int]], color: Color)`.
- `Shared/DesignSystem/Components/Charts/MiniBarChart.swift` — `(values: [Double], color: Color, height: CGFloat = 56)`.

Neither chart has a consumer yet; both are ready to be dropped into a future analytics surface.

## Domain Types Available

| Type | Source | Purpose |
|---|---|---|
| `MuscleStat` | `Features/Profile/Domain/Entities/ProfileAnalyticsModels.swift` | `(name, percent)` ranked muscle breakdown. |
| `SkillTrend` | same | `(skillName, values, unit, colorHex)` + computed `latest` / `gain`. |
| `PrEntry` | same | `(exerciseName, valueDisplay, accentHex)` for the PRs board. |
| `ProfileSnapshot` | same | Composite payload. |
| `WeekDay` | `Shared/Models/DomainTypes.swift` | Day completion flags for the Home strip. |
| `HeatmapGrid` | `Shared/DesignSystem/Components/Charts/HeatmapGrid.swift` | View primitive. |
| `MiniBarChart` | `Shared/DesignSystem/Components/Charts/MiniBarChart.swift` | View primitive. |

## Sample Data Available

`Shared/SampleData/SampleData.swift` ships:

- `heatmap: [[Int]]` — 4×7 grid of `0…2` intensity values.
- `personalRecords: [PrEntry]` — Pull-Up 20 reps, Tuck Front Lever 8s, Weighted Dip +20kg.
- `muscles: [MuscleStat]` — Back 30%, Chest 24%, Core 20%, Shoulders 13%, Arms 8%, Legs 5%.
- `skillTrends: [SkillTrend]` — Front Lever Hold, Handstand Hold, Pull-Up Reps weekly series.

## Presentation Rules

When analytics surfaces are added they must follow the design system rules:

- Numbers lead labels. Use `Font.appMono` or `Font.appMonoLarge`.
- XP, level, PR, and streak accents use `AppColor.gold`.
- Success and progress fills use `AppColor.green`.
- Interactive filters and links use `AppColor.brand`.
- Charts render on `AppColor.background` or inside `AppCard`. No decorative gradients beyond the existing `GradientCard` and `MiniBarChart` opacity ramp.

## Empty States

Empty analytics surfaces should point to a real action — `Continue Today's Session`, `Train Skill`, or `Browse Programs` — using `PrimaryButton`.

## Not Yet Implemented

- A standalone analytics tab or analytics sub-area within Profile.
- Body composition charts, weekly summary screens, consistency calendar, PRs board, top muscles chart, top exercises chart — all listed in `Docs/Product/product_spec.md` but not in the codebase.
- Any persistence-backed aggregation. `MuscleStat` percentages are static sample data; weekly volume is a hard-coded `[Double]`.

When the analytics surface is built, render the existing `ProfileSnapshot` fields through `HeatmapGrid` / `MiniBarChart` and add a dedicated view model that consumes `UserRepository.getProfileSnapshot()` alongside future workout/skill aggregation.
