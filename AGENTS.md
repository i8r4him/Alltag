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

- CI (`.github/workflows/ci.yml`, self-hosted Mac) runs the same tests and checks that the String Catalogs are in sync. SwiftLint runs in `lint.yml` on GitHub's Linux machines (SwiftLint 0.65.1 in a container), so it never slows the tests on the Mac.
- The build must have **no new warnings**.
- If the test run fails with "Failed to create a bundle instance", the simulator hiccuped (it happens after adding a test file). Run it again.
- **"The test runner crashed before establishing connection"** means the simulator holds data from a *newer* schema version (you tested a branch with a new `AlltagSchemaV<n>`, then switched back). The app can't open a newer store and crashes at launch. Uninstall the app from that simulator (`xcrun simctl uninstall <udid> i8r4him.Alltag`) and run again. The same happens on the maintainer's iPhone: delete the app there.
- **CI runs on the maintainer's Mac**, on its own simulator ("Alltag CI", made by the workflow) without clones. A local test run at the same time can still make CI fail with "Simulator device failed to launch". Re-run the failed job (`gh run rerun <id> --failed`); don't change code for it.
- **CI runs once per PR**, not again after the merge, and not at all when a PR only changes docs (`.md`, `screenshots/`, `.claude/`, `supabase/`). It keeps its build next to the checkout (`$RUNNER_WORKSPACE/DerivedData`), so a run only rebuilds what changed. If CI fails in a way a clean build would fix, run CI by hand on the Actions page with "clean build" ticked.
- **Tests must not depend on timing.** A test that races a real clock (words arriving every few hundred milliseconds, a sleep before a check) fails when the Mac is busy and costs a full CI re-run. Use a stub that waits for the step the test drives instead (see `FirstWordSpeech` in `ConversationModelTests`).
- **A warning to ignore:** `RealtimeConversationTests.swift: main actor-isolated static property 'dentist'` is old. Any other new warning must be fixed.
- **Lint limits that bite:** a file may have 500 lines (`ConversationModel.swift` is at the limit: put new code in an extension file like `ConversationModel+History.swift`), a line 140 characters, a function body 60 lines.
- **The simulator can't do the real thing:** it has no microphone behind speech recognition, no Apple Intelligence and no live voice. `AppServices.live()` swaps in simulated services there. Anything that listens, records, checks with the on-device model or talks must be tried on the maintainer's iPhone; say so under "Not verified" in the PR.
- **Checks on request** (Claude Code skills in `.claude/skills/`, loaded only when asked): `/alltag-performance` reviews one screen's speed, `/alltag-preflight` checks App Store rejection reasons, `/alltag-accessibility` checks one screen for VoiceOver, large text, contrast, touch and motion. They report; the maintainer measures and tries things on the iPhone.

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
  - Tests that need real hardware or services are opt-in through an environment variable, like `ALLTAG_LIVE_MODEL` in `AlltagTests/Services/CompanionTests.swift`.
  - A new test file goes in the `AlltagTests/` folder of the part of the app it tests (`Learn/Grammar/`, `Memory/`, …; see README's tree). The folder is synchronized in Xcode, so adding or moving a file there needs no project change.
- **Which model:** use the cheapest that is good enough, in this order: on device → Apple's cloud model (`PrivateCloudLanguageModelClient`, Private Cloud Compute; free for the app, the learner has a daily quota from Apple) → OpenAI through the server. The mistake check follows this order in `CloudCompanionService`; new text features should too. **Apple's cloud model is switched off** (`PrivateCloudLanguageModelClient.isEntitled = false`) until Apple has assigned the entitlement to the maintainer's account, which needs the App Store Small Business Program; without the entitlement a request stops the app. The doc comment on `isEntitled` says how to switch it on. Then `TEST_RUNNER_ALLTAG_PCC=1` runs `AppleCloudModelTests`, which reports the cloud model's answers to German test sentences.
- **Secrets never go in the repo or the app bundle.** The OpenAI API key lives only in Supabase secrets (see `supabase/README.md`). The Supabase URL and publishable key are public and may be in the app.

## Data (SwiftData, iCloud-ready)

iCloud sync (SwiftData + CloudKit, #54) is switched on in `v1` (decided 15 Nov; its fallback is to ship without sync if it isn't safe on two iPhones by the Testing week). Every model must already follow CloudKit's rules, so switching it on changes no model:

- Every stored property is **optional or has a default value** (`var name: String = ""`).
- **No `@Attribute(.unique)` and no `#Unique`.** Duplicates are repaired instead (see `AlltagStore.repairDuplicateIDs`).
- Every **relationship is optional**.
- `SwiftDataTests.modelsAreCloudKitReady` checks all of this; keep it passing.
- **A model change means a new schema version.** Add `AlltagSchemaV<n+1>` and a migration stage in `AlltagStore.swift`; never edit an old version. Add a test that opens a store from the previous version.
  - The schema is at **V4**. Each version so far *added a model* (V2 `PracticeSession`, V3 `CustomSituation`, V4 `SessionRecord`). Prefer adding a model to changing one: all versions list the same model classes, so changing a class changes every version that lists it.
- Store enums as their raw value (`kindRaw`) with a computed property, so predicates can filter on them.

## Design language

- **The look comes from Today** (`Features/Home/`): the `.skyBackground()`, Liquid Glass (`glassEffect`, `.glass` / `.glassProminent` buttons), `.fontDesign(.rounded)`, and `ScenarioArtwork` for illustrations.
- **Glass side by side:** glass elements that sit next to each other (a row of glass circles, a group of chips) go in one `GlassEffectContainer`, so they blend and cost less. `.interactive()` only on what can be tapped.
- **Cards:** Today's and the profile's cards are clear Liquid Glass (`.glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))`). Learn still uses the dark Focus surface (`.learnSurface()`: dark with a faint white stroke) until they're moved over.
- **The big button** is `.buttonStyle(.primary)` (`DesignSystem/Components/Buttons.swift`): the glass capsule with the theme's two lights, as on "Start talking". Every large call to action uses it; don't style a big button by hand. `.primaryCompact` is the small filled capsule inside cards.
- **Everything follows the theme colour** (`AppTheme.shared.palette`, `.accent`, `.accentFill`). No fixed colours except meaning (coral for mistakes).
- **Choosing a design:** when a screen's design is open, build two to four options on the branch behind a temporary "‹ n / N ›" glass switcher. The maintainer picks one, and the others and the switcher are removed before the PR is merged.
- **Touch feedback:** a tap that opens or starts something answers with a **medium** haptic (`.sensoryFeedback(.impact(weight: .medium), …)`), not a light one. A sheet opened from a button or card **zooms out of it** (`.matchedTransitionSource` on the source, `.navigationTransition(.zoom)` on the sheet). Articles has both; the rest of the app follows.
- **Soft scroll edges, no scroll bars:** every scrolling view (`ScrollView`, `List`, `Form`, sheets and sideways rows included) gets `.scrollEdgeEffectStyle(.soft, for: .all)` and `.scrollIndicators(.hidden)` (the maintainer's rules, 15 and 16 Nov).
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

- **Deadline: v1 is submitted to App Review on 1 Dec 2026** (decided by the maintainer on 15 Nov, with no buffer), so it is live around 3 Dec.
- **v1 has:** Today, Learn (Write, Read, Grammar with its A1 rules, Translate, "How do I say …?", Fix your mistakes), Memory, **iCloud sync, Widgets and Prices (Alltag Pro with StoreKit 2)**, Settings, Profile and the translation extension. **v1.1** has Listen, more Grammar rules (#276), Siri AI and the Keyboard.
- **Milestones say when:** `v1` (due 1 Dec, the submission), `v1.1` (the first update after launch) and `Later` (no date). The old weekly milestones (`1 · Today` … `5 · Launch`) are closed.
- **Main issues say what.** Each part of the app is one main issue (label `epic`) with **sub-issues** (GitHub sub-issues):
  - In `v1`: Today #324, Learn #325, Memory #311, iCloud #54, Widgets #55, App Store Connect #326, Translation extension #327, Settings #328, Profile #329, Prices #57, Testing #330, Launch #331.
  - In `v1.1`: Siri AI #132, Keyboard #56.
  - A new issue goes under the main issue of its part. One branch and PR per sub-issue. An issue says what, why, and when it is done.
- **Order of the work** (a guide, not milestones): Today and Learn first, then Memory, iCloud, Widgets and Prices, then Testing (from about 26 Nov) and Launch (1 Dec).
- **Labels**, one of each group per issue:
  - **Type:** `feature`, `bug`, `design`, `content`, `chore`.
  - **Area:** `today`, `conversation`, `learn`, `memory`, `profile`, `settings`, `onboarding`, `server`, `beyond` (Siri, widgets, nudges, extensions), `pro` (the subscription and its limits), `design-system`.
  - **Priority**, in v1 only: `must-have` (v1 can't ship without it) and `nice-to-have` (if there's time; otherwise it moves to `v1.1`).
  - **State:** `epic`, `idea`, `decision` (waits for the maintainer's decision), `needs-device` (not closed before it was tried on the iPhone), `accessibility`, `performance`. `ci` and `dependencies` belong to the automation.
- **Real or hidden:** anything in v1 that doesn't work for real by the Testing week is hidden (App Review guideline 2.1). No mock content ships. iCloud, Widgets and Prices each have this fallback; use it instead of cutting them earlier.
- Outdated issues are **closed as "not planned"**, never deleted.

### Keeping the scope

The launch slipped because every new idea became an issue and then work at once. These rules stop that; agents follow them too.

1. **Ideas inbox.** A new idea is an issue of one line with the label `idea` and no milestone (template "Idea"). Nobody works on it. When the maintainer brings up an idea in a session, offer to write it down as an `idea` instead of starting on it.
2. **Sorted once a week.** Each `idea` gets a milestone, goes to `Later`, or is closed. Between sortings, only something that blocks the launch joins the work.
3. **v1 is frozen.** What isn't in the `v1` milestone doesn't enter it; adding something means taking something out.
4. **Two open PRs at most.** Nothing new starts before an open one is merged or closed.
5. **Before the submission**, what isn't done moves to `v1.1` by name or is hidden.

## Current state (15 Nov 2026)

Rewrite this section when it goes stale; it is a snapshot, not a rule.

**Today is done** except for three things that wait on the maintainer:
- **#212** The live voice stops hearing after three or four turns. Needs the Xcode console lines filtered by `Realtime` from the maintainer's iPhone.
- **#185** A new title for "From your day", and **#194** what the two rows under the 60 seconds become: the maintainer's decisions.
- **#171** Save the transcript and the mistakes: done by session history, except "new words reach Memory". Ask whether to close it or move it to the Memory week.

**Live voice is Gemini (#309):** `gpt-realtime` cost too much for a subscription to carry (an estimated $0.60–1.00 for ten minutes), so the live voice is Google's Gemini 3.8 Live (about a fifth): `GeminiLiveConversationService`, with tokens from the `gemini-live-session` function. The maintainer compared both on the iPhone and chose Gemini; the OpenAI voice and the switch are gone from the app. The `realtime-session` function is still deployed and unused; retiring it is a change under `supabase/`, so ask first.

**TestFlight:** the `asc` CLI on the maintainer's Mac is signed in with an API key and can upload and manage builds, but Alltag has no App Store Connect record yet; creating it needs the maintainer's Apple ID (`asc web apps create` or the website). Archive from a clean `main`, not a branch with uncommitted work.

**Learn is the focus now** (main issue #325). The idea that ties it together: everything the learner does in Learn feeds one loop. What they get wrong is saved to Fix your mistakes and comes back until they know it; every session is kept in Your sessions.

**Who does what (agreed 16 Nov):** Today is for speaking, Learn for something new, Memory for keeping and reviewing. Fix your mistakes therefore lives in Memory's Mistakes folder (not on Learn), and Your sessions is a row on Today. **Word collections (#386, merged):** ready-made words by level and topic live on Learn under the tools, as a row of fanned glass cards (`Collections/`). The section title opens all collections (level chips, topics; topics without words are names marked "Coming soon"), a collection's page is a scene of chat bubbles (the maintainer's pick), and + saves the words to Memory as saved words with the source `.collection`. Six collections have words so far (A2, B1); more content comes topic by topic. The Practise cards show real progress only: Grammar's rules solved, Read's saved words, "Coming soon" for Write and Listen.

Done on Learn: "How do I say …?" (**#304, in its PR:** it answers in place on Learn through `AskInPlace` and `AskModel`, asking the server only on send; the answer card grows under the field and its details open under it, the design the maintainer chose. The `.howToSay` route and `TranslateView(isAsking:)` are still there but Learn's field no longer opens them), Translate with OpenAI (streamed), Alltag as the default translation app (extension `AlltagTranslation/`), Fix your mistakes with the learner's own mistakes, Your sessions.

**Fix your mistakes has a real loop (#251, in its PR):** each answer moves the mistake in Memory through `ReviewSchedule` (pure, date passed in; right → 1, 3, 7, 14 days, then learned; wrong → a step back and due at once). Memory's own review should use the same function. The card shows only due mistakes, the practice (`MistakeRoundView`) never falls back to samples, and it zooms out of the card through a namespace `RootView` puts in the environment. The designs: the stack card with the quote (now on top of Memory's Mistakes folder), the learner **writes the sentence correctly** in a field that starts with what was said (`MistakePractice.isFixed`: punctuation and the first word's case don't count; "Show the fix" counts as not yet; the maintainer tried it on 16 Nov and approved it), and a before-and-after card per mistake at the end. Memory's "Start review" still runs sample questions; that is the Memory week.

The Learn features, **in this order**:
1. **#252** Articles: **done** (#292, #294). A round of der, die, das (**#385, in its PR:** now a game, the nouns fall faster each time and the learner taps the article before one lands; a landed noun comes back but isn't a Mistake), "Look up a word" with a history, and the clues as tiles. Its parts set the standard the other Learn screens follow (state cards, bookmark that saves and unsaves, medium haptics, zoom into sheets).
1a. **#295** Translate in the Articles standard, put before Write by the maintainer: **#296** the screen (pair card with the welcome in its lower half, the big button above the keyboard, placeholders while loading, detail cards with symbols, a history; in its PR) and then **#297** the panel in other apps in the same look (in its PR; the designs are chosen). `AlltagTranslation/` is a plain group in the project, not a synchronized folder: a new file there needs a project change, so ask first.
2. **#263** Write: a short task, corrected sentence by sentence. A shell today.
3. **#269** Read: real-life texts, tap a word, check understanding. A shell today.
4. **#275** Grammar: linked from the learner's mistakes. Ships with the twenty A1 rules, the twenty A2 rules, the thirty B1 rules, the 61 B2 rules and the twenty-two C1 rules; the rules of the other levels (#276) are in `v1.1` unless the maintainer says otherwise. **The page (in its PR)** follows the maintainer's own spec: "Your next rule" (the first unsolved rule at the learner's level, in order, then the level above), "The rule in real life" (a real sentence a day for that rule, chosen by the maintainer from four options), three cheat sheets for the learner's level only (none for der, die, das: Articles has those) and All rules, all on Today's clear glass. **The new rule shape (in its PR):** the maintainer tried it on one rule, the accusative, and approved it on 16 Nov ("i like it very much"; the picture's symbols are plain, with no box and no rotation). A rule has one line of rule, a picture of what it means (`RuleVisual`: two plain symbols, an arrow when one leads to the other, a tiny table), three short real-life sentences, and an **Exam** (`ExamQuestion`, `ExamModel`) of an easy, a medium and a hard question in place of "Try it". All three right solves the rule. The rules of a level open in order (`GrammarProgress.blocker(of:)`); a topic with a rule is never listed as solved in `MockLevels`. **All twenty A1 rules are written this way** (`MockRules.a1`, in the `MockRules+A1….swift` files), for the app and offline, not copied from a textbook. The maintainer approved A1 on TestFlight 1.0 (3). **All thirty B1 rules are written the same way** (`MockRules.b1`, in the `MockRules+B1….swift` files; their sentences in `RealLifeSentences+B1….swift`). **The 61 B2 rules are written the same way** (`MockRules.b2`, in the `MockRules+B2….swift` files). **The twenty A2 rules are written the same way** (`MockRules.a2`, in the `MockRules+A2….swift` files). The maintainer tried A2 to C1 on TestFlight 1.0 (4) and approved them on 16 Nov. **The twenty-two C1 rules are written the same way** (`MockRules.c1`, in the `MockRules+C1….swift` files; the prototype's `nominal` became `c1-nominalisierung`). Rule IDs above A1 start with their level (`b1-praeteritum`), and the statics with it (`b1SimplePast`), so the levels never clash. A new rule needs: its entry in the level's list in order, three real-life sentences (their English and place are String Catalog keys), a picture whose table rows have unique labels, and an exam whose hard question says how many tiles are left over. `ExamTests` checks all of that.
5. **#280** Listen: short spoken texts with questions, and dictation. A shell today: **moved to `v1.1`** and hidden in v1.
6. **#285** Polish: every state, light mode, one pass on the iPhone.

**Open decisions (maintainer)**, with the agent's recommendation in each issue: written content, generated content or both (#264, #270); which voice for Listen (#280); Scan a letter in v1 or later (#274).

**Apple's cloud model (#259)** is in the code and switched off. The maintainer has enrolled in the App Store Small Business Program and waits for Apple to assign the entitlement. See `PrivateCloudLanguageModelClient.isEntitled` for how to switch it on.

**Never tried on a real device:** the situation role-plays, the 60-second recording and "Listen to yourself", the thinking-time values (merged untested), the translation panel in other apps, "How do I say …?" with a real answer.

**Planned on 15 Nov:** every open issue is in `v1`, `v1.1` or `Later`, and every v1 issue sits under one of the main issues above. Memory is #311 (#312–#314, #118), Testing #330 (#258, #315, #317), Launch #331 (#162, #163, #300, #320, #321), App Store Connect #326 (#316, #318, #319, #341). New on 15 Nov: iCloud #332–#334, Widgets #335–#337, Prices #338–#340 (#338, what is free and what is Pro, waits for the maintainer), Translation extension #342–#343, Settings #344–#345, Profile #346.

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
- `Alltag/Features/<Screen>/`: views and their `@Observable` models. In a big folder the screen and its model stay at the top and the other files go into subfolders by part of the screen (`Exam/`, `Lookup/`, `History/`, `Parts/` for a screen's pieces), with written content in `Content/` or `Topics/`. A folder of about six files or fewer stays flat. A new file goes into the subfolder of its part. The app target is a synchronized folder, so moving a file there needs no change to `project.pbxproj`.
- `Alltag/Services/<Area>/`: service protocols, mocks and live implementations.
- `Alltag/DesignSystem/`: tokens and shared components. Use them rather than raw values.
- `Alltag/Intents/`: App Intents (Siri, Shortcuts, Spotlight).
- `supabase/`: the Edge Functions (`gemini-live-session` for the voice, `realtime-session` the old OpenAI voice and unused, `check-german` for the mistake check, `translate` for translating) and migrations, owned by the maintainer. See `supabase/README.md`.
