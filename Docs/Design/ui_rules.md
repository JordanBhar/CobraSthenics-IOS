# CobraSthenics — UI Rules

> The complete rule book for designing and building CobraSthenics interfaces. If a decision is not covered here, ask before inventing.

CobraSthenics is a **dark-only, premium calisthenics and gymnastic-rings training app**. The aesthetic is closer to a financial-trading terminal than a gamified fitness app — calm, technical, measured.

The codebase pins these rules in concrete tokens under `Shared/DesignSystem/Theme/`. Identifiers below (`AppColor.*`, `AppSpacing.*`, etc.) refer to that source.

---

## 1. Hard Rules (Never Violate)

1. **Dark mode only.** `CobraSthenicsApp` forces `.preferredColorScheme(.dark)`. There is no light theme.
2. **Page background is `#080808`** (`AppColor.background`) — not pure black.
3. **Every standard card uses `AppColor.card` + 1pt `AppColor.border` border** via `AppCard`. Hero `GradientCard`s use a 22% accent border instead. No borderless cards.
4. **`AppColor.brand` (`#0A84FF`) is the only interactive accent.** Primary CTAs, links, active-tab tint, focus rings, and brand pills all use it. No green, gold, or purple buttons.
5. **Every numerical value uses a monospaced font** — `Font.appMono`, `Font.appMonoLarge`, or `Font.system(... design: .monospaced)`. Reps, holds, seconds, percentages, XP, levels, streaks, PRs, durations, and dates.
6. **Bottom nav is exactly 5 tabs in this fixed order:** Home · Train · Library · Skills · Profile. This is encoded in `AppShell` and `NavigationTabConstants`. Never 4 tabs. Never 6. Never reorder.
7. **Use the 8pt grid (`AppSpacing.*`).** `4 · 8 · 12 · 16 · 20 · 24 · 32`. The `4` step is reserved for ultra-tight label-over-stat pairings.
8. **No lorem ipsum.** Use the real exercise/skill vocabulary from `Shared/SampleData/SampleData.swift` and `Docs/Design/branding.md`.
9. **Emoji is scoped** — see §5. Never appears in body copy, headings, buttons, pills, or labels.
10. **No backdrop blur, frosted glass, or decorative drop shadows.** The only shadow in the system is the soft brand-blue glow on `PrimaryButton`.

---

## 2. Color

### 2.1 Surfaces

| Token | Hex | Use |
|---|---|---|
| `AppColor.background` | `#080808` | Page background |
| `AppColor.card` | `#111111` | Every `AppCard` |
| `AppColor.elevated` | `#1A1A1A` | Internal stat boxes, nav pills, inputs |
| `AppColor.elevated2` | `#222222` | Selected tab pill in detail-tab selectors |
| `AppColor.border` | `#242424` | Mandatory 1pt card border |
| `AppColor.border2` | `#2E2E2E` | Hairline when more contrast is needed (sheet handle) |

Surfaces step in three: page → card → elevated. Never stack two surfaces of the same tone.

### 2.2 Accents

| Token | Hex | Only used for |
|---|---|---|
| `AppColor.brand` | `#0A84FF` | The only interactive accent. Active tab, primary CTAs, links, focus rings, brand pills. |
| `AppColor.green` | `#30D158` | Success, skill progress fills, BEGINNER pill, `AppToggle` tint. |
| `AppColor.gold` | `#FFB800` | XP, level, PR, streak. |
| `AppColor.orange` | `#FF9F0A` | INTERMEDIATE pill. |
| `AppColor.red` | `#FF453A` | Errors, destructive actions, ADVANCED pill. |
| `AppColor.purple` | `#BF5AF2` | ELITE pill, skill-tier labels. |
| `AppColor.teal` | `#4DD0E1` | Mobility / full-body category accent. Used sparingly. |

### 2.3 Difficulty mapping (strict)

The mapping is encoded in `AppColor.difficulty(_:)` and is the only valid source for difficulty pill colors:

| `Difficulty` | Color |
|---|---|
| `.beginner` | `AppColor.green` |
| `.intermediate` | `AppColor.orange` |
| `.advanced` | `AppColor.red` |
| `.elite` | `AppColor.purple` |
| `.unknown` | `AppColor.textSecondary` |

Never recolor a difficulty pill to match a card theme.

### 2.4 Text

| Token | Hex | Use |
|---|---|---|
| `AppColor.textPrimary` | `#FFFFFF` | Primary headings and values |
| `AppColor.textSecondary` | `#8A8A8E` | Body text and secondary labels |
| `AppColor.textHint` | `#48484A` | Hints, inactive tabs, disabled state |

### 2.5 Tinting

Accent fills (pills, soft buttons, badges) use opacity tinting — never a mixed solid hex:

