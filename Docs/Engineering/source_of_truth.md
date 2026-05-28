# CobraSthenics — Source of Truth

**Status:** Authoritative AI context  
**Scope:** Entire CobraSthenics project  
**Platform:** Native iOS, SwiftUI, Xcode, Firebase, SwiftData/CoreData  
**Last reviewed:** 2026-05-24

This document is the central engineering and AI-assistance reference for CobraSthenics. AI agents must use it to decide which project documents to read first, how to resolve conflicts between documents, and which standards govern generated code.

---

## Project Overview

CobraSthenics is a native SwiftUI iOS application for calisthenics and gymnastic-rings athletes. It combines workout tracking, skill progression, training programs, body metrics, analytics, progress photos, notifications, and subscriptions.

The app is built around these project-wide decisions:

- Native iOS first; no Flutter or cross-platform architecture.
- SwiftUI presentation with typed `NavigationStack` routes.
- Clean Architecture with dependencies pointing inward: `Presentation -> Domain <- Data`.
- Feature-first organization with Domain, Data, and Presentation boundaries inside major product areas.
- Firebase-backed remote data with offline-first local persistence.
- SwiftData preferred for local storage; CoreData allowed when migrations, batch operations, or fetch behavior require it.
- Observation framework by default for view models and app state.
- Dark-only premium visual system defined by the design docs.

---

## Engineering Source Of Truth Files

The following files are authoritative and should be loaded first for AI-assisted development:

| Priority | File | Authority |
|---|---|---|
| 1 | `Docs/Engineering/source_of_truth.md` | Documentation hierarchy, AI usage rules, and project-wide precedence. |
| 2 | `Docs/Product/product_spec.md` | Product scope, users, features, flows, screens, and business requirements. |
| 3 | `Docs/Architecture/architecture.md` | Native iOS architecture, Clean Architecture boundaries, layer rules, state, navigation, and dependency graph. |
| 4 | `Docs/Engineering/coding_guidelines.md` | Enforced SwiftUI, dependency, state, data, concurrency, networking, and testing rules. |
| 5 | `Docs/Architecture/database.md` | Firestore schema, local persistence, sync, security, indexing, and migration standards. |

When these files conflict with secondary docs, these files win. When code conflicts with docs, prefer the docs only after confirming the current implementation shape and preserving existing working behavior unless a migration is explicitly requested.

---

## Architecture Standards

Authoritative files:

- `Docs/Architecture/architecture.md`
- `Docs/Architecture/backend_architecture.md`
- `Docs/Architecture/database.md`
- `Docs/Engineering/coding_guidelines.md`

Required architecture rules:

- Domain contains pure business logic: entities, value objects, use cases, repository protocols, and domain failures.
- Domain must not import SwiftUI, Firebase, SwiftData, CoreData, RevenueCat, StoreKit, URLSession, or SDK implementation types.
- Presentation renders state and sends user intents to view models.
- View models call use cases.
- Use cases call repository protocols.
- Data implements repositories and owns I/O, DTOs, mappers, SDK integration, persistence records, sync queues, and error mapping.
- Firebase and SwiftData/CoreData types must not leak into Domain or Presentation.
- Feature code should be organized around product areas while preserving layer boundaries.

---

## Design System Standards

Authoritative files:

- `Docs/Design/ui_rules.md`
- `Docs/Design/design_system.md`
- `Docs/Design/animations.md`
- `Docs/Design/branding.md`

Hard visual rules:

- Dark mode only.
- Page background is `#080808`.
- Every card uses `#111111` fill and a 1px `#242424` border.
- Brand blue `#0A84FF` is the only interactive accent.
- Every numerical value uses DM Mono.
- Bottom navigation is exactly five tabs in this order: Home, Train, Library, Skills, Profile.
- Use the strict 8pt spacing grid.
- No backdrop blur, frosted glass, decorative shadows, lorem ipsum, or unapproved emoji.

Design components and feature UI must use existing design-system primitives before inventing new styling.

---

## Coding Standards

Authoritative files:

- `Docs/Engineering/coding_guidelines.md`
- `Docs/Engineering/swift_style_guide.md`
- `Docs/Engineering/testing_strategy.md`
- `Docs/Engineering/git_workflow.md`

Required coding rules:

