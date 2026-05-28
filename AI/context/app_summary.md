# App Summary

## What CobraSthenics Is

CobraSthenics is a native SwiftUI iOS app for calisthenics and gymnastic-rings athletes. It unifies workout tracking, skill progression, training programs, body metrics, progress photos, and analytics into a single dark-only, premium training experience backed by Firebase and offline-first local persistence.

## Source of Truth

- `Docs/Engineering/source_of_truth.md` — authoritative hierarchy and AI usage rules
- `Docs/Product/product_spec.md` — full PRD (v3.0.0, 2026-05-24)
- `Docs/Architecture/architecture.md` — Clean Architecture + feature-first organization
- `Docs/Design/ui_rules.md` — hard visual rules (dark-only, 5 tabs, brand-blue accent)

## Platform & Stack

- Native iOS, minimum deployment iOS 16 (architecture references iOS 17+ APIs for SwiftData and Observation)
- SwiftUI presentation with typed `NavigationStack` routes
- Observation framework for view models (currently `ObservableObject` + `@Published` — see `project_status.md`)
- Firebase backend: Auth, Firestore, Storage, FCM, Remote Config, Crashlytics, Analytics
- Local persistence: SwiftData preferred (CoreData allowed for advanced needs)
- Subscriptions: RevenueCat or StoreKit 2

## Target Personas

- **Aspiring Calisthenics Athlete** — wants clear skill progression paths
- **Freestyle Street Workout Enthusiast** — trains outdoors, needs minimal-equipment programs
- **Fitness Beginner** — guided beginner programs, visual progress
- **Advanced Practitioner** — chasing planche / front lever, needs detailed analytics

## Top-Level Feature Areas

| Tab | Purpose |
|---|---|
| Home | Dashboard: today's session, active program, streak, weekly heatmap, top muscles |
| Train | Active workout execution, set logging, rest timer, program day |
| Library | 400+ calisthenics exercise database + program browser |
| Skills | Skill tree, timed-hold sessions, hold-time trends, milestones |
| Profile | Athlete identity, analytics surfaces, settings, subscription, account |

## Monetization

- **Free tier:** core logging, 400+ exercises, 3 programs, 10 photos, basic charts
- **Premium Monthly:** $9.99/mo — full unlock
- **Premium Annual:** $59.99/yr ($5.00/mo) — best value badge
- 7-day free trial; entitlement validated server-side via RevenueCat → Cloud Function → Firestore

## Brand Voice

Terse, athletic, second-person. Calm and technical — closer to a financial-trading terminal than a gamified fitness app. Reference persona for all sample data: **Alex Carter** (@alexcarter, Level 12 "Bar Warrior", 47 workouts, 14-day streak, 3 active skills: Front Lever, Handstand, L-Sit).
