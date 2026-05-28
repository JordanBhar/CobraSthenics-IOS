# Technical Decisions

This file records the technical decisions that shape CobraSthenics. Source-of-truth decisions live in `Docs/Engineering/source_of_truth.md` and `Docs/Architecture/architecture.md`; this file tracks current-state interpretations and any deliberate divergences.

## Locked Decisions (from authoritative docs)

| Decision | Source | Rationale |
|---|---|---|
| Native iOS only — no Flutter, Android, or cross-platform | `source_of_truth.md`, `architecture.md` §1 | Premium iOS experience; first-class Apple platform features |
| SwiftUI for presentation | `architecture.md` §6 | Modern declarative UI, Observation integration |
| Clean Architecture: Presentation → Domain ← Data | `architecture.md` §2 | Testable domain logic free of SDK leakage |
| Feature-first module organization | `architecture.md` §2 | Cohesion inside product areas |
| Observation framework by default for view models | `architecture.md` ADR-001 | Lightweight, native, avoids unnecessary deps |
| SwiftData preferred for local persistence | `architecture.md` ADR-002, `database.md` §1 | Swift-native, model observation; CoreData allowed only when SwiftData is insufficient |
| `Codable` DTOs + explicit mappers | `architecture.md` ADR-003 | Domain stays serialization-free |
| Cloud Firestore as shared backend | `database.md` §1 | Schema flexibility + offline cache |
| Firebase Auth (Apple, Google, Email/Password) | `product_spec.md` §3.1 | App Store policy + breadth of providers |
| Firebase Storage for photos, avatars, exercise media | `architecture.md` §9 | Tight Firebase integration; signed URL support |
| RevenueCat or StoreKit 2 for subscriptions | `product_spec.md` §7.1 | Server-side entitlement verification |
| Bottom navigation = 5 tabs (Home, Train, Library, Skills, Profile) — locked order | `ui_rules.md` §1, §11 | Visual and behavioral invariant |
| Dark-only theme; page bg `#080808`, card `#111111`, card border `#242424` | `ui_rules.md` §1, §2.1 | Brand consistency |
| Brand blue `#0A84FF` is the only interactive accent | `ui_rules.md` §1, §2.2 | Visual hierarchy; never a purple/green/gold CTA |
| Difficulty pill colors: BEGINNER green, INTERMEDIATE orange, ADVANCED red, ELITE purple | `ui_rules.md` §2.3 | Fixed across the app; never recolor by context |
| Every numerical value uses DM Mono | `ui_rules.md` §1, §3.1 | Stats lead the eye, mono carries them |
| 8pt spacing grid: 4·8·12·16·20·24·32·40·48·64 | `ui_rules.md` §6.1 | No 10/15/18px gaps |
| Card invariant: `#111111` fill + 1px `#242424` border + 16px radius + 16px padding | `ui_rules.md` §8.1 | No borderless cards anywhere |
| Primary button: solid `#0A84FF`, 50px height, 15px radius, blue glow | `ui_rules.md` §10.1 | Single primary CTA recipe |
| One drop shadow in the system (bottom nav lift) + one colored glow (brand button) | `ui_rules.md` §14 | Cards use border/surface tone, not shadow |
| Motion: 160 / 240 / 360 ms; progress-bar exception 800 ms; no >500 ms otherwise | `ui_rules.md` §13, `animations.md` | Restrained, fast, functional |
| No backdrop blur / frosted glass | `ui_rules.md` §1, §18 | Dark surface stack does elevation |
| Real exercise names + Alex Carter persona for sample copy | `ui_rules.md` §4.3, `branding.md` | No lorem ipsum, ever |
| Workouts and skill logs are offline-first | `architecture.md` §8, `database.md` §7 | UI must not wait for network |
| Personal records are server-owned (Cloud Function writes) | `database.md` §8 | Client cannot be trusted as the security source |

## Current-State Divergences from Architecture Spec

These divergences are deliberate for the prototype phase. They are flagged here so future contributors and AI agents can plan migrations explicitly rather than assume the code mirrors the docs.

| Divergence | Current | Spec | Migration Plan |
|---|---|---|---|
| View model framework | `ObservableObject` + `@Published` | `@Observable` macro | Per-file migration; trivial mechanical change |
| Layer organization | Flat: `Features/<Name>/ViewModels` + `Features/<Name>/Views` + shared `Models/` | Per-feature `Domain/`, `Data/`, `Presentation/` subfolders | Defer until Firebase/SwiftData wiring forces module boundaries |
| Use cases | View models call repositories directly | Use case structs between view models and repositories | Introduce when the first write-path feature (active workout) ships |
| DTOs and mappers | Marker protocols only (`RemoteDTO`, `DomainMapper`) | Full per-collection DTOs with explicit mapping | Build alongside Firestore integration |
| Persistence | SwiftData `@Model` classes exist but unwired | Repositories use SwiftData via a persistence controller | Wire when active workout and skill session ship |
| Sync queue | Not present | Async queue with retry, conflict resolution, sync state | Build after SwiftData wiring; before Firestore is enabled |
| Domain failures | Untyped throws | `AppFailure` enum + `ErrorMapper` in data layer | Introduce with use cases |

## Repository Protocol Shape

Current protocol surface in `Data/Repositories/`:

- `UserRepository` — `getUserProfile`, `getHomeSnapshot`, `getProfileSnapshot`, `getSettingGroups`
- `WorkoutRepository` — `getActiveProgram`, `getWorkouts`
- `ExerciseRepository` — `getExerciseCategories`, `getExercises`, `getExercise`
- `SkillRepository` — `getSkills`, `getSkillHistory`
- `ProgramRepository` — `getFeaturedProgram`
- `AppRepository` — typealias intersection of the five above

This surface is read-oriented to serve the current prototype. Write-path methods (logging sets, completing workouts, logging skill sessions, enrolling in programs, uploading photos) need to be added when those features are implemented — and they must remain offline-first as per `architecture.md` §8.

## Composition Root

`App/AppEnvironment.swift` is the single composition root. It currently injects `SampleDataRepository`. A `FirebaseAppRepository` exists and conforms to `AppRepository` but throws `notImplemented` everywhere. Swapping data sources is a one-line change in `AppEnvironment.preview` or `AppEnvironment.live`.

## Things That Are Explicitly NOT Allowed

From `source_of_truth.md` "Rules For Future Generated Code":

- No light mode.
- No Flutter, Android, Riverpod, GoRouter, Isar, Dart, or cross-platform code.
- No changing the bottom-tab count, order, or labels.
- No raw Firebase types in views or domain entities.
- No persistence queries inside SwiftUI views.
- No `Workout 1` / `Exercise 1` / lorem ipsum placeholders.
- No frosted glass / backdrop blur anywhere.
- No third-party advertising SDKs.
- No 700-weight body paragraphs; no ALL CAPS body text.
