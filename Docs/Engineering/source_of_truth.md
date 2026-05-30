# CobraSthenics — Source of Truth

**Status:** Authoritative engineering and AI context
**Scope:** Entire CobraSthenics project
**Platform:** Native iOS · SwiftUI · Observation framework · Swift Concurrency
**Last reviewed:** 2026-05-28

This document is the central reference for engineering and AI-assisted work on CobraSthenics. Use it to decide which docs to load first, how to resolve conflicts, and which standards govern generated code.

---

## Project Overview

CobraSthenics is a native SwiftUI iOS app for calisthenics and gymnastic-rings athletes. The current implementation renders five tabs (Home · Train · Library · Skills · Profile) backed by in-memory sample repositories. Backend integration (Firebase, SwiftData, networking) is scaffolded under `Core/` but not yet wired.

Project-wide decisions in force today:

- Native iOS only — no cross-platform layer.
- SwiftUI presentation with `NavigationStack` per tab.
- Clean Architecture per feature: `Presentation ─▶ Domain ◀─ Data`.
- ViewModel → Repository protocol (no Use Case layer at present).
- Observation framework + `@MainActor` for view models.
- Dark mode only via `.preferredColorScheme(.dark)` in `CobraSthenicsApp`.
- Composition via `AppEnvironment` (only `.preview` exists today).
- Design system at `Shared/DesignSystem/` is the only source of styling.

---

## Authoritative Documents

Load these first for AI-assisted development:

| Priority | File | Authority |
|---|---|---|
| 1 | `Docs/Engineering/source_of_truth.md` | Doc hierarchy, AI usage rules, project-wide precedence. |
| 2 | `Docs/Product/product_spec.md` | Product scope, users, features, flows, screens. |
| 3 | `Docs/Architecture/architecture.md` | Actual app layout, App layer, feature shape, navigation, DI, ADRs. |
| 4 | `Docs/Engineering/coding_guidelines.md` | Enforced rules for views, view models, layers, concurrency, data modeling. |
| 5 | `Docs/Architecture/database.md` | Current persistence types + planned target schema. |

Supporting authority:

- `Docs/Architecture/backend_architecture.md` — repository boundary and planned production adapter shape.
- `Docs/Design/ui_rules.md`, `design_system.md`, `animations.md`, `branding.md` — design system.
- `Docs/Engineering/swift_style_guide.md`, `testing_strategy.md`, `git_workflow.md`.
- `Docs/Features/*.md` — per-feature behaviour and data needs.

When documents conflict, the priority order above wins. When code conflicts with docs, prefer the docs only after confirming the current implementation shape and preserving existing working behaviour unless a migration is explicitly requested.

---

## Architecture Standards

Authoritative:

- `Docs/Architecture/architecture.md`
- `Docs/Architecture/backend_architecture.md`
- `Docs/Architecture/database.md`
- `Docs/Engineering/coding_guidelines.md`

Required rules:

- Domain holds entities + repository protocols. SwiftUI is imported only where entities expose `Color` projections.
- Presentation renders state and sends intents to view models; view models call repositories.
- Data implements repository protocols. Today all implementations are `Sample*Repository`.
- Firebase, SwiftData, URLSession, RevenueCat, StoreKit types must not leak into Domain or Presentation.
- Feature code is organized by product area with `Domain/Data/Presentation` subfolders.

---

## Design System Standards

Authoritative:

- `Docs/Design/ui_rules.md`
- `Docs/Design/design_system.md`
- `Docs/Design/animations.md`
- `Docs/Design/branding.md`

Hard visual rules (encoded in code):

- Dark mode only (`CobraSthenicsApp` forces `.dark`).
- Page background is `AppColor.background` (`#080808`).
- Every standard card uses `AppCard` (`AppColor.card` fill + 1pt `AppColor.border`).
- `AppColor.brand` (`#0A84FF`) is the only interactive accent.
- All numbers use a monospaced font (`Font.appMono`, `Font.appMonoLarge`).
- Bottom nav has exactly five tabs in this fixed order: Home, Train, Library, Skills, Profile.
- Spacing uses `AppSpacing` (4 · 8 · 12 · 16 · 20 · 24 · 32).
- No backdrop blur, no decorative shadows, no light mode.

Feature UI must use `Shared/DesignSystem` primitives (`AppCard`, `GradientCard`, `PrimaryButton`, `OutlineButton`, `AccentPill`, `FilterChips`, `SearchField`, `SectionHeader`, `AppHeader`, `RingProgress`, `TierDots`, `AppProgressBar`, etc.) before inventing new styling.

---

## Coding Standards

Authoritative:

- `Docs/Engineering/coding_guidelines.md`
- `Docs/Engineering/swift_style_guide.md`
- `Docs/Engineering/testing_strategy.md`
- `Docs/Engineering/git_workflow.md`

