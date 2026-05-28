# Feature Matrix

Legend: **DONE** (production-ready in-app, sample data) · **UI** (screen scaffolded, no real data flow) · **PARTIAL** (some scaffolding) · **TODO** (not started) · **STUB** (file exists, no implementation)

## Bottom Navigation (5 tabs — locked order)

| Tab | Status | Notes |
|---|---|---|
| Home | UI | `HomeView` + `HomeViewModel` populated from `SampleDataRepository.homeSnapshot` |
| Train | UI | `TrainView` + `TrainViewModel` — active program hero, workout filtering by category |
| Library | UI | `LibraryView` → `CategoryView` → `ExerciseDetailView`; `ExerciseVideoSection` placeholder |
| Skills | UI | `SkillsView` with family filter; `SkillDetailView` stub |
| Profile | UI | `ProfileView` with quick stats, achievements, PRs, settings groups |

## Authentication & Onboarding (Spec §3.1, S-01 – S-06)

| Feature | ID | Status |
|---|---|---|
| Splash with animated logo | F-01, S-01 | TODO |
| Social sign-in (Google/Apple) + Email/Password | F-02, S-03/S-04 | TODO |
| Onboarding wizard (7 steps) | F-03 – F-05, S-06 | TODO |
| Profile avatar upload (Firebase Storage) | F-06 | TODO |
| Account settings | F-07 | UI — `AccountSettingsViews` scaffolded |
| Privacy / data export / account deletion | F-08, S-47 | TODO |

## Workout Tracking (Spec §3.2, S-09 – S-16)

| Feature | ID | Status |
|---|---|---|
| Workout tab home | S-09 | UI — `TrainView` |
| Active workout screen | F-09 – F-14, S-10 | TODO |
| Exercise search + filter | F-10, S-11 | PARTIAL — search/filter UI on Library; no add-to-workout flow |
| Set logging (reps / timed / AMRAP / weighted / assisted) | F-11 | TODO |
| Previous performance inline | F-12 | TODO |
| Rest timer | F-13, S-16 | UI — `RestTimerView` settings only |
| Workout notes (session + exercise) | F-14 | TODO |
| Superset / circuit grouping (Premium) | F-15 | TODO |
| RPE per set (Premium) | F-16 | TODO |
| Workout summary | F-17, S-13 | TODO |
| Workout history list | F-18, S-14 | PARTIAL — sample workouts on `TrainView` |
| Edit completed workout (24h window) | F-19, S-15 | TODO |

## Exercise Library (Spec §3.3, S-11/S-12)

| Feature | ID | Status |
|---|---|---|
| 400+ exercise database | F-20 | PARTIAL — sample data only |
| Exercise detail page | F-21, S-12 | UI — `ExerciseDetailView` |
| Skill progression chain on exercise | F-22 | PARTIAL — `ProgressionChain` model exists |
| Filter by muscle/equipment/category/difficulty | F-23 | UI — `FilterChips` component in use |
| Custom exercise creation | F-24 | TODO |
| Video demonstrations (Premium) | F-25 | UI — `ExerciseVideoSection` placeholder |
| Personal records per exercise | F-26 | PARTIAL — sample PRs on Profile |

## Skill Progression (Spec §3.4, S-17 – S-21)

| Feature | ID | Status |
|---|---|---|
| Skill tree browser | F-27, S-17 | TODO |
| Individual skill profiles | F-28 | UI — `SkillsView` lists skills with tier progress |
| Skill goal setting / prerequisite mapping | F-29 | TODO |
| Timed hold session mode | F-30, S-20 | TODO |
| Hold time trend chart per skill | F-31 | TODO |
| Skill unlock milestones | F-32, S-21 | TODO |
| Skill analytics board (Premium) | F-33 | TODO |

## Training Programs (Spec §3.5, S-22 – S-25)

| Feature | ID | Status |
|---|---|---|
| Program browser | F-34, S-22 | TODO |
| Program detail | F-35, S-23 | TODO |
| Enroll + active program dashboard | F-36, S-24 | UI — active program hero on Home/Train |
| Program scheduler | F-37 | TODO |
| Custom program builder (Premium) | F-38, S-25 | TODO |
| Program adherence tracking | F-39 | PARTIAL — `ActiveProgram.adherencePercent` modeled |
| Program duplication + sharing (Premium) | F-40 | TODO |
| Deload week configuration (Premium) | F-41 | TODO |
| Multiple daily difficulty levels | F-42 | TODO |

