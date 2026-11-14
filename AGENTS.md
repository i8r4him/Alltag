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
- **"The test runner crashed before establishing connection"** means the simulator holds data from a *newer* schema version (you tested a branch with a new `AlltagSchemaV<n>`, then switched back). The app can't open a newer store and crashes at launch. Uninstall the app from that simulator (`xcrun simctl uninstall <udid> i8r4him.Alltag`) and run again. The same happens on the maintainer's iPhone: delete the app there.
- **CI runs on the maintainer's Mac**, on the same simulators. A local test run at the same time can make CI fail with "Simulator device failed to launch". Re-run the failed job (`gh run rerun <id> --failed`); don't change code for it.
- **A warning to ignore:** `RealtimeConversationTests.swift: main actor-isolated static property 'dentist'` is old. Any other new warning must be fixed.
- **Lint limits that bite:** a file may have 500 lines (`ConversationModel.swift` is at the limit: put new code in an extension file like `ConversationModel+History.swift`), a line 140 characters, a function body 60 lines.
- **The simulator can't do the real thing:** it has no microphone behind speech recognition, no Apple Intelligence and no live voice. `AppServices.live()` swaps in simulated services there. Anything that listens, records, checks with the on-device model or talks must be tried on the maintainer's iPhone; say so under "Not verified" in the PR.

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
- Translate streams OpenAI's answer section by section. The Translate screen does not substitute Apple's translation when cloud use is unavailable.
- **Text:** all UI text goes in `Alltag/Resources/Localizable.xcstrings`. German content and other non-localised strings use `Text(verbatim:)`, so they don't create catalog keys. Don't build `Text` with `+`; it's deprecated.
- **Tests:** Swift Testing (`import Testing`, `@Test`, `#expect`).
  - Tests never touch the network, microphone or speaker; inject stubs.
  - Tests that need real hardware or services are opt-in through an environment variable, like `ALLTAG_LIVE_MODEL` in `AlltagTests/CompanionTests.swift`.
- **Which model:** use the cheapest that is good enough, in this order: on device → Apple's cloud model (`PrivateCloudLanguageModelClient`, Private Cloud Compute; free for the app, the learner has a daily quota from Apple) → OpenAI through the server. The mistake check follows this order in `CloudCompanionService`; new text features should too. **Apple's cloud model is switched off** (`PrivateCloudLanguageModelClient.isEntitled = false`) until Apple has assigned the entitlement to the maintainer's account, which needs the App Store Small Business Program; without the entitlement a request stops the app. The doc comment on `isEntitled` says how to switch it on. Then `TEST_RUNNER_ALLTAG_PCC=1` runs `AppleCloudModelTests`, which reports the cloud model's answers to German test sentences.
- **Secrets never go in the repo or the app bundle.** The OpenAI API key lives only in Supabase secrets (see `supabase/README.md`). The Supabase URL and publishable key are public and may be in the app.

## Data (SwiftData, iCloud-ready)