- 14% opacity → fill
- 30%–35% opacity → border
- 18% opacity → rare hover hint

`AccentPill`, `OutlineButton`, and most icon background tiles follow this recipe.

---

## 3. Typography

The full type scale lives in `Shared/DesignSystem/Theme/Typography.swift`.

| Font helper | Size · Weight · Design | Use |
|---|---|---|
| `Font.appDisplay` | 38 · `.black` | Hero numbers (rare) |
| `Font.appH1` | 28 · `.black` | Screen titles via `AppHeader` |
| `Font.appH2` | 22 · `.heavy` | Major section titles |
| `Font.appH3` | 17 · `.heavy` | `SectionHeader` |
| `Font.appBodyLarge` | 15 · `.semibold` | Lead body, card titles |
| `Font.appBody` | 13 · `.regular` | Paragraph |
| `Font.appLabel` | 11 · `.bold` | Uppercase labels, nav captions |
| `Font.appCaption` | 10 · `.semibold` | Meta |
| `Font.appMono` | 13 · `.medium`, monospaced | Inline numbers |
| `Font.appMonoLarge` | 20 · `.black`, monospaced | Big stat values |

Rules:

- Headings use `.black` (display / H1) or `.heavy` (H2 / H3).
- Body uses `.regular`–`.semibold`. Never `.bold` on body paragraphs.
- UPPERCASE is reserved for labels, pills, and stat captions. Never uppercase a paragraph.
- Numbers always lead — the value is large and monospaced; the label is small and uppercase below.

```
14            8s             47
DAY STREAK    BEST           SESSIONS
```

---

## 4. Voice & Content

- Terse, athletic, second-person. The product talks to the athlete like a coach who respects their time.
- Use imperative verbs in buttons: *Train Skill*, *Analyse Form*, *Continue Today's Session*, *Browse Programs*.
- Title Case for headings. Sentence case for body. UPPERCASE only for labels, pills, and stat captions.
- Real exercise / skill / program names only. Use `Shared/SampleData/SampleData.swift` for the canonical name set.

---

## 5. Emoji Policy

Emoji is scoped to a small fixed inventory used by `HomeView` and the sample data:

| Emoji | Where it appears |
|---|---|
| 👋 | Once in the greeting (`HomeView`) |
| 🔥 | Once in the streak card (`HomeView`, `HomeConstants.Streak.emoji`) |
| 🎯 | Skill session marker in `HomeView` recent-activity tiles (`HomeConstants.RecentActivity.skillEmoji`) |
| 💪 | Workout session marker in `HomeView` recent-activity tiles (`HomeConstants.RecentActivity.workoutEmoji`) |

Emoji never appears in headings, body copy, buttons, pills, or labels outside this list.

---

## 6. Spacing & Layout

Tokens from `AppSpacing`:

```
AppSpacing.xxs  4
AppSpacing.xs   8
AppSpacing.sm   12
AppSpacing.md   16
AppSpacing.lg   20   ← default screen horizontal padding
AppSpacing.xl   24
AppSpacing.xxl  32
```

Plus:

- `AppLayout.bottomBarClearance = 100` — bottom padding feature roots leave for the tab bar.
- `AppLayout.contentMaxWidth = 720` — reserved for future iPad/macOS adaptation.

Sticky action bars (e.g. `SkillDetailView.ctaBar`, `ExerciseDetailView.stickyCTAs`) sit at the bottom with a vertical gradient fading from `AppColor.background.opacity(0)` up to `AppColor.background`.

---

## 7. Radii

```
AppRadius.xs   8
AppRadius.sm   12   ← icon pills, small chips
AppRadius.md   16   ← default AppCard
AppRadius.lg   20   ← GradientCard hero
AppRadius.xl   24
```

`PrimaryButton` and `OutlineButton` use a literal radius of `15` — an intentional half-step between `sm` and `md`. Do not change to 16.

---

## 8. Cards

### 8.1 `AppCard`

Default: `AppColor.card` background, 1pt `AppColor.border`, `AppRadius.md`, `AppSpacing.md` padding. All four are overridable for one-off needs (e.g. tinted warning cards in `DeleteAccountView`, `SubscriptionView`).

### 8.2 `GradientCard`

Two-stop top-left → bottom-right linear gradient plus a 22% accent border. Used for:

- Active program hero (`HomeView.activeProgramCard`, `TrainView.programHero`)
- Featured skill (`HomeView.skillFocusCard`)
- Category tile (`LibraryView`)
- Category header (`CategoryView.hero`)
- Exercise detail hero (`ExerciseDetailView.hero`)
- Subscription hero (`SubscriptionView.heroCard`)
- Skill detail hero (`SkillDetailView.hero`, custom background composition)

