# Release Workflow

End-to-end workflow for cutting a release of CobraSthenics. Aligned with `Docs/Product/product_spec.md` §7.11 ("Deployment & Release") and `Docs/Engineering/git_workflow.md`.

---

## Release cadence

- **Bi-weekly sprints** for engineering work
- **Monthly public releases** to TestFlight → App Store
- **Version naming:** `MAJOR.MINOR.PATCH+BUILD` (e.g., `1.0.0+42`)

## Environments

| Environment | Purpose | Firebase project |
|---|---|---|
| `dev` | Local development with emulators or `SampleDataRepository` | Firebase emulators or none |
| `staging` | TestFlight internal builds, pre-prod validation | Separate Firebase project |
| `prod` | App Store releases | `cobrasthenics-prod` |

When Firebase is wired, each environment gets its own `GoogleService-Info.plist`.

---

## Step 1 — Cut a release candidate branch

```text
release/v<MAJOR.MINOR.PATCH>
```

From `main`, when the sprint scope is complete.

## Step 2 — Pre-flight checks

Run all of these before tagging:

- [ ] `BuildProject` succeeds in Release configuration
- [ ] `RunAllTests` passes
- [ ] `XcodeListNavigatorIssues` shows zero warnings on the project (or document accepted ones)
- [ ] `AI/context/feature_matrix.md` reflects the shipping feature state
- [ ] `AI/context/project_status.md` reflects current implementation
- [ ] `AI/context/known_issues.md` lists any known regressions or carry-over gaps
- [ ] `AI/context/roadmap.md` matches the released scope

## Step 3 — Design QA

Walk each touched screen against `Docs/Design/ui_rules.md` §19 quick checklist:

- [ ] Background `#080808` (not pure black)
- [ ] Every card has the `#242424` 1px border
- [ ] Every number in DM Mono
- [ ] Stats lead the label
- [ ] Only `#0A84FF` for interactive accents
- [ ] Difficulty pills follow the strict color mapping
- [ ] Title-case headings, sentence-case body, UPPERCASE only on labels & pills
- [ ] Real exercise names — no lorem
- [ ] Bottom nav: 5 tabs in correct order
- [ ] All spacing on the 8pt grid
- [ ] No emoji outside §5 inventory
- [ ] No drop-shadows except bottom-nav lift and brand-button glow
- [ ] No backdrop blur
- [ ] No light mode

## Step 4 — Accessibility QA

- [ ] VoiceOver labels on all interactive elements
- [ ] Tap targets ≥ 44×44pt
- [ ] Dynamic Type rendered correctly at default, accessibility 1 (AX1), and accessibility 3 (AX3)
- [ ] Color contrast ≥ 4.5:1 for body text
- [ ] Haptics fire on set completion, PR achievement, timer expiry, skill milestone unlock (when those flows ship)

## Step 5 — Subscription QA (when subscriptions ship)

- [ ] Free tier behaves correctly (3 programs, 10 photos, basic charts)
- [ ] Paywall shown contextually for Premium-only features
- [ ] Trial flow completes end-to-end in sandbox
- [ ] Restore Purchases succeeds for a returning subscriber
- [ ] Grace period handling for failed renewals (3-day window per `product_spec.md` §3.10)
- [ ] Entitlement read from server-written field, not local state

## Step 6 — Privacy & data QA

- [ ] Data export endpoint works (when implemented) — returns JSON zip
- [ ] Account deletion wipes all Firestore + Storage data for the UID
- [ ] No third-party advertising SDKs present
- [ ] Privacy policy + terms of service links present on registration

## Step 7 — Performance check

Targets from `product_spec.md` §7.5:

- [ ] Cold start (Release) < 2.5 s on iPhone 14
- [ ] Home dashboard load < 1.5 s
- [ ] Exercise search response < 500 ms (local cache)
- [ ] Set log write < 200 ms (SwiftData local)
- [ ] Skill hold timer ± 100 ms accuracy
- [ ] Photo upload < 5 s on LTE for a 3 MB image
- [ ] IPA size < 40 MB
- [ ] Active workout screen sustains 60 fps

Use Xcode Instruments + Firebase Performance once wired.

## Step 8 — Crashlytics / Analytics sanity (when Firebase is wired)

- [ ] Crashlytics initialized and reports a deliberate test crash from staging build
- [ ] Analytics events fire for: app open, workout completed, skill session completed, paywall view, subscription start
- [ ] Custom keys (userId, screen, action) attached to crash reports

## Step 9 — Tag and build for TestFlight

- [ ] Bump build number in the Xcode project
- [ ] Bump marketing version if MAJOR / MINOR changed
- [ ] Tag: `git tag v<MAJOR.MINOR.PATCH>+<BUILD>`
- [ ] Push tag
- [ ] Archive + upload to App Store Connect
- [ ] Distribute to TestFlight internal testers

## Step 10 — Internal regression pass

On TestFlight internal build, exercise these critical flows:

- [ ] App launches cold without crash
- [ ] Sign in (Apple, Google, Email/Password) — when implemented
- [ ] Onboarding completes — when implemented
- [ ] All 5 tabs render
- [ ] Active workout flow logs a set end-to-end — when implemented
- [ ] Skill session logs a hold end-to-end — when implemented
- [ ] Paywall renders + trial starts — when implemented
- [ ] Settings → notification preferences save
- [ ] Account deletion + data export — when implemented

## Step 11 — External TestFlight

- [ ] Distribute to external testers
- [ ] Monitor Crashlytics for 48h
- [ ] Triage and fix blockers as patch builds

## Step 12 — App Store submission

- [ ] Update App Store listing (screenshots, what's new, description)
- [ ] Submit for review
- [ ] Phased release recommended for first 7 days
- [ ] Monitor Crashlytics + reviews

## Step 13 — Post-release

- [ ] Tag `production-v<MAJOR.MINOR.PATCH>`
- [ ] Merge `release/<...>` back to `main`
- [ ] Update `AI/context/roadmap.md` — move shipped items to "Shipped" and lift next items into the active phase
- [ ] Update `AI/context/project_status.md` with new high-level state
- [ ] If any rollout flag exists in Remote Config: monitor the rollout dashboard for 7 days

## Hotfix workflow

For critical post-release bugs:

1. Branch from the production tag: `hotfix/<short-name>`
2. Apply the minimal fix
3. Run Steps 2–5 from this workflow (skipping unchanged areas)
4. Bump PATCH version
5. Tag, build, and submit as expedited review
6. Cherry-pick the fix into `main`

## Feature flags

Use Firebase Remote Config (per `product_spec.md` §7.11) to gate risky features. New features that flip behavior visibly should default to OFF on first release and enable gradually via Remote Config.
