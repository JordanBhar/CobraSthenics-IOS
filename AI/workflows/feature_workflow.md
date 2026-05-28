# Feature Workflow

End-to-end engineering workflow for shipping a feature in CobraSthenics, from PRD line item to merged code. Designed for MCP-assisted development inside Xcode.

---

## Step 1 — Frame the feature

**Input:** a feature ID (F-xx) and / or screen ID (S-xx) from `Docs/Product/product_spec.md`, or a written request from product.

**Do:**

1. Open `Docs/Product/product_spec.md` and find the feature row.
2. Open `AI/context/feature_matrix.md` and find the current status (TODO / UI / PARTIAL / DONE).
3. If the feature is `UI` or `PARTIAL`, use `AI/prompts/feature_completion.md`. Otherwise, use `AI/prompts/new_feature.md`.
4. Open the matching `Docs/Features/<area>.md` for any feature-specific behavior or copy expectations.

**Output:** a one-paragraph framing in the PR description listing the F-xx and S-xx IDs being addressed.

## Step 2 — Plan the architecture

**Do:**

1. Identify which layers the feature touches: Domain (new entities?), Data (new repository methods?), Presentation (new views / view models?).
2. Identify Firestore collections + paths from `Docs/Architecture/database.md` §5.
3. Identify the sync flow (offline-first writes if applicable) from `database.md` §7.
4. Identify Premium gating rules from `product_spec.md` §3 + §3.10.
5. Identify reusable design-system primitives needed from `Docs/Design/design_system.md` and the inventory in `DesignSystem/Components/`.
6. Decide whether to introduce use cases (see `AI/context/technical_decisions.md` — currently optional but encouraged for new write paths).

**Output:** a short plan in your scratchpad or PR description listing the new types, new repository methods, new SwiftData models, and any divergences from current patterns.

## Step 3 — Build bottom-up

**Order:**

1. **Domain models** — add entities and value objects in `Models/`.
2. **Repository protocol** — extend the appropriate protocol in `Data/Repositories/`.
3. **Sample data** — populate realistic data in `SampleDataRepository.swift` (Alex Carter + real exercise names).
4. **Firebase stub** — keep `FirebaseAppRepository` building by adding `notImplemented` overrides, or implement the real method if this PR wires backend.
5. **SwiftData model** (if writes) — define or extend the `@Model` class in `Data/Persistence/`.
6. **Mapper** (if DTOs are introduced) — add the explicit conversion in `Data/Mappers/`.
7. **Use case** (if introducing the use-cases pattern) — `Sendable`, `callAsFunction`.
8. **View model** — `@MainActor`, exposes state machine + intents.
9. **View** — uses design system primitives; small, value-typed.
10. **Wire into `AppShell` / parent navigation** with typed routes.

**Validation between steps:**

- After every Swift file change, run `XcodeRefreshCodeIssuesInFile` on the file.
- After Step 4–7, build the project with `BuildProject`.

## Step 4 — Add tests

For each layer touched:

- Domain: pure XCTest with fakes.
- Mapping: `ModelMappingTests` extension covering happy + missing-optional + unknown-enum-fallback cases.
- Repository: `RepositoryTests` extension against fake local + remote data sources.
- ViewModel: `@MainActor` XCTest covering state transitions and at least one failure path.
- Sync (if applicable): offline write → reconnect → upload behavior.

## Step 5 — Validate manually

- Render the screen in `#Preview` for default, empty, loading, and failure states.
- If the change is UI-heavy: run the app and exercise the flow on the canvas / simulator.
- Walk the checklist in `AI/prompts/new_feature.md` or `AI/prompts/feature_completion.md`.
- Re-check `Docs/Design/ui_rules.md` §19 quick checklist before shipping any screen.

## Step 6 — Update tracking docs

Mandatory before opening the PR:

- [ ] Update `AI/context/feature_matrix.md` row for the F-xx / S-xx IDs touched.
- [ ] Update `AI/context/project_status.md` if a system was newly wired (Firebase, SwiftData, sync queue, paywall, etc.).
- [ ] Update `AI/context/known_issues.md` if any tracked issue was resolved or surfaced.
- [ ] Update `AI/context/technical_decisions.md` if an architectural divergence was closed (or a new one introduced — flag it for review).

## Step 7 — Open the PR

Follow `Docs/Engineering/git_workflow.md`:

- Branch: `feature/<short-name>`.
- PR body includes: what / why / screenshots / tests / known follow-ups.
- Use `AI/prompts/code_review.md` as a self-review checklist before requesting review.

## Step 8 — Post-merge

- [ ] Confirm the feature appears in the running app.
- [ ] If the feature is gated by Remote Config or a flag, confirm the flag value is set in the relevant environment.
- [ ] If the feature emits analytics events: confirm events fire in the analytics dashboard (when Firebase Analytics is wired).