iCloud sync (SwiftData + CloudKit, #54) is switched on at the end of `3 · Memory`. Every model must already follow CloudKit's rules, so switching it on changes no model:

- Every stored property is **optional or has a default value** (`var name: String = ""`).
- **No `@Attribute(.unique)` and no `#Unique`.** Duplicates are repaired instead (see `AlltagStore.repairDuplicateIDs`).
- Every **relationship is optional**.
- `SwiftDataTests.modelsAreCloudKitReady` checks all of this; keep it passing.
- **A model change means a new schema version.** Add `AlltagSchemaV<n+1>` and a migration stage in `AlltagStore.swift`; never edit an old version. Add a test that opens a store from the previous version.
  - The schema is at **V4**. Each version so far *added a model* (V2 `PracticeSession`, V3 `CustomSituation`, V4 `SessionRecord`). Prefer adding a model to changing one: all versions list the same model classes, so changing a class changes every version that lists it.
- Store enums as their raw value (`kindRaw`) with a computed property, so predicates can filter on them.

## Design language

- **The look comes from Today** (`Features/Home/`): the `.skyBackground()`, Liquid Glass (`glassEffect`, `.glass` / `.glassProminent` buttons), `.fontDesign(.rounded)`, and `ScenarioArtwork` for illustrations.
- **Cards:** Today's and the profile's cards are clear Liquid Glass (`.glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))`). Learn still uses the dark Focus surface (`.learnSurface()`: dark with a faint white stroke) until they're moved over.
- **The big button** is `.buttonStyle(.primary)` (`DesignSystem/Components/Buttons.swift`): the glass capsule with the theme's two lights, as on "Start talking". Every large call to action uses it; don't style a big button by hand. `.primaryCompact` is the small filled capsule inside cards.
- **Everything follows the theme colour** (`AppTheme.shared.palette`, `.accent`, `.accentFill`). No fixed colours except meaning (coral for mistakes).
- **Choosing a design:** when a screen's design is open, build two to four options on the branch behind a temporary "‹ n / N ›" glass switcher. The maintainer picks one, and the others and the switcher are removed before the PR is merged.
- **Touch feedback:** a tap that opens or starts something answers with a **medium** haptic (`.sensoryFeedback(.impact(weight: .medium), …)`), not a light one. A sheet opened from a button or card **zooms out of it** (`.matchedTransitionSource` on the source, `.navigationTransition(.zoom)` on the sheet). Articles has both; the rest of the app follows.
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
   - **The server is live, not a test copy.** After an approved change under `supabase/`, the function has to be deployed and the migration applied to the project (`flbymqlcauvwumznvviq`), with JWT verification on; committing the files alone changes nothing. Use the Supabase CLI or connector if you have access, otherwise ask the maintainer to deploy. Then call the function once for real and read its logs (they arrive a few minutes late).
   - Check OpenAI's current docs before writing against their API; model names and request formats change.
7. **One folder.** Work in the main checkout (`~/Developer/Alltag`) and switch branches there; no git worktrees or second copies. The maintainer runs the app from that folder in Xcode.
8. **The maintainer's uncommitted changes are theirs.** Never stash, discard, reformat or commit them. Stage your own files by path (never `git add -A`), and before switching branches check that the branches don't differ in those files.

## Plan to launch

- **Deadline: v1 is submitted to the App Store by 30 Nov 2026.** v1 is free; Pro comes after launch.
- **Milestones**, one tab per week: `1 · Today` (16 Nov), `2 · Learn` (22 Nov), `3 · Memory` (25 Nov, ends with iCloud sync), `4 · Testing` (27 Nov), `5 · Launch` (30 Nov). `After launch` is the backlog.
- **Issues:** each milestone has a few **main features**, each split into **sub-issues** (GitHub sub-issues). One branch and PR per sub-issue.
- **Labels:** `must-have` (the tab isn't done without it) and `nice-to-have` (if there's time; otherwise it moves to `After launch`).
- **Real or hidden:** at the end of each week, anything on that tab that doesn't work for real is hidden (App Review guideline 2.1). No mock content ships.
- Outdated issues are **closed as "not planned"**, never deleted.

## Current state (15 Nov 2026)

Rewrite this section when it goes stale; it is a snapshot, not a rule.

**Today is done** except for three things that wait on the maintainer:
- **#212** The live voice stops hearing after three or four turns. Needs the Xcode console lines filtered by `Realtime` from the maintainer's iPhone.
- **#185** A new title for "From your day", and **#194** what the two rows under the 60 seconds become: the maintainer's decisions.
- **#171** Save the transcript and the mistakes: done by session history, except "new words reach Memory". Ask whether to close it or move it to the Memory week.

**TestFlight:** the `asc` CLI on the maintainer's Mac is signed in with an API key and can upload and manage builds, but Alltag has no App Store Connect record yet; creating it needs the maintainer's Apple ID (`asc web apps create` or the website). Archive from a clean `main`, not a branch with uncommitted work.

**Learn is the focus now** (`2 · Learn`, due 22 Nov). The idea that ties it together: everything the learner does in Learn feeds one loop. What they get wrong is saved to Fix your mistakes and comes back until they know it; every session is kept in Your sessions.

Done on Learn: "How do I say …?", Translate with OpenAI (streamed), Alltag as the default translation app (extension `AlltagTranslation/`), Fix your mistakes with the learner's own mistakes, Your sessions.

The Learn features, **in this order**:
1. **#252** Articles: **done** (#292, #294). A round of der, die, das, "Look up a word" with a history, and the clues as tiles. Its parts set the standard the other Learn screens follow (state cards, bookmark that saves and unsaves, medium haptics, zoom into sheets).
1a. **#295** Translate in the Articles standard, put before Write by the maintainer: **#296** the screen (pair card with the welcome in its lower half, the big button above the keyboard, placeholders while loading, detail cards with symbols, a history; in its PR) and then **#297** the panel in other apps in the same look (needs the iPhone).
2. **#263** Write: a short task, corrected sentence by sentence. A shell today.
3. **#269** Read: real-life texts, tap a word, check understanding. A shell today.
4. **#275** Grammar: rules for every level, linked from the learner's mistakes. Works with 6 rules today.
5. **#280** Listen: short spoken texts with questions, and dictation. A shell today. The one to hide and move to After launch if the week runs short.
6. **#285** Polish: every state, light mode, one pass on the iPhone.

**Open decisions (maintainer)**, with the agent's recommendation in each issue: written content, generated content or both (#264, #270); which voice for Listen (#280); Scan a letter in v1 or later (#274).

**Apple's cloud model (#259)** is in the code and switched off. The maintainer has enrolled in the App Store Small Business Program and waits for Apple to assign the entitlement. See `PrivateCloudLanguageModelClient.isEntitled` for how to switch it on.

**Never tried on a real device:** the situation role-plays, the 60-second recording and "Listen to yourself", the thinking-time values (merged untested), the translation panel in other apps, "How do I say …?" with a real answer.

**Not planned yet:** `3 · Memory` and `4 · Testing` have no issues (except #258, light mode). The old issues in `5 · Launch` (#51, #118, #161, #162, #163) are not sorted.

**Decisions the maintainer has made**
- Text features use `gpt-6-luna` (their choice, for cost). `CHECK_MODEL` and `TRANSLATE_MODEL` in Supabase's secrets switch it without a new build.
- One OpenAI key for everything, restricted to the permissions it needs.
- Today's Focus is the situation of the day.
- Sessions are kept until the learner deletes them. Only 60 seconds is recorded.
- Own situations are a short form, not an AI-written scenario.
- Calendar suggestions (#183) are not built for now.
- The four skills stay visible while they are shells; they are built in the order above.

**Two agents share this folder** (this one and Codex). Check `git status` and the current branch before you start, never switch branches under someone else's uncommitted work, and stage your own files by path.

## Project map (short)

- `AlltagTranslation/`: ExtensionKit Translation UI Provider (#245–247), with cloud consent, streamed translation and optional replacement. Host and extension use `group.i8r4him.Alltag` for a file inbox; the app imports saved entries into its existing SwiftData store on activation. Do not move the database into the App Group or modify its schema for this handoff. Paid-team signing and a physical-device check are required for both targets.

- `Alltag/App/`: entry point, `AppState`, `AppServices`, routing.
- `Alltag/Features/<Screen>/`: views and their `@Observable` models.
- `Alltag/Services/<Area>/`: service protocols, mocks and live implementations.
- `Alltag/DesignSystem/`: tokens and shared components. Use them rather than raw values.
- `Alltag/Intents/`: App Intents (Siri, Shortcuts, Spotlight).
- `supabase/`: the Edge Functions (`realtime-session` for the voice, `check-german` for the mistake check, `translate` for translating) and migrations, owned by the maintainer. See `supabase/README.md`.