## Body Metrics (Spec §3.6, S-26 – S-29)

| Feature | ID | Status |
|---|---|---|
| Body weight log + trend | F-43 | TODO |
| Measurement log | F-44 | TODO |
| Body fat % (manual / Navy method) | F-45 | TODO |
| FFMI auto-calculation | F-46 | TODO |
| Metric history charts | F-47, S-29 | TODO |
| Goal body weight marker (Premium) | F-48 | TODO |
| Unit switching (kg ↔ lb, cm ↔ in) | F-49 | TODO |

## Progress Photos (Spec §3.7, S-30 – S-33)

| Feature | ID | Status |
|---|---|---|
| Photo capture / import with pose tag | F-50 | TODO |
| Firebase Storage upload | F-51 | TODO |
| Timeline gallery | F-52, S-30 | TODO |
| Side-by-side comparison | F-53, S-33 | TODO |
| Body weight metadata overlay | F-54 | TODO |
| Free 10-photo cap | F-55 | TODO |
| Export collage (Premium) | F-56 | TODO |

## Analytics Dashboard (Spec §3.8, S-34 – S-40)

| Feature | ID | Status |
|---|---|---|
| Home widgets (today, streak, heatmap, top muscles) | F-57 | UI — populated from sample data |
| Weekly summary | F-58, S-08 | PARTIAL — `ProfileSnapshot.weeklyVolume` modeled |
| Strength + volume analytics (Premium) | F-59, S-35 | TODO |
| Skill analytics (Premium) | F-60, S-36 | TODO |
| Body composition chart (Premium) | F-61, S-37 | TODO |
| Consistency heatmap (52-week) | F-62, S-38 | PARTIAL — `HeatmapGrid` component built |
| Personal records board | F-63, S-39 | UI — PRs section on Profile |
| Streak tracking | F-64 | UI — sample streak on Home |
| Top muscles chart | F-65, S-40 | PARTIAL — `MiniBarChart` + `MuscleStat` modeled |
| Top exercises chart | F-66 | TODO |

## Notifications (Spec §3.9)

| Feature | ID | Status |
|---|---|---|
| FCM integration | F-67 | TODO |
| Workout reminder | F-68 | TODO |
| Rest timer notification | F-69 | TODO |
| Program adherence nudge | F-70 | TODO |
| Weekly progress summary push | F-71 | TODO |
| PR / skill milestone celebration | F-72 | TODO |
| Notification preference center | F-73, S-44 | UI — `NotificationsView` settings scaffold |

## Subscription (Spec §3.10)

| Feature | ID | Status |
|---|---|---|
| Free tier feature surface | F-74 | UI — feature gates not enforced |
| Premium pricing (monthly/annual + trial) | F-75 | TODO |
| RevenueCat / StoreKit 2 integration | F-76 | TODO |
| Paywall screen | F-77, S-46 | TODO |
| Subscription management | F-78, S-45 | UI — `SubscriptionView` scaffold |
| Grace period handling | F-79 | TODO |
| Promotional offer codes | F-80 | TODO |

## Design System

| Component | Status |
|---|---|
| `PrimaryButton`, `OutlineButton` | DONE |
| `AppCard`, `GradientCard` | DONE |
| `AppProgressBar`, `RingProgress`, `TierDots` | DONE |
| `AppHeader`, `SectionHeader` | DONE |
| `SearchField`, `FilterChips`, `AppToggle` | DONE |
| `AccentPill` | DONE |
| `SettingsList`, `SheetHandle` | DONE |
| `MiniBarChart`, `HeatmapGrid` | DONE |
| `AppLayout`, `AppNavigationModifiers`, `AppAnimation` | DONE |
| Theme (colors), Typography | DONE |

## Infrastructure

| System | Status |
|---|---|
| Firebase Auth | TODO (`FirebaseAppRepository` stubbed) |
| Firestore | TODO |
| Firebase Storage | TODO |
| Firebase Cloud Messaging | TODO |
| Firebase Cloud Functions | TODO |
| Firebase Remote Config | TODO |
| Firebase Crashlytics + Analytics | TODO |
| SwiftData wiring | TODO (`LocalWorkoutSession`, `LocalSkillLog`, `LocalExerciseCache` exist; not connected) |
| Sync queue / offline-first writes | TODO |
| Use cases layer | TODO (architecture-prescribed; not present) |
| DTOs + mappers | STUB (protocols only) |
