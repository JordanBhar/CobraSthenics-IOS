# Feature Completion

Use this prompt to finish a feature that is scaffolded but not production-ready. Many CobraSthenics features are currently `UI` or `PARTIAL` in `AI/context/feature_matrix.md` — this prompt walks them to `DONE`.

---

## Required reading

1. `Docs/Engineering/source_of_truth.md`
2. `AI/context/feature_matrix.md` — find the feature row(s); confirm current status
3. `AI/context/project_status.md` — what's wired vs. stubbed
4. `Docs/Product/product_spec.md` — feature definition (F-xx + S-xx IDs)
5. `Docs/Features/<area>.md` — feature-specific expectations
6. `Docs/Architecture/architecture.md` — layer rules
7. `Docs/Architecture/database.md` — Firestore schema + sync rules

## Completion gap analysis

For the feature under work, list:

- Current status from `feature_matrix.md` (UI / PARTIAL / DONE)
- What renders today (driven by sample data?)
- What's missing to reach DONE:
  - [ ] Real data flow (Firestore reads / writes)
  - [ ] Local persistence (SwiftData write path)
  - [ ] Sync queue integration
  - [ ] Premium gating (if applicable)
  - [ ] Error states wired
  - [ ] Empty states implemented
  - [ ] Loading skeletons in place
  - [ ] VoiceOver labels
  - [ ] Dynamic Type validation (AX1+)
  - [ ] Tests (ViewModel + mapping + repository)
  - [ ] Analytics events (if defined for this feature)
  - [ ] Notification trigger (if applicable)

## Write-path completion (for features that log data)

If the feature writes data (workout completion, set log, skill session, body weight, photo upload):

- [ ] Local-first write to SwiftData
- [ ] Sync state set to `.pendingCreate` / `.pendingUpdate`
- [ ] UI updates immediately from local state — never wait for network
- [ ] Sync queue enqueues the upload
- [ ] On reconnect: queue retries until success or moves to `.failed`
- [ ] Server-owned aggregates (PRs, muscle group volume) are read-only from the client
- [ ] Cloud Function handles the post-write aggregation (see `database.md` §3 "Read and Write Strategy")
- [ ] Deletions soft-delete with `isDeleted: true`, then sync queue propagates

## Read-path completion (for features that display data)

- [ ] Repository method returns a domain entity (never a DTO)
- [ ] Loading state shown with skeleton preserving final dimensions
- [ ] Empty state suggests a concrete real action (e.g., "Log your first Tuck Front Lever hold")
- [ ] Failure state shows a typed message via the view model
- [ ] If the data is offline-cacheable: read from SwiftData first, refresh from Firestore in the background
- [ ] Realtime updates use `AsyncSequence` from the repository — not `addSnapshotListener` exposed to view models

## Premium gating completion

If the feature is Premium per `product_spec.md` §3 + §3.10:

- [ ] Entitlement read from a server-written field — never trusted from local state alone
- [ ] Gate shown inline (lock state) or via paywall sheet, not as a hard block
- [ ] Free version of the feature (if defined) remains fully functional
- [ ] Copy explains what's locked and how to unlock

## Visual completion

- [ ] Cards use the standard recipe (`#111111` + `#242424` border + 16px radius + 16px padding)
- [ ] Hero cards use `GradientCard` + radial glow recipe — no flat solid heroes
- [ ] All numerical values in DM Mono
- [ ] Spacing snaps to `AppSpacing`
- [ ] Difficulty pills follow the strict mapping
- [ ] Brand blue is the only interactive accent
- [ ] No emoji outside §5 inventory; no lorem; Alex Carter + real exercise names

## Test completion

Minimum bar:

- [ ] One ViewModel test per state transition (idle → loading → loaded; loading → failed)
- [ ] Mapping tests if mapping was added
- [ ] Repository tests against fake local + remote data sources
- [ ] If write path: one sync test (offline write → reconnect → upload succeeds)

## Done definition

A feature is DONE when:

- [ ] Real data flow end-to-end (Firestore + SwiftData + sync queue)
- [ ] All required screens render, including loading / empty / failed states
- [ ] Premium gates enforced (if applicable)
- [ ] Tests cover the happy path + at least one failure path
- [ ] `feature_matrix.md` row updated to DONE
- [ ] `project_status.md` updated if the completion closes a tracked gap
- [ ] `known_issues.md` updated if the feature resolved or revealed issues
- [ ] No SDK leaks into Presentation or Models
- [ ] No view performs I/O directly
