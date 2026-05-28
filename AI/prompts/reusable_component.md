# Reusable Component

Use this prompt when adding a primitive to `DesignSystem/Components/`.

---

## Required reading

1. `Docs/Design/ui_rules.md` — every section
2. `Docs/Design/design_system.md` — "When To Add A Component", naming rules
3. `Docs/Design/animations.md` — motion tokens
4. `Docs/Design/branding.md` — voice for sample / preview copy
5. `AI/context/feature_matrix.md` — confirm the visual recurs across ≥2 features

## Promotion criteria

Promote to the design system only when:

- [ ] The pattern appears in two or more features (or is about to)
- [ ] A design rule is easy to violate if repeated inline (e.g., card border, difficulty pill colors)
- [ ] The component encodes a product invariant (stat formatting, difficulty color, brand-blue accent application)

If it's a one-off composition, keep it inside the feature folder instead.

## Naming

Use concrete names (per `design_system.md`):

- `SectionHeader`, `MetricCard`, `StatBlock`, `DifficultyPill`, `PrimaryActionButton`, `SkillProgressBar`
- Avoid vague names like `FancyCard`, `CoolView`, `CustomThing`

Place the file under the right subgroup:

```
DesignSystem/Components/
  Buttons/         primary, outline, ghost
  Cards/           app card, gradient hero
  Charts/          bar, line, heatmap
  Inputs/          search, chips, toggles, text fields
  Lists/           settings rows, denser lists
  Navigation/      headers, section headers
  Overlays/        pills, badges, banners
  Progress/        bars, rings, tier dots
  Sheets/          handles, bottom-sheet helpers
```

## Implementation rules

- Component is a `struct: View` (or `ViewModifier`) — never a class
- Inputs are explicit and small; avoid grab-bag init signatures
- No persistence, networking, or repository access inside a component
- No business decisions (e.g., difficulty-color logic) embedded in the component — pull from `Models/DomainTypes.swift` or `DesignSystem/Theme/Theme.swift`
- Use `AppColor`, `AppSpacing`, `AppRadius`, and the `appXxx` font helpers — no inline hex values, no off-grid spacing, no system fonts
- Components must not invent their own color palettes
- If the component animates, use `AppAnimation` tokens; respect Reduce Motion where decorative

## Visual rules to enforce

- Cards: `#111111` fill + 1px `#242424` border + 16px radius + 16px padding (no borderless cards)
- Buttons: brand blue `#0A84FF` for primary; primary uses 15px radius, 50px height, with the blue glow (`0 4px 18px rgba(10,132,255,0.40)`)
- Pills: tinted accent fill (14% opacity) + 30% opacity border + DM Mono uppercase text + 20px radius
- Stat blocks: huge number in DM Mono first; tiny UPPERCASE caption second; never label-above-number
- Progress bars: neutral track, scoped accent fill, fill-on-appear animation per `animations.md`
- Difficulty pills strictly map: BEGINNER green / INTERMEDIATE orange / ADVANCED red / ELITE purple

## Preview requirements

Provide a `#Preview` block that exercises:

- [ ] Default state
- [ ] Disabled state (if interactive)
- [ ] Long-text / Dynamic Type AX1 state (where text is involved)
- [ ] Loading state (where applicable)

Use Alex Carter and real exercise names in preview copy — never lorem.

## Tests

- Snapshot test the component once snapshot infrastructure exists
- Unit test any non-trivial helpers it pulls in (formatters, color resolvers)
- For now, manual preview verification + design checklist is the minimum bar

## Done criteria

- File lives under `DesignSystem/Components/<group>/`
- Uses only `AppColor` / `AppSpacing` / `AppRadius` / `appXxx` font helpers
- No SDK imports (Firebase, SwiftData, URLSession)
- Reused in at least one consuming view in this PR
- Preview present and renders correctly