Required rules:

- `PascalCase` for types, `camelCase` for properties/methods/enum cases.
- Prefer `let` and explicit types.
- Avoid force unwraps.
- Use `async`/`await`; do not use Combine.
- View models are `@Observable @MainActor final class`.
- Keep persistence and network work out of views.

---

## State Management

- Observation framework is the default.
- View models expose `var` state and `async` intent methods.
- Each tab root holds its view model with `@State private var viewModel: <T>` and triggers `viewModel.load()` from `.task { … }`.
- `load()` short-circuits when data is already present (one-shot loading).
- View-local state (search text, selected detail tab, expansion flags) stays on the view as `@State`.

---

## Database & Backend Standards

Today's implementation is sample-only. The intended shape (when adapters land):

- Cloud Firestore for shared backend data.
- Firebase Auth, Storage, Cloud Functions, Remote Config for supporting services.
- SwiftData for local persistence; `LocalExerciseCache`, `LocalSkillLog`, `LocalWorkoutSession` already define the shape.
- Workout and skill writes are local-first with `pendingSync` queued for background upload.
- DTOs use `Codable`. Domain entities are not DTOs.
- Server-owned aggregates and subscription entitlement state are not trusted from client state alone.

---

## Component Library Standards

- Use shared primitives before building new UI.
- Promote a component to the design system only when it appears in two or more features or encodes a product invariant.
- Keep one-off composition inside feature folders (`SkillCard`, `BackChromeButton`, `FlowLayout`, `FieldCard`).
- Difficulty pills must call `AppColor.difficulty(_:)`.
- Numeric values must use a monospaced font.

---

## AI / MCP Agent Usage

When working in Xcode or via MCP tools:

1. Read this file first.
2. Load only the relevant authoritative docs for the task.
3. Inspect existing code before changing implementation.
4. Use Xcode MCP tools (`XcodeRead`, `XcodeGrep`, `XcodeWrite`, `BuildProject`, `XcodeRefreshCodeIssuesInFile`) for navigation, edits, and diagnostics.
5. Use `DocumentationSearch` for any modern SwiftUI / SwiftData / Observation / StoreKit / FoundationModels questions.
6. Preserve the current SwiftUI architecture unless the task explicitly asks for migration.
7. Keep changes scoped to the requested feature, bug, or doc area.
8. Run targeted diagnostics or unit tests when code changes are made.
9. Build the project before shipping non-trivial code changes.
10. For doc-only changes, skip builds.

AI agents must never introduce Flutter, Android, Riverpod, GoRouter, Isar, Dart, or cross-platform architecture into this project.

---

## Documentation Hierarchy

Precedence order for conflict resolution:

1. `Docs/Engineering/source_of_truth.md`
2. `Docs/Product/product_spec.md`
3. `Docs/Architecture/architecture.md`
4. `Docs/Engineering/coding_guidelines.md`
5. `Docs/Architecture/database.md`
6. `Docs/Architecture/backend_architecture.md`
7. `Docs/Design/ui_rules.md`
8. `Docs/Design/design_system.md`
9. `Docs/Design/animations.md`
10. `Docs/Design/branding.md`
11. `Docs/Engineering/swift_style_guide.md`
12. `Docs/Engineering/testing_strategy.md`
13. `Docs/Engineering/git_workflow.md`
14. `Docs/Features/*.md`

If two authoritative docs conflict, prefer the more specific document for its domain. Architecture rules in `architecture.md` override feature-level implementation suggestions.

---

## Rules For Generated Code

Generated code must:

- Preserve the native SwiftUI architecture and Clean Architecture per feature.
- Keep Domain pure (no SDK types, no DTOs).
- Use repository protocols held as `any <Protocol>` and injected via initializer.
- Wire dependencies through `AppEnvironment` and the SwiftUI environment.
- Use `@Observable @MainActor final class` view models.
- Use `async`/`await` and typed failures (when adapters land).
- Use `Shared/DesignSystem` tokens and components for every UI decision.
- Never create a light mode.
- Never change the tab count, order, or labels in `AppShell` and `NavigationTabConstants`.
- Never use raw Firebase types in views or domain entities.
- Never place persistence queries in SwiftUI views.
- Never add lorem ipsum or `Workout 1` / `Exercise 1` placeholders.
- Add or update tests when changing domain logic, mapping, repository behaviour, or view-model state transitions.

---

## Known Placeholders

These files exist but are intentionally empty today:

- `App/AppRouter.swift`
- `App/AppCoordinator.swift`
- `App/DependancyContainer.swift` (note misspelling)
- `Shared/DesignSystem/Icons/AppIcons.swift`

They are reserved for future centralised navigation, a coordinator pattern, a generated DI container, and a curated icon set respectively. Do not delete them; do not assume their absence means a system is missing.
