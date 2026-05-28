# Testing Workflow

Workflow for adding and maintaining tests in CobraSthenics. Aligned with `Docs/Engineering/testing_strategy.md` and `Docs/Architecture/architecture.md` §11.

---

## Test targets

Current targets in the project:

- `CobraSthenicsTests/` — unit tests (XCTest), runs the model + repository tests
- (Future) UI tests target — XCUITest for high-value flows once the active workout, skill session, and subscription flows exist

## Test types and where they live

| Test type | Tool | Location | Use case |
|---|---|---|---|
| Domain unit | XCTest | `CobraSthenicsTests/ModelMappingTests.swift` and new files per feature | Pure logic, mapping, calculations |
| Repository | XCTest async | `CobraSthenicsTests/RepositoryTests.swift` and new files | Repository protocol behavior against fakes |
| ViewModel | XCTest `@MainActor` | `CobraSthenicsTests/<Feature>ViewModelTests.swift` | State transitions and user intents |
| Sync | XCTest async | `CobraSthenicsTests/SyncTests.swift` (future) | Offline write → reconnect → upload, retry, conflict |
| Snapshot | TBD tooling | `CobraSthenicsTests/Snapshots/` (future) | Critical screens + design-system primitives |
| UI flow | XCUITest | UI test target (future) | Onboarding, log set, log skill session, subscription restore, account deletion |
| Firebase rules | Firebase emulator (future) | `firebase-tests/` (future) | Firestore + Storage rule coverage |

## Step 1 — Decide what to test

Per `testing_strategy.md`, focus on:

- Domain calculations (XP math, progress percentages, difficulty mapping)
- Model mapping (Codable decoding, fallback for unknown enum values)
- Repository behavior with fake local + remote data sources
- Critical user flows (onboarding, workout log, skill log, subscription)
- ViewModel state transitions for write paths

Avoid:

- Tests that exercise SwiftUI view layout without snapshot infrastructure
- Tests that hit real Firebase (use emulator or fakes)
- Tests of trivial getter / setter behavior

## Step 2 — Build the fake

Each test starts with a fake. Patterns to follow:

### Fake repository

```swift
final class FakeSkillRepository: SkillRepository {
    var loggedSessions: [SkillLog] = []
    var stubbedLogs: [SkillLog] = []
    var stubbedError: Error?

    func logSession(_ log: SkillLog) async throws {
        if let stubbedError { throw stubbedError }
        loggedSessions.append(log)
    }

    func logs(for skillId: String) async throws -> [SkillLog] {
        if let stubbedError { throw stubbedError }
        return stubbedLogs.filter { $0.skillId == skillId }
    }
}
```

### Fake local + remote data sources (for repository tests)

Keep local and remote distinct. Test offline-first behavior by writing to local + asserting remote was queued, not awaited.

### Test fixtures

Per `testing_strategy.md`:

- Use real exercise names (Tuck Front Lever, L-Sit, Ring Muscle-Up).
- Use **Alex Carter** for profile fixtures.
- Include edge cases for missing remote fields and empty histories.

## Step 3 — Write the test

Follow this skeleton:

```swift
import XCTest
@testable import CobraSthenics

final class HomeViewModelTests: XCTestCase {
    @MainActor
    func test_load_setsLoadedStateWithSnapshot() async throws {
        let repository = SampleDataRepository()
        let viewModel = HomeViewModel(repository: repository)

        await viewModel.load()

        XCTAssertNotNil(viewModel.snapshot)
        XCTAssertFalse(viewModel.isLoading)
    }

    @MainActor
    func test_load_setsErrorOnFailure() async throws {
        let repository = FakeAppRepository(error: TestError.simulated)
        let viewModel = HomeViewModel(repository: repository)

        await viewModel.load()

        XCTAssertNil(viewModel.snapshot)
        XCTAssertFalse(viewModel.isLoading)
        // Assert error state exposed by the view model
    }
}
```

## Step 4 — Run

Use MCP tools:

- `RunSomeTests` for fast feedback during development on the file under test
- `RunAllTests` before opening a PR
- `GetTestList` to enumerate available tests
- `XcodeRefreshCodeIssuesInFile` to check the test file compiles before running

## Step 5 — Coverage goals (current vs. target)

| Area | Current | Target |
|---|---|---|
| Model mapping | ~80% | 90% |
| Sample repository | ~60% | 80% |
| ViewModel state | 0% | 70% on critical write paths |
| Sync | n/a (not implemented) | 80% once implemented |
| UI flows | 0% | 5 critical XCUITest journeys |
| Snapshot | 0% | All design system primitives + 6 critical screens |

## Step 6 — When tests must be added

Mandatory test updates:

- Any change to domain logic (use cases, calculations, mappings)
- Any change to repository behavior
- Any change to view model state transitions
- Any new public API surface in `Models/` or `Data/Repositories/`
- Any sync behavior change

Optional but encouraged:

- New design system primitives — preview-only is acceptable until snapshot tooling exists
- New views — manual canvas verification + screenshot in PR is acceptable until snapshot tooling exists

## Step 7 — Validation before shipping

Per `testing_strategy.md`:

1. Run relevant unit tests with `RunSomeTests`.
2. Build the project with `BuildProject`.
3. For UI changes, inspect the affected screen or `#Preview`.
4. Check `Docs/Design/ui_rules.md` before accepting visual changes.
5. For data changes, run `RunSomeTests` on `ModelMappingTests` and `RepositoryTests`.

## Anti-patterns to avoid

- Tests that depend on time without injecting a `DateProviding` fake
- Tests that depend on a real network call
- Tests that depend on the Firebase emulator running externally without documenting it
- Tests that assert on view hierarchy without snapshot tooling
- Tests that share mutable state across cases (use fresh fakes per test)
- `XCTAssertNoThrow` swallowing failures — assert the success value explicitly