- Use `PascalCase` for types and `camelCase` for properties, methods, enum cases, and local values.
- Prefer explicit domain types, enums, protocols, and small functions.
- Avoid force unwraps.
- Prefer `let` unless mutation is required.
- Use `async` / `await` and Swift Concurrency by default.
- Use `AsyncSequence` for streaming auth, sync, or listener updates.
- Use Combine only when integrating with APIs that already expose publishers or when it materially simplifies a reactive pipeline.
- Keep views declarative and small.
- Keep business decisions out of SwiftUI views.
- Keep persistence and network work out of views.

---

## Feature Documentation

Authoritative product file:

- `Docs/Product/product_spec.md`

Feature-specific support files:

- `Docs/Features/workouts.md`
- `Docs/Features/skills.md`
- `Docs/Features/analytics.md`
- `Docs/Features/subscriptions.md`

Feature docs should be used after the product spec. They clarify feature-specific expectations but must not override architecture, database, coding, or design rules.

Current feature areas:

- Home and dashboard summaries.
- Train and workout execution.
- Library for exercises and programs.
- Skills for progression tracking and skill sessions.
- Profile for athlete identity, settings, account, and analytics surfaces.
- Subscription flows and entitlement-gated features.

---

## AI Workflow Prompts

Current AI folder structure:

```text
AI/
  prompts/
  workflows/
  context/
```

At the time of this document, these folders exist but contain no prompt or workflow files. They are reserved for reusable AI development materials.

Expected usage:

- `AI/prompts/` should contain reusable prompts for common coding, review, migration, and documentation tasks.
- `AI/workflows/` should contain multi-step procedures for MCP-assisted development, test validation, release checks, and documentation audits.
- `AI/context/` should contain compact AI-readable summaries or context packs derived from the authoritative docs.

AI agents must not treat missing AI prompt files as permission to invent project standards. Use `Docs/Engineering/source_of_truth.md` and the authoritative docs above until dedicated AI workflow files exist.

---

## SwiftUI Standards

Authoritative files:

- `Docs/Architecture/architecture.md`
- `Docs/Engineering/coding_guidelines.md`
- `Docs/Engineering/swift_style_guide.md`

SwiftUI rules:

- Views are value types that render state and send intents.
- Use `NavigationStack` and typed route values for navigation.
- UI-facing view models use the Observation framework by default.
- Mark UI-facing view models `@MainActor`.
- Use `@State private var` for local view state and owned observable view models.
- Keep async loading and persistence outside pure visual components.
- Support Dynamic Type and VoiceOver labels for training controls.
- Use design-system tokens and components for visual styling.

---

## State Management Standards

Authoritative files:

- `Docs/Architecture/architecture.md`
- `Docs/Engineering/coding_guidelines.md`

State rules:

- Observation is the default state-management approach.
- View models expose view-ready state and user intent methods.
- View models call use cases, not Firebase, SwiftData, or Firestore directly.
- TCA is allowed only for features with complex reducer-driven state transitions, heavy effect orchestration, or strict testability needs beyond Observation plus use cases.
- Loading, empty, loaded, failed, saving, and sync states should be explicit when relevant.
- Active workout and skill logging must update local state immediately and sync remotely in the background.

---

## Database & Backend Standards

Authoritative files:

- `Docs/Architecture/database.md`
- `Docs/Architecture/backend_architecture.md`
- `Docs/Engineering/coding_guidelines.md`

Database and backend rules:

- Cloud Firestore is the shared backend database.
- Firebase Storage stores progress photos, avatars, thumbnails, and exercise media.
- Firebase Auth handles email, Google, and Apple-backed authentication.
- Firebase Cloud Functions handle privileged operations, server-owned aggregates, account deletion, entitlement sync, and thumbnails.
- Firebase Remote Config handles feature flags and exercise schema versioning.
- SwiftData is the preferred local persistence layer; CoreData is allowed for advanced persistence needs.
- Workout and skill writes are local-first and queued for Firestore sync.
- Firestore DTOs use `Codable`.
- DTOs and SwiftData/CoreData records map explicitly to pure domain entities.
- Firestore document snapshots, timestamps, storage references, and SDK errors stay in Data.
- Server-owned aggregates and subscription security state are not trusted from local client state alone.

---

## Component Library Standards

Authoritative files:

- `Docs/Design/design_system.md`
- `Docs/Design/ui_rules.md`
- `Docs/Design/animations.md`

Component rules:

