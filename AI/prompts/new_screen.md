# New Screen

Use this prompt when adding a new SwiftUI screen to an existing feature.

---

## Required reading

1. `Docs/Engineering/source_of_truth.md`
2. `AI/context/feature_matrix.md` — confirm the screen ID (S-xx) and where it slots
3. `Docs/Product/product_spec.md` §5 — find the screen row, list key components
4. `Docs/Design/ui_rules.md` — every section applies
5. `Docs/Design/design_system.md` — primitives to reuse
6. `Docs/Architecture/architecture.md` §6, §7 — view + navigation rules

## Screen plan (write this before coding)

- Screen ID (S-xx) from the PRD
- Parent tab: Home / Train / Library / Skills / Profile
- Navigation entry: pushed from which view, with which typed route?
- View model: new or reuses an existing one?
- Required data: which repository methods does it call?
- State machine: `.loading | .loaded(...) | .empty | .failed`
- Premium-gated? If yes, how is the gate shown? (Paywall sheet or inline lock state)

## Layout checklist

- [ ] Root container uses the `AppLayout` screen helper or the standard ZStack with `AppColor.background` page fill
- [ ] Safe area respected; bottom nav not occluded
- [ ] Default horizontal padding = 20pt (`AppSpacing.lg`)
- [ ] Sticky CTA bars (if any) use a vertical gradient fade `transparent → #080808` per `ui_rules.md` §6.2
- [ ] No backdrop blur anywhere
- [ ] Cards use the standard recipe (no borderless cards)
- [ ] Hero cards (active program, featured skill) use `GradientCard` with the gradient + glow recipe — never a flat solid hero

## Components first

Audit `DesignSystem/Components/` before authoring anything new. Existing primitives:

- Buttons: `PrimaryButton`, `OutlineButton`
- Cards: `AppCard`, `GradientCard`
- Progress: `AppProgressBar`, `RingProgress`, `TierDots`
- Navigation: `AppHeader`, `SectionHeader`
- Inputs: `SearchField`, `FilterChips`, `AppToggle`
- Overlays: `AccentPill`
- Lists: `SettingsList`
- Sheets: `SheetHandle`
- Charts: `MiniBarChart`, `HeatmapGrid`

If you need something that doesn't exist and is likely to recur, build it under `DesignSystem/Components/<group>/` and follow naming in `design_system.md`.

## Typography & numerics

- Headings: SF Pro Display (use `appH1` / `appH2` / `appH3`)
- Body: SF Pro (use `appBody`, `appBodyLarge`)
- Numbers: **always** DM Mono (use `appMono`, `appMonoLarge`, `appDisplay`)
- Labels / pills / stat captions: UPPERCASE, +0.06 to +0.08em tracking — body copy is never uppercase

## Empty / loading / error states

- Loading: preserve final layout dimensions (skeleton card sizes); do not flash an empty screen
- Empty: suggest a concrete next action with real exercise names (e.g., "Log your first set of Tuck Front Lever holds")
- Error: typed message via the view model, presented inline or in a sheet — never as a generic alert

## Accessibility

- VoiceOver labels on all interactive elements (set rows, timers, completion buttons)
- Minimum tap target 44×44pt
- Text scales with Dynamic Type — no fixed pixel font sizes in the view
- Color contrast ≥ 4.5:1 for body, ≥ 3:1 for large text

## Implementation order

1. Confirm the typed route (add a new case to the feature's route enum if needed)
2. Draft the view body using design system primitives — keep it under ~200 lines
3. Wire the navigation entry from the parent view
4. Add or extend the view model
5. Provide a SwiftUI `#Preview` driven by `SampleDataRepository`
6. Update `AI/context/feature_matrix.md` row for the screen ID
7. Run `XcodeRefreshCodeIssuesInFile` on changed files, then a project build

## Done criteria

- Screen renders correctly in preview using sample data
- Every checklist box passes
- No view imports Firebase / SwiftData / RevenueCat / URLSession
- No persistence or network call inside the view body
- The screen ID in `feature_matrix.md` reflects the new state
