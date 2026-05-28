# Roadmap

This roadmap derives from `Docs/Product/product_spec.md` (v3.0.0) and the current implementation state in `project_status.md`. Sequencing reflects engineering dependencies, not strict calendar dates.

## v0.x — Prototype Hardening (current phase)

Goal: turn the high-fidelity prototype into a real, persistable training experience using sample data plus real local writes.

- [ ] Migrate view models from `ObservableObject` to `@Observable`
- [ ] Stand up a `PersistenceController` and wire SwiftData into the app
- [ ] Implement Active Workout (S-10): exercise list, set rows, rest timer, completion summary
- [ ] Implement Timed-Hold Skill Session (S-20): countdown, start/stop, per-set log, summary
- [ ] Introduce use cases: `LogSetUseCase`, `CompleteWorkoutUseCase`, `LogSkillSessionUseCase`
- [ ] Add ViewModel tests for both write paths
- [ ] Introduce `AppFailure` + `ErrorMapper` (per architecture.md §10)

## v1.0 — Launch Candidate

### v1.0a — Backend Foundation

- [ ] Add Firebase iOS SDKs (Auth, Firestore, Storage, Crashlytics, Analytics, FCM, Remote Config)
- [ ] Firebase Auth: Apple Sign-In, Google, Email/Password
- [ ] Onboarding wizard (F-03 – F-05): goal, level, equipment, biometrics, skill assessment, availability, units
- [ ] User profile read/write to `users/{uid}`
- [ ] Exercise database read from `exercises/` with local cache via `LocalExerciseCache`
- [ ] Sync queue: SwiftData write → Firestore upsert with retry
- [ ] Cloud Function: `onWorkoutComplete` → personal records + muscle group aggregates
- [ ] Cloud Function: `onSkillLogSave` → skill personal record updates

### v1.0b — Programs, Photos, Notifications

- [ ] Program browser (S-22) + program detail (S-23) reading from `globalPrograms/`
- [ ] Active program enrollment + day-tile scheduler
- [ ] Progress photos: PhotosUI capture, Firebase Storage upload, gallery, comparison
- [ ] FCM integration + notification preference center (S-44 → wired)
- [ ] Body weight log + measurement log + history charts

### v1.0c — Subscription System

- [ ] RevenueCat or StoreKit 2 integration
- [ ] Paywall (S-46) with feature comparison + trial CTA
- [ ] Subscription management screen (S-45)
- [ ] Cloud Function: `onSubscriptionChange` webhook handler → entitlement sync
- [ ] Premium feature gates enforced across the app (per `feature_matrix.md`)

## v1.1 — Polish + Expansion

- [ ] HealthKit integration: read body weight, write workout sessions
- [ ] Custom program builder (Premium, F-38)
- [ ] Multiple daily difficulty levels (Light / Standard / Intense, F-42)
- [ ] Side-by-side photo comparison with swipe overlay (F-53)
- [ ] Localizations: Spanish, German, French, Portuguese-BR
- [ ] Snapshot tests for critical screens

## v1.2 — Advanced Analytics & AI

- [ ] Premium analytics surfaces (Volume, Skill, Body Composition — S-35 – S-37)
- [ ] AI-generated coaching cues (out of scope for v1.0)
- [ ] Skill tree browser (F-27, S-17) with full progression graph

## v2.0 — Coach & Community (out of v1 scope)

- [ ] Coach / trainer portal
- [ ] Program template sharing (Premium, F-40)
- [ ] Wearable device sync

## Long-Term

- [ ] Right-to-left layout support
- [ ] Apple Watch companion
- [ ] iPad-optimized layouts
