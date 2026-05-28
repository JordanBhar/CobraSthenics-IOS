# New Feature

Use this prompt to introduce a new feature module to CobraSthenics.

---

## Required reading before you start

Load these in order and stop reading when you have enough context for the task:

1. `Docs/Engineering/source_of_truth.md` — authority hierarchy
2. `AI/context/architecture_summary.md` — current shape vs. spec
3. `AI/context/feature_matrix.md` — find the feature row(s) and existing scaffolding
4. `AI/context/project_status.md` — what's wired vs. stubbed
5. `Docs/Product/product_spec.md` — feature definition, IDs (F-xx), screen IDs (S-xx), data entities
6. `Docs/Architecture/architecture.md` — layer rules, dependency direction, navigation
7. `Docs/Architecture/database.md` — Firestore schema, local persistence, sync rules (if persistence touches the feature)
8. `Docs/Design/ui_rules.md` — hard visual rules
9. `Docs/Design/design_system.md` — component recipes
10. `Docs/Engineering/coding_guidelines.md` — layer rules, concurrency, anti-patterns
11. `Docs/Features/<area>.md` — feature-specific copy and behavior expectations

## Task framing

Restate the feature in one paragraph. Identify:

- Feature IDs (F-xx) and screen IDs (S-xx) from the PRD
- Which tab(s) it lives under (Home / Train / Library / Skills / Profile — locked order)
- Whether it requires premium gating
- Whether it requires offline-first writes
- New domain entities it introduces, if any
- New Firestore collections or fields it touches
- New SwiftData `@Model` records it requires

## Architecture checklist

- [ ] Domain types added under shared `Models/` (until per-feature `Domain/` folders are introduced)
- [ ] Repository protocol method(s) added — read-only first; writes follow offline-first pattern from `database.md` §7
- [ ] `SampleDataRepository` updated with realistic Alex Carter sample data (no lorem)
- [ ] `FirebaseAppRepository` stub updated with `notImplemented` or real implementation if backend is being touched
- [ ] If writes: SwiftData `@Model` defined or extended in `Data/Persistence/`
- [ ] If writes: sync state tracked on the local record
- [ ] View model is `@MainActor`. Prefer `@Observable`; if the surrounding feature uses `ObservableObject`, keep the file consistent and flag the migration
- [ ] View model exposes loading / loaded / empty / failed states explicitly
- [ ] SwiftUI view is small and value-typed; no I/O inside the view
- [ ] Navigation uses `NavigationStack` + typed routes when intra-feature drilldown is needed

## Design checklist

- [ ] Page background `#080808`; cards `#111111` fill + 1px `#242424` border + 16px radius + 16px padding
- [ ] Only brand blue `#0A84FF` for interactive accents
- [ ] All numerical values in DM Mono (use `appMono*` font helpers in `DesignSystem/Theme/Typography.swift`)
- [ ] Stat blocks lead with the number, label underneath, UPPERCASE caption
- [ ] Difficulty pills follow the strict mapping (BEGINNER green / INTERMEDIATE orange / ADVANCED red / ELITE purple)
- [ ] Spacing snaps to `AppSpacing` (4/8/12/16/20/24/32) — no off-grid pixel values
- [ ] Reuse `AppCard`, `GradientCard`, `PrimaryButton`, `OutlineButton`, `SectionHeader`, `AccentPill`, `AppProgressBar`, `RingProgress`, `TierDots`, `FilterChips`, `SearchField`, `MiniBarChart`, `HeatmapGrid`, `SettingsList` before authoring new primitives
- [ ] If a new shared visual exists across ≥2 features, promote it into `DesignSystem/Components/` per `design_system.md` "When To Add A Component"
- [ ] Copy uses imperative verbs (Train Skill, Continue Today's Session — never Start / Open / Go)
- [ ] Sample copy uses real exercise names + Alex Carter persona
- [ ] No emoji outside the §5 inventory; no lorem ipsum; no light mode

## State machine sanity

For any non-trivial feature, declare the explicit view-model state machine:

```
.idle | .loading | .loaded(...) | .empty | .failed(message:)
```

If the feature writes data, also declare:

```
.saving | .saveFailed(message:)
```

For offline-first features, never block UI on the remote write.

## Implementation order

1. Add or extend domain models in `Models/`.
2. Add repository protocol method(s).
3. Implement in `SampleDataRepository`.
4. Stub in `FirebaseAppRepository` (or implement if backend is being wired in this PR).
5. Build or update the view model.
6. Build the SwiftUI view using design system primitives.
7. Wire into `AppShell` or the relevant feature root.
8. Add tests: model mapping if mapping was introduced; ViewModel state transitions; repository behavior with fakes.
9. Update `AI/context/feature_matrix.md` and `AI/context/project_status.md` with the new completion state.
10. Run targeted tests and a build before reporting done.

## Done criteria

- Feature renders correctly under sample data on the canvas / preview
- All design checklist boxes pass
- ViewModel tests cover at least the happy path and one failure path
- `feature_matrix.md` reflects the new status (UI / PARTIAL / DONE)
- No `Models/`, `Data/`, or `Features/` file imports Firebase, SwiftData, RevenueCat, StoreKit, or URLSession outside the Data layer
- No view performs I/O directly