Hero cards always carry the gradient — never a flat solid-color hero.

---

## 9. Pills & Badges

Universal `AccentPill` recipe (`Shared/DesignSystem/Components/Overlays/AccentPill.swift`):

- Background = accent at 16% opacity
- Border = 1pt accent at 32% opacity
- Radius = 8pt
- Text = 10pt `.bold` monospaced UPPERCASE
- Padding = 9pt horizontal · 4pt vertical

Difficulty pills are always built by passing `AppColor.difficulty(exercise.difficulty)` (or equivalent) to `AccentPill`.

---

## 10. Buttons

### `PrimaryButton`

- Solid `color` background (default `AppColor.brand`), white text.
- `Font.appBodyLarge`, 50pt height, 15pt radius.
- No drop shadow today; the brand-blue glow recipe is reserved for sticky CTAs.

### `OutlineButton`

- 14% color fill, 35% color border, accent text.
- Same dimensions as `PrimaryButton`.
- Supports `fullWidth: false` for inline use.

### Press states

Use SwiftUI defaults. Do not add custom darken / lighten effects.

---

## 11. Bottom Navigation

Implementation: `AppShell.swift` + `NavigationTabConstants` (`Core/Constants/AppConstants.swift`).

| Tab | Label | SF Symbol |
|---|---|---|
| `.home` | Home | `house.fill` |
| `.train` | Train | `calendar` |
| `.library` | Library | `book.closed` |
| `.skills` | Skills | `chart.xyaxis.line` |
| `.profile` | Profile | `person.fill` |

Tint: `AppColor.brand`. Background: `AppColor.background`. Tab count, order, and labels are a hard product rule.

---

## 12. Iconography

- Use SF Symbols. Do not introduce custom icon assets unless SF Symbols cannot represent the concept.
- Inline sizes: 12 (caption-row chevron), 14 (button glyph), 18–22 (hero glyph).
- Use `currentColor` via `.foregroundStyle(...)`.
- Never use Unicode arrows. Use `chevron.right` / `chevron.left`.

The system also uses two emoji placeholders for category tiles in `HomeView.recentWorkoutTile` (🎯, 💪). They are content markers, not interactive icons.

---

## 13. Motion

Use only the durations and easings exposed by `AppAnimation`:

| Helper | Curve | Use |
|---|---|---|
| `AppAnimation.quick` | `easeOut(duration: 0.18)` | Detail-tab flips (`SkillDetailView`, `ExerciseDetailView`) |
| `AppAnimation.standard` | `easeInOut(duration: 0.28)` | FAQ accordion (`HelpFAQView`), rest-timer ring (`RestTimerSettingsView`) |

Add new durations to `AppAnimation` rather than ad-hoc `.animation(.easeInOut(duration: ...))` calls.

See `Docs/Design/animations.md` for required and prohibited motions.

---

## 14. Elevation & Shadows

The system avoids drop shadows. Cards rely on border + surface tone for elevation. The only allowed shadows are the soft brand-blue glow under sticky `PrimaryButton`s and the standard tab-bar lift provided by SwiftUI's `TabView`.

---

## 15. Imagery & Backgrounds

- Backgrounds are flat near-black with `GradientCard` heroes as the only color surfaces.
- Exercise demo placeholder lives in `ExerciseVideoSection` — a styled 16:9 surface inside a card, with a centered white play button and an accent radial glow.
- Real media (exercise demos, progress photos) lives inside a card with the standard border treatment.

---

## 16. Logo Usage

- The full COBRA / STHENICS wordmark is reserved for the splash screen and `SubscriptionView` hero.
- All other surfaces use the cobra-head icon lockup.

---

## 17. Touch & Press

Touch-first product. Hover is not a primary affordance. Avoid hover lightening, hover darkening, or opacity changes.

---

## 18. Transparency & Blur

- Sticky CTA bars get a vertical gradient fade `transparent → AppColor.background`.
- Accent fills always use opacity tinting (14% / 18% / 30%–35%).
- No frosted glass or backdrop blur.

---

## 19. Ship Checklist

- Background is `AppColor.background`, not pure black.
- Every standard card has the 1pt `AppColor.border` border.
- Every number is in a monospaced font.
- Stats lead the label (big number first, UPPERCASE caption underneath).
- Only `AppColor.brand` is used for interactive accents.
- Difficulty pills use `AppColor.difficulty(_:)`.
- All copy is Title Case headings, sentence case body, UPPERCASE only on labels & pills.
- Real exercise names — no lorem, no "Workout 1".
- Bottom nav has exactly 5 tabs in the correct order.
- All spacing snaps to `AppSpacing.*`.
- No emoji outside §5.
- No drop shadows except the optional `PrimaryButton` glow.
- No backdrop blur.
- No light mode.
