# AGENTS.md — working on Alltag

Alltag is an iOS German-learning companion (SwiftUI, SwiftData, iOS 27+, iPhone and foldable iPhone only).
`README.md` is the design spec and architecture guide; read the parts that touch your task before you start.

## Build, lint, test

```sh
swiftlint lint --strict --quiet            # must be clean
scripts/sync_string_catalog.sh             # after any change to user-facing text
xcodebuild test -project Alltag.xcodeproj -scheme Alltag \
  -destination "platform=iOS Simulator,name=iPhone 18 Pro"
```

- CI (`.github/workflows/ci.yml`, self-hosted Mac) runs the same tests and checks that the String Catalogs are in sync. SwiftLint runs in `lint.yml`.
- The build must have **no new warnings**.
- If the test run fails with "Failed to create a bundle instance", the simulator hiccuped (it happens after adding a test file). Run it again.

## Code rules

- **Every new Swift file** starts with this header, with the file and target names filled in:
  ```swift
  //
  //  FileName.swift
  //  Alltag            (or AlltagTests)
  //
  //  Created by Ibrahim Abdullah on 07.11.26.
  //
  ```
- **Native SwiftUI and Apple frameworks only.** Use `.toolbar`/`ToolbarItem`, `Form`/`List`, system pickers and sheets, not hand-made look-alikes.
- **No third-party libraries in the app.** Talk to web services with `URLSession` and `URLSessionWebSocketTask`.
- **Style:** `@Observable` models, services injected through `AppServices` in the environment. Screens only talk to service **protocols** (`SpeechService`, `VoiceService`, `CompanionService`, …). A new live implementation goes behind the existing protocol, and the mock stays for previews and tests.
- The default actor isolation is `MainActor`. Audio callbacks and other off-main work need explicitly `nonisolated` / `@Sendable` code.
- **British English** in all UI text and comments ("practise", "colour").
- **Text:** all UI text goes in `Alltag/Resources/Localizable.xcstrings`. German content and other non-localised strings use `Text(verbatim:)`, so they don't create catalog keys. Don't build `Text` with `+`; it's deprecated.
- **Tests:** Swift Testing (`import Testing`, `@Test`, `#expect`).
  - Tests never touch the network, microphone or speaker; inject stubs.
  - Tests that need real hardware or services are opt-in through an environment variable, like `ALLTAG_LIVE_MODEL` in `AlltagTests/CompanionTests.swift`.
- **Secrets never go in the repo or the app bundle.** The OpenAI API key lives only in Supabase secrets (see `supabase/README.md`). The Supabase URL and publishable key are public and may be in the app.

## Data (SwiftData, iCloud-ready)

iCloud sync (SwiftData + CloudKit, #54) is switched on at the end of `3 · Memory`. Every model must already follow CloudKit's rules, so switching it on changes no model:

- Every stored property is **optional or has a default value** (`var name: String = ""`).
- **No `@Attribute(.unique)` and no `#Unique`.** Duplicates are repaired instead (see `AlltagStore.repairDuplicateIDs`).
- Every **relationship is optional**.
- `SwiftDataTests.modelsAreCloudKitReady` checks all of this; keep it passing.
- **A model change means a new schema version.** Add `AlltagSchemaV<n+1>` and a migration stage in `AlltagStore.swift`; never edit an old version. Add a test that opens a store from the previous version.
- Store enums as their raw value (`kindRaw`) with a computed property, so predicates can filter on them.

## Design language

- **The look comes from Today** (`Features/Home/`): the `.skyBackground()`, Liquid Glass (`glassEffect`, `.glass` / `.glassProminent` buttons), `.fontDesign(.rounded)`, and `ScenarioArtwork` for illustrations.
- **Cards:** Today's and the profile's cards are clear Liquid Glass (`.glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))`). Learn still uses the dark Focus surface (`.learnSurface()`: dark with a faint white stroke) until they're moved over.
- **The big button** is `.buttonStyle(.primary)` (`DesignSystem/Components/Buttons.swift`): the glass capsule with the theme's two lights, as on "Start talking". Every large call to action uses it; don't style a big button by hand. `.primaryCompact` is the small filled capsule inside cards.
- **Everything follows the theme colour** (`AppTheme.shared.palette`, `.accent`, `.accentFill`). No fixed colours except meaning (coral for mistakes).
- **Choosing a design:** when a screen's design is open, build two to four options on the branch behind a temporary "‹ n / N ›" glass switcher. The maintainer picks one, and the others and the switcher are removed before the PR is merged.
- **Smooth interaction:** state that drives one control (a popover, a toggle) lives in that control's own view, so changing it doesn't redraw the whole screen mid-animation (see `StreakButton`).

## Workflow

1. Work from a GitHub issue in `i8r4him/Alltag`. Use the branch name `feature/<issue#>-short-name`, branched from an up-to-date `main`.
2. Before committing:
   - SwiftLint is clean.
   - The String Catalogs are synced.
   - All tests pass.
   - `README.md` is updated where the architecture tree, the "Simulated vs real" list or the frameworks table changed.
   - **`AGENTS.md` is updated in the same PR** whenever a rule, a convention or the plan changes, so it never falls behind.
3. **Commit messages:**
   - A plain subject plus a short body ending with `Closes #<issue>`.
   - **No `Co-Authored-By`, no tool or agent attribution, no "Generated with …" lines** in commits or PRs.
4. **Open a PR** with `gh pr create`:
   - Use the issue's labels and milestone.
   - Include a short "what and why" body.
   - Note anything you couldn't verify, for example "needs a real device".
5. **Don't merge until the maintainer says so.** Then squash-merge with the subject `PR title (#<PR>)`, move the issue to Done on the board, update `main` and delete the branch.
6. **Ask before** changing the project's targets, adding capabilities or entitlements, or changing anything under `supabase/`.
7. **One folder.** Work in the main checkout (`~/Developer/Alltag`) and switch branches there; no git worktrees or second copies. The maintainer runs the app from that folder in Xcode.
8. **The maintainer's uncommitted changes are theirs.** Never stash, discard, reformat or commit them. Stage your own files by path (never `git add -A`), and before switching branches check that the branches don't differ in those files.

## Plan to launch

- **Deadline: v1 is submitted to the App Store by 30 Nov 2026.** v1 is free; Pro comes after launch.
- **Milestones**, one tab per week: `1 · Today` (16 Nov), `2 · Learn` (22 Nov), `3 · Memory` (25 Nov, ends with iCloud sync), `4 · Testing` (27 Nov), `5 · Launch` (30 Nov). `After launch` is the backlog.
- **Issues:** each milestone has a few **main features**, each split into **sub-issues** (GitHub sub-issues). One branch and PR per sub-issue.
- **Labels:** `must-have` (the tab isn't done without it) and `nice-to-have` (if there's time; otherwise it moves to `After launch`).
- **Real or hidden:** at the end of each week, anything on that tab that doesn't work for real is hidden (App Review guideline 2.1). No mock content ships.
- Outdated issues are **closed as "not planned"**, never deleted.

## Project map (short)

- `Alltag/App/`: entry point, `AppState`, `AppServices`, routing.
- `Alltag/Features/<Screen>/`: views and their `@Observable` models.
- `Alltag/Services/<Area>/`: service protocols, mocks and live implementations.
- `Alltag/DesignSystem/`: tokens and shared components. Use them rather than raw values.
- `Alltag/Intents/`: App Intents (Siri, Shortcuts, Spotlight).
- `supabase/`: the Edge Function and migrations, owned by the maintainer.