- Use shared primitives before building new UI.
- Promote a component to the design system when it appears in multiple features or encodes a product invariant.
- Keep feature-specific composition inside feature folders.
- Cards, pills, stat blocks, progress bars, buttons, section headers, and bottom-tab items must follow the design docs.
- Numeric components must use DM Mono.
- Difficulty pills must use the fixed mapping: beginner green, intermediate orange, advanced red, elite purple.
- Components must not introduce one-off palettes, shadows, blur, or spacing values outside the approved grid.

---

## MCP / AI Agent Usage Instructions

When working inside Xcode or with MCP tools:

1. Read this file first.
2. Load only the relevant authoritative docs for the task.
3. Inspect existing code before changing implementation.
4. Prefer Xcode MCP tools for project navigation, file reads, edits, diagnostics, previews, tests, and builds.
5. Use Apple documentation search for modern SwiftUI, SwiftData, Observation, StoreKit, PhotosUI, or other Apple framework questions.
6. Preserve current working SwiftUI architecture unless the task explicitly asks for migration.
7. Keep changes scoped to the requested feature, bug, or documentation area.
8. Run targeted diagnostics or tests when code changes are made.
9. Build the project before shipping implementation changes when feasible.
10. For documentation-only changes, verify the intended files exist and avoid unnecessary builds.

AI agents must never introduce Flutter, Android, Riverpod, GoRouter, Isar, Dart, or cross-platform architecture into this project.

---

## Documentation Hierarchy

Use this precedence order when resolving conflicts:

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
15. `AI/prompts`, `AI/workflows`, and `AI/context` when populated

If two authoritative docs conflict, prefer the more specific document for its domain. For example, database schema details in `database.md` override broad product descriptions, while dependency-direction rules in `architecture.md` override feature-level implementation suggestions.

---

## Rules For Future Generated Code

Generated code must follow these rules:

- Preserve native SwiftUI architecture.
- Preserve Clean Architecture dependency direction.
- Keep Domain pure and SDK-free.
- Use use cases between view models and repositories.
- Keep Firebase, SwiftData/CoreData, RevenueCat, StoreKit, URLSession, DTOs, and mappers in Data or infrastructure layers.
- Prefer `@Observable` `@MainActor` view models for UI state.
- Prefer `async` / `await` and typed failures.
- Use `Codable` DTOs and explicit mapping.
- Keep workout and skill logging offline-first.
- Use `Docs/Design/ui_rules.md` for every UI decision.
- Never create a light mode.
- Never change the bottom-tab count, order, or labels.
- Never use raw Firebase types in views or domain entities.
- Never place persistence queries in SwiftUI views.
- Never add generic placeholder exercise names or lorem ipsum.
- Add or update tests when changing domain logic, mapping, repository behavior, sync behavior, or view-model state transitions.

---

## Authoritative Files Identified

Core authority:

- `Docs/Engineering/source_of_truth.md`
- `Docs/Product/product_spec.md`
- `Docs/Architecture/architecture.md`
- `Docs/Engineering/coding_guidelines.md`
- `Docs/Architecture/database.md`

Supporting authority:

- `Docs/Architecture/backend_architecture.md`
- `Docs/Design/ui_rules.md`
- `Docs/Design/design_system.md`
- `Docs/Design/animations.md`
- `Docs/Design/branding.md`
- `Docs/Engineering/swift_style_guide.md`
- `Docs/Engineering/testing_strategy.md`
- `Docs/Engineering/git_workflow.md`
- `Docs/Features/workouts.md`
- `Docs/Features/skills.md`
- `Docs/Features/analytics.md`
- `Docs/Features/subscriptions.md`

AI workspace, currently empty:

- `AI/prompts/`
- `AI/workflows/`
- `AI/context/`

---

## Missing Documentation To Create Next

Recommended next documentation files:

- `AI/context/project_context.md` — compact AI-readable summary of product, architecture, design, and data rules.
- `AI/workflows/code_change_workflow.md` — step-by-step MCP workflow for implementation tasks.
- `AI/workflows/docs_audit_workflow.md` — repeatable process for documentation consistency audits.
- `AI/prompts/code_review_prompt.md` — reusable review prompt aligned with architecture and UI rules.
- `Docs/Architecture/sync_strategy.md` — deeper offline queue, retry, conflict, and deletion behavior.
- `Docs/Architecture/security_rules.md` — Firestore and Storage rule expectations with examples.
- `Docs/Features/onboarding.md` — onboarding and profile setup flow.
- `Docs/Features/library.md` — exercise and program library behavior.
- `Docs/Features/profile.md` — profile, settings, progress photos, and account management.
