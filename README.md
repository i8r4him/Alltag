# Handoff: Alltag — iOS Language-Learning Companion (Prototype v0.1)

## Overview
Alltag ("everyday") is an ambient German-learning companion: *"Learn German through the life you're already living."* The app turns everyday activity (reading, writing, Calendar events, conversations) into short practice. This bundle documents the first interactive design prototype so it can be rebuilt natively in **Swift + SwiftUI** (iOS 27+ SDK, Liquid Glass where noted).

### Platforms
| Platform | Minimum | Notes |
|---|---|---|
| iPhone | iOS 27 | Primary design target — every screen in this document is designed for iPhone. |
| Foldable iPhone | iOS 27 | Same app; unfolded (regular width) it gets a `NavigationSplitView` sidebar and readable content widths. |
iPad, Apple Watch and Apple Vision Pro are **not** supported. The design reference is a 393×852 iPhone frame; larger sizes are derived from it.

## About the Design Files
`Alltag Prototype.dc.html` is a **design reference built in HTML** — it shows intended look, copy, and behaviour. It is **not** production code. Recreate it in a new Xcode project using SwiftUI, SF Symbols, native materials, and Apple's navigation/animation systems. No third-party UI libraries. Open the HTML in Safari/Chrome (keep `support.js` next to it) and click through the phone; the left panel jumps to any screen.

## Fidelity
**High-fidelity.** Colours, type scale, radii, spacing and copy are final for this iteration. Map them to native equivalents (SF Pro via system font, SF Symbols for the Material Symbols used in the HTML, `.ultraThinMaterial` / `.glassEffect()` for glass surfaces).

---

## Getting started in Xcode
1. The Xcode project `Alltag` exists (iOS App · SwiftUI · Swift). Persistence uses **SwiftData** — add the `ModelContainer` in `AlltagApp` with the first `@Model` types (user profile, memory items, phrasebook, solved rules, saved translations).
2. Create the folder structure in **Architecture** below.
3. Build `DesignSystem/` first (tokens + reusable components), then `Home`, then each feature.
4. Use `NavigationStack(path:)` with an `enum Route: Hashable` — **no TabView**. At regular width (unfolded foldable) the same path drives a `NavigationSplitView` with a sidebar.
5. Add SwiftUI `#Preview`s for each screen and key states (conversation idle/listening/thinking/speaking; activity answered right/wrong; onboarding steps).

## Architecture
Plain SwiftUI with `@Observable` models and services injected through the SwiftUI environment. No third-party libraries in the app (SwiftLint is a development tool only).

**One app target, organised in folders** (Xcode synchronized folders — the folders on disk are the groups in Xcode). Shared code can move into a local Swift package later, when widgets and extensions arrive.
```
Alltag/                                   ← repo root
├─ Alltag.xcodeproj
├─ Alltag/                                app target (iPhone, foldable iPhone)
│  ├─ App/
│  │  ├─ AlltagApp.swift                  @main, ModelContainer, environment setup
│  │  ├─ AppState.swift                   @Observable: navigation, full-screen flows, settings
│  │  ├─ AppSettings.swift                device settings in UserDefaults (motion, speech, Pro)
│  │  ├─ AppServices.swift                all services; .live() for the app, .mock() for previews/tests
│  │  ├─ Route.swift                      enum Route: Hashable
│  │  ├─ SidebarItem.swift                foldable sidebar sections, path ⇄ split view
│  │  └─ RootView.swift                   stack (compact) or NavigationSplitView (regular), covers, onboarding gate
│  │
│  ├─ DesignSystem/
│  │  ├─ Tokens/
│  │  │  ├─ Colors.swift                  semantic + asset colours (light/dark)
│  │  │  ├─ Typography.swift              text roles mapped to Dynamic Type styles
│  │  │  ├─ Radius.swift
│  │  │  ├─ Spacing.swift
│  │  │  └─ Motion.swift                  push/modal animations, Reduce Motion
│  │  ├─ Layout/
│  │  │  └─ ReadableWidth.swift           .readableContentMargins() / .readableWidth() for wide screens
│  │  └─ Components/
│  │     ├─ Buttons.swift                 PrimaryButtonStyle (.primary/.primaryCompact),
│  │     │                                OutlineButtonStyle (.outline), GlassButton
│  │     ├─ Pill.swift                    Pill, ChipButtonStyle (.chip(isSelected:))
│  │     ├─ Headers.swift                 Eyebrow, SectionHeader (.large/.grouped)
│  │     ├─ Rows.swift                    SymbolSquare, CardRow, ToggleRow
│  │     ├─ OptionCard.swift
│  │     ├─ Indicators.swift              ProgressSegments, StrengthDots
│  │     ├─ Toast.swift                   ToastView, .toast(_:)
│  │     ├─ FlowLayout.swift              wrapping layout for chips
│  │     └─ ComponentGallery.swift        previews of every component
│  │
│  ├─ Components/                         app-specific building blocks
│  │  ├─ SmartBar/
│  │  │  ├─ SmartBar.swift                SmartBar, SmartBarChips
│  │  │  ├─ SmartBarRouting.swift         context, actions → destinations (pure, tested)
│  │  │  └─ SmartBarModifier.swift        .smartBar(_:) — dimming, safe-area inset, navigation
│  │  ├─ VoiceOrb.swift
│  │  ├─ WordTile.swift                plain / key (outlined) / highlighted / placed
│  │  ├─ PatternBar.swift              slots with amber emphasis
│  │  └─ EqualizerBars.swift
│  │
│  ├─ Models/
│  │  ├─ Persistent/                      SwiftData @Model
│  │  │  ├─ AlltagStore.swift            schema V1, migration plan, container, sample-data seeding
│  │  │  ├─ UserProfile.swift
│  │  │  ├─ MemoryItem.swift
│  │  │  ├─ Phrase.swift
│  │  │  ├─ SolvedRule.swift
│  │  │  └─ SavedTranslation.swift
│  │  ├─ Content/                         plain structs for lesson content
│  │  │  ├─ Scenario.swift               Scenario, ConversationLine, Feedback
│  │  │  ├─ Activity.swift
│  │  │  ├─ GrammarRule.swift            GrammarRule, GrammarTopic
│  │  │  ├─ TranslationResult.swift
│  │  │  ├─ ProgressReport.swift          Progress data (sample until history exists)
│  │  │  └─ Briefing.swift               Briefing, Debrief, PlacementQuestion
│  │  └─ Enums/
│  │     ├─ MemoryKind.swift              MemoryKind, MemorySource
│  │     ├─ Level.swift                   A1–C2
│  │     ├─ Goal.swift
│  │     ├─ NativeLanguage.swift
│  │     ├─ Interest.swift
│  │     └─ DailyTime.swift               DailyTime, NudgeTime
│  │
│  ├─ Services/                           protocol + mock in one file; live versions added later
│  │  ├─ PermissionStatus.swift
│  │  ├─ Speech/
│  │  │  ├─ SpeechService.swift           SpeechService, SpeechError, MockSpeechService (words every 230ms)
│  │  │  └─ SystemSpeechService.swift     SpeechAnalyzer + SpeechTranscriber, de-DE, on device
│  │  ├─ Voice/
│  │  │  ├─ VoiceService.swift            VoiceService, SpeechRate, MockVoiceService (silent)
│  │  │  └─ SystemVoiceService.swift      AVSpeechSynthesizer, de-DE (real in phase 1)
│  │  ├─ Translation/TranslationService.swift   TranslationService, MockTranslationService (3 samples)
│  │  ├─ Companion/
│  │  │  ├─ CompanionService.swift        CompanionService, MockCompanionService (scripts, samples, fallback)
│  │  │  └─ OnDeviceCompanionService.swift   Foundation Models: feedback on own sentences, debriefs
│  │  ├─ Calendar/CalendarService.swift    CalendarService, CalendarEvent, MockCalendarService
│  │  └─ Notifications/NotificationService.swift   NotificationService, MockNotificationService
│  │
│  ├─ Intents/                            App Intents — Siri AI, Spotlight, Shortcuts
│  │  ├─ Entities/
│  │  │  ├─ ContentEntities.swift         ScenarioEntity, GrammarRuleEntity (+ queries)
│  │  │  └─ MemoryEntities.swift          WordEntity, PhraseEntity (+ SwiftData queries, MemoryLookup)
│  │  ├─ Actions/
│  │  │  ├─ StartConversationIntent.swift "Practise At the dentist"
│  │  │  ├─ TranslateIntent.swift
│  │  │  ├─ ReviewWordsIntent.swift
│  │  │  ├─ OpenRuleIntent.swift          OpenIntent for a GrammarRuleEntity
│  │  │  ├─ OpenMemoryIntent.swift
│  │  │  └─ SearchMemoryIntent.swift      App Schema: .system.searchInApp
│  │  ├─ AlltagShortcuts.swift            AppShortcutsProvider, phrases in AppShortcuts.xcstrings
│  │  ├─ SpotlightIndex.swift             IndexedEntity, reindexed at launch and in background
│  │  └─ OnscreenEntity.swift             .onscreenEntity(_:) for Rule and Memory
│  │
│  ├─ Features/
│  │  ├─ Onboarding/
│  │  │  ├─ OnboardingFlow.swift
│  │  │  ├─ OnboardingModel.swift
│  │  │  └─ Steps/
│  │  │     ├─ WelcomeStep.swift
│  │  │     ├─ NameStep.swift
│  │  │     ├─ WhyStep.swift
│  │  │     ├─ LevelStep.swift
│  │  │     ├─ DailyTimeStep.swift
│  │  │     ├─ InterestsStep.swift
│  │  │     ├─ PermissionsStep.swift
│  │  │     └─ SummaryStep.swift
│  │  ├─ Home/
│  │  │  ├─ HomeView.swift
│  │  │  ├─ HomeHeader.swift              Avatar, greeting (toolbar is native: .toolbar)
│  │  │  ├─ FocusCard.swift
│  │  │  ├─ ComingUpCard.swift
│  │  │  ├─ EntryGrid.swift
│  │  │  ├─ GrammarCard.swift
│  │  │  ├─ FromYourDayList.swift
│  │  │  └─ BeyondRow.swift
│  │  ├─ Conversation/
│  │  │  ├─ ConversationView.swift        native toolbar (close, title, voice/keyboard picker), goal, controls
│  │  │  ├─ ConversationModel.swift       state machine
│  │  │  ├─ TranscriptView.swift          companion and learner lines, heard text with caret
│  │  │  ├─ FeedbackCard.swift
│  │  │  └─ SummarySheet.swift            (#30)
│  │  ├─ Translate/
│  │  │  ├─ TranslateView.swift           language capsule in the toolbar, source and result cards
│  │  │  ├─ TranslateModel.swift          direction, swap, translating, saving
│  │  │  └─ TranslateSections.swift       Word by word, Tone, In context
│  │  ├─ Memory/
│  │  │  ├─ MemoryView.swift              large title, segmented Words | Phrasebook, .searchable, review card
│  │  │  ├─ MemoryFilter.swift            filters, search, ReviewSummary (pure, tested)
│  │  │  ├─ WordRow.swift
│  │  │  └─ PhrasebookTab.swift           (#33)
│  │  ├─ Learn/
│  │  │  ├─ LearnView.swift               Fix your mistakes card, practice moments
│  │  │  ├─ ActivityView.swift            native toolbar (close, segments), options, audio, done
│  │  │  └─ ActivityModel.swift           one pick per question, scoring, audio
│  │  ├─ Grammar/
│  │  │  ├─ GrammarView.swift             mistakes focus, native level picker, topics with status dots
│  │  │  ├─ GrammarProgress.swift         solved status and counts (tested)
│  │  │  ├─ RuleView.swift                numbered steps: heard, notice, rule, your own German
│  │  │  ├─ RuleModel.swift               word-order task, check, solved
│  │  │  └─ WordOrderTask.swift           "Try it" with tiles, Check, Mark as solved
│  │  ├─ Debrief/
│  │  │  ├─ DebriefView.swift             input, Find the words, Next time say, Save to phrasebook
│  │  │  └─ DebriefModel.swift            phases, companion, saving to the Phrasebook
│  │  ├─ Briefing/
│  │  │  ├─ BriefingView.swift            player with equalizer, highlighted transcript, word chips
│  │  │  └─ BriefingModel.swift           playback, highlighting, Memory labels
│  │  ├─ Progress/
│  │  │  └─ ProgressOverviewView.swift    level track, situations, skills, retention, insights
│  │  ├─ Profile/
│  │  │  └─ ProfileView.swift
│  │  ├─ Settings/
│  │  │  ├─ SettingsView.swift
│  │  │  ├─ SettingsModel.swift           permission toggles, on-device AI status
│  │  │  └─ DataExport.swift              Export my data (JSON)
│  │  └─ Beyond/
│  │     └─ BeyondView.swift              concept previews only
│  │
│  ├─ MockData/                           prototype data, copied exactly
│  │  ├─ MockScenarios.swift              SCEN
│  │  ├─ MockTranslations.swift           TR
│  │  ├─ MockMemoryItems.swift            MEM
│  │  ├─ MockActivities.swift             ACTS
│  │  ├─ MockRules.swift                  RULES
│  │  ├─ MockLevels.swift                 LEVELS
│  │  ├─ MockPhrasebook.swift             PB
│  │  ├─ MockDebrief.swift                DB
│  │  ├─ MockBriefing.swift               BRIEF
│  │  └─ MockPlacement.swift              placement question
│  │
│  └─ Resources/
│     ├─ Assets.xcassets                  AppIcon, AccentColor, Success, Mistake (light + dark)
│     ├─ Localizable.xcstrings            all UI text (British English); kept in sync by CI
│     └─ AppShortcuts.xcstrings           Siri phrases
│
├─ AlltagTests/                           Swift Testing (added in M0)
│  ├─ ConversationModelTests.swift
│  ├─ ActivityModelTests.swift
│  ├─ RuleModelTests.swift
│  └─ OnboardingModelTests.swift
│
├─ .github/
│  ├─ workflows/
│  │  ├─ ci.yml                           build + test (self-hosted Mac)
│  │  ├─ lint.yml                         SwiftLint (self-hosted Mac)
│  │  └─ labeler.yml                      auto-label PRs (GitHub Linux)
│  ├─ ISSUE_TEMPLATE/
│  │  ├─ feature.yml
│  │  ├─ bug.yml
│  │  └─ config.yml
│  ├─ pull_request_template.md
│  ├─ labeler.yml                         folder → label rules
│  ├─ release.yml                         release-notes categories
│  └─ dependabot.yml
│
├─ screenshots/                           design reference (01–30)
├─ scripts/
│  ├─ check_string_catalog.py           CI: fails if the String Catalog is out of date
│  └─ sync_string_catalog.sh            updates the catalog from the code (same as building in Xcode)
├─ .swiftlint.yml
├─ .gitignore
└─ README.md
```
**Services rule:** screens talk to service protocols, never to a framework directly. Phase 1 uses the mock implementations; later milestones swap in the real ones (Speech, Foundation Models, Translation, EventKit) without touching the screens.

**Folders are created with their first file.** Git doesn't track empty folders, and placeholder files such as `.gitkeep` can't be used: Xcode's synchronized folders copy them into the app bundle, and several files with the same name break the build. Each folder above appears in the PR that adds its first file.

---

## Design Tokens
**Colours — light and dark**
The app supports **both appearances** and follows the system setting. Code: `DesignSystem/Tokens/Colors.swift` and the colour sets in `Resources/Assets.xcassets`.

Neutral surfaces map to iOS grouped-background colours, which adapt automatically and match the prototype exactly in dark mode:
| Token | iOS colour | Dark | Light |
|---|---|---|---|
| `screenBackground` | `systemGroupedBackground` | `#000000` | `#F2F2F7` |
| `surface` (cards) | `secondarySystemGroupedBackground` | `#1C1C1E` | `#FFFFFF` |
| `surfaceSecondary` (inner tiles, pressed rows) | `tertiarySystemGroupedBackground` | `#2C2C2E` | `#F2F2F7` |
| `surfaceTertiary` (bars, keys, inactive) | `systemGray4` | `#3A3A3C` | `#D1D1D6` |
| `controlFill` (chips, pills, symbol squares) | `secondarySystemFill` | ≈ `#2C2C2E` on black | translucent grey |
| labels, separators | `label`, `secondaryLabel`, `tertiaryLabel`, `separator` | | |

Brand colours are asset-catalog colour sets. The light variants keep the same hue but are darker, so they pass WCAG AA (≥ 4.5 : 1) on white — checked by `ColorContrastTests`. The accent is split in two because one amber can't be both readable text and a bright fill on white:
| Token (colour set) | Use | Dark | Light |
|---|---|---|---|
| `accent` (AccentColor) | Text, icons, tint | `#F2B24E` | `#9A6100` |
| `accentFill` (AccentFill) | Filled buttons, glows | `#F2B24E` | `#EFA831` |
| `onAccent` (OnAccent) | Text on `accentFill` | `#1A1408` | `#1A1408` |
| `success` (Success) | Right, good, confident | `#7FD69A` | `#007E46` |
| `mistake` (Mistake) | Wrong, fix, shaky | `#F2A08A` | `#B05139` |
| `resultCard` (ResultCard) | Translation result card | `#232325` | `#FAFAFC` |

Glass surfaces use native materials / `.glassEffect()`, which adapt on their own (prototype: `rgba(44,44,46,0.7)` + blur 24–28 + 0.5pt `rgba(255,255,255,0.12)` stroke).
Accent tints (`AccentTint`): 0.10 selected backgrounds, 0.55 selected borders, 0.22 soft radial glows (top-right of focus/hero cards).

**Typography (SF Pro)**
| Role | Size / weight / tracking |
|---|---|
| Large title | 34 / bold / −0.9 |
| Hero (onboarding) | 44 / bold / −1.4 |
| Title 2 | 28–30 / bold / −0.8 |
| Section header | 20–22 / bold / −0.4 |
| Card title | 17 / semibold |
| Body | 15–17 / regular |
| Conversation AI line | 23 / semibold / −0.4 |
| Meta / caption | 12–13 |
| Eyebrow | 13 / semibold / +0.07em uppercase (accent or coral) |
Support Dynamic Type. Code: `DesignSystem/Tokens/Typography.swift`, applied with `.textRole(_:)`. Every role keeps the exact size above at the default text size and scales with `@ScaledMetric` relative to the closest system text style (hero and large title → `.largeTitle`, title 2 → `.title`, section header and AI line → `.title2`, card title → `.headline`, body → `.body`, meta and eyebrow → `.footnote`, caption → `.caption`). Tracking scales with the size.

**Radii:** hero cards 28 · cards 24 · inner cards 20 · tiles 16–20 · option buttons 18 · chips/pills full · glass buttons circle (36–48). Use `.continuous` corner style.
**Spacing:** screen padding 16 (onboarding 20) · card padding 16–22 · grid gap 12 · row height ≥ 50 · touch targets ≥ 44.
**Phone frame reference:** 393×852 (iPhone 15/16 Pro). The unfolded foldable iPhone uses the same tokens with adaptive layouts (sidebar, readable max content width).

---

## Navigation model
- Root: `NavigationStack` with Home. Push: Translate, Memory, Learn, Grammar → Rule, Progress, Profile, Settings, Beyond, Debrief, Briefing.
- **Full-screen covers** (`.fullScreenCover`): Conversation, Activity, Onboarding.
- **Sheet**: Conversation summary (`.presentationDetents([.medium])`).
- Back = glass circle chevron (top-left) — use the native back button with toolbar glass styling.
- Transitions: push = slide 28pt + fade (0.4s, ease-out `(.2,.8,.2,1)`); modal = rise 48pt + fade (0.45s). Use `.navigationTransition(.zoom)` from cards where it fits. Respect **Reduce Motion** (system + in-app toggle).

## Smart Bar (persistent, Home / Memory / Learn / Progress / Grammar)
Floating glass capsule, 12pt from sides, 28pt above home indicator, height 56, radius 28.
- Left `+` (rotates 45° when open) → reveals chips: Translate · Practise speaking · Fix a mistake · Review words.
- Text field, contextual placeholder: Home "Ask, translate or practise anything…", Memory "Find or add a word…", Learn "Ask for a 2-minute challenge…", Progress "Ask about your progress…".
- Right: mic (white circle) when empty → starts Conversation; accent ↑ send when text present → Translate (Memory: filters the list).
- Open state dims content (black 50%). Must move above keyboard (`.safeAreaInset(edge: .bottom)`).

---

## Screens

### Onboarding (8 steps, full-screen)
Top: back glass button · 6 progress segments (accent filled) · "Skip". The segments cover steps 1–6 only; Welcome (0) and Summary (7) have no progress bar. Bottom: full-width 54pt accent capsule CTA.
0 Welcome — eyebrow "ALLTAG", hero "Learn German through the life you already live.", soft amber radial glow. CTA "Get started".
1 Name (text field, required — CTA disabled when empty) + native language grid (English, Arabic, Turkish, Spanish, Ukrainian, Other).
2 Why — option cards with icon + subtitle (Living here, Work, Partner & family, Studies, Travel).
3 Level — A1–C1 option cards, or "Not sure? Find out in one question" → "Wie war dein Wochenende?" with 3 answers mapping to A2/B1/B2 → green confirmation text.
4 Daily time (5/10/20 min) + nudge time (Morning/Evening).
5 Interests chips (Housing, Work, Football, Cooking, Politics, Travel, Music, Health) — shared with Profile.
6 Permissions — Calendar, Notifications, Alltag Keyboard, each with "Allow"/"Allowed" pill (real flows: EventKit, UNUserNotificationCenter, keyboard instructions). Privacy note with lock icon.
7 Summary — "You're set, {name}." table + CTA "Start learning" → Home. Answers populate Settings.
Option card: min-height 60, radius 18, `#1C1C1E`; selected = accent 10% fill + accent 55% 1pt border + filled check.

### Home
Top bar: avatar (36, → Profile) · gear glass button (→ Settings).
Greeting by time of day ("Good morning / afternoon / evening, {name}.") + subtitle with inline bold "3 new words" and globe symbol "Safari".
1. **Today's Focus** card (radius 28, min-h 214, amber glow): eyebrow "TODAY'S FOCUS", "5 min" pill, "Speak German", "Real-life conversation · Moving an appointment", 56pt accent play circle (graphic_eq). → Conversation (dentist).
2. **Coming up** card — "Rehearse from your Calendar"; horizontally scrolling tiles 132×96 (snap): Dentist (TOMORROW, 10:00), Train to Munich (Fri 9:12), Return package (Sat). Each → its Conversation scenario.
3. **2×2 grid** (124pt tall cards): Translate · Learn · Memory · Progress (icon top, title + status bottom).
4. **Grammar** full-width card with mini sentence preview "… weil ich krank **bin**" → Grammar.
5. **From your day** list: 60-second briefing · Debrief bakery · 3 new words from Safari (→ Memory filtered) · 1 writing mistake (→ Activity).
6. "Learning beyond the app" outline row → Beyond.

### Conversation (full-screen)
Header: close · title/meta (scenario) · voice/keyboard segmented glass. Goal pill below.
Transcript: AI lines 23pt semibold left ("COMPANION" caption, tap toggles English); user lines 18pt right ("YOU") with feedback card (green check "good", coral edit "fix", grey info "note").
Bottom: keyboard button · **Voice Orb** (132pt) · hint (lightbulb) button; state label below.
**State machine:** idle → (tap) listening (words appear one at a time, 230ms, amber caret) → thinking (orb scales 0.8, amber spinner ring) → AI reply appended → speaking (orb wobble 1.1s) → idle. After last line → summary sheet (2 turns · 1 fix · 2 phrases saved; CTA "Practise your fixes · 1 min", "Done").
Orb: idle = grey-white radial sphere with mic, slow breathe 4s; active = warm amber radial + glow; listening = 2 expanding rings 1.6s.
Text mode: field "Antworte auf Deutsch…" + accent send. Scenarios: dentist, post office, train (see MockData in HTML `SCEN`).
Native: `Speech` (`SpeechAnalyzer` + `SpeechTranscriber`, de-DE — the newer API that replaces `SFSpeechRecognizer`), `AVSpeechSynthesizer`, haptics on state changes.

### Translate
Language capsule (English ⇄ German, swap), source card (editable), result card `#232325` with Listen / Slowly / bookmark save (toast "Saved to Memory"). Sections: Word by word (word, grammar note, meaning), Tone (Formal / Neutral — accent / Casual), In context (tap to hear). Unknown input → honest note: live translation will use Apple's Translation framework.

### Memory
Segmented Words | Phrasebook.
Words: search, filter chips (All, From your day, Saved, Mistakes, Due — selected = white fill/black text), "Ready to review" card, list rows (article in secondary + word, meaning, MISTAKE badge, 4 strength dots) expanding to context sentence, source, Listen, Practise.
Phrasebook: groups by place (At the doctor, Trains & travel, With my landlord, At work; "At the bakery" NEW after Debrief save).

### Learn & Activity
Learn: featured coral "FIX YOUR MISTAKES" card + rows (Recall from Safari, Listen: platform change, Speak scenario).
Activity (full-screen): close + progress segments, eyebrow/title, optional audio player with equalizer, quote card, question, option buttons (56pt, radius 18). After pick: right = green tint/border + check, wrong = coral + cancel, others 45% opacity; explanation card; "Continue". End: green check, "{n} of {total}. Nicely done.", "More to learn" / "Back home".

### Grammar & Rule
Grammar: "FROM YOUR MISTAKES" list, level segmented A1–C1, topic rows with status dot (green solved, amber in progress, coral mistake, grey new), "{n} of 5 solved".
Rule: level pill → title → numbered sections:
1 Heard in real life (scene card, tap to hear) · 2 Notice (word tiles; verb/end tiles accent-tinted, key word outlined) · 3 The rule (sentence + pattern bar of slots) · 4 From your own German (struck-through wrong / green right) · Try it (tap word tiles to build the sentence → Check → green/coral border) → "Mark as solved".
Six full rules: v2 (A1), perfekt & seit (A2), weil (B1), passiv (B2), nominal (C1). Other topics listed only. **Book chapter mapping pending** — user has two reference grammar books to align topics to.

### Debrief
"Lunch at the bakery · 12:40" (from Calendar). Text field "What did you want to say?" → "Find the words" → spinner → two phrase cards (tap to hear), grammar tip, "Save to phrasebook".

### Briefing
"YOUR BRIEFING · 60 SEC", title, play button + equalizer, transcript with learning words highlighted in accent, chips of words included. Concept note: Lock Screen / AirPods.

### Progress
B1 hero (56pt) with CEFR track A1–C2 · "Where you can manage" (6 situations, 3-segment bars, Confident / Getting there / Shaky-coral) · Skills bars (+change) · Words that stuck 86% mini bars · Spoken 42 min · Worth your attention · How you learn.

### Profile
Avatar 88, name, "Learning German since…", goal card with progress to B2, This week stats (3), Languages, interest chips, situations summary → Progress. Gear → Settings.

### Settings
Grouped inset lists (native `Form`/`List` .insetGrouped): profile header · Learning (Language, Level, Why, Daily time) · Alltag Pro card (trial / active) · Privacy & AI (on-device status, cloud toggle) · Learn from my day (Calendar, Safari, Keyboard, Camera) · Reminders · Accessibility (Reduce motion, Slower speech) · More (Beyond the app, Export my data) · Replay onboarding. Use native `Toggle`s with coloured symbol squares.

### Beyond the app (concepts only — do not register extensions yet)
Keyboard suggestion strip (Replace / Why?), select-to-translate sheet (Save for practice), Siri phrases (each launches the matching in-app flow), widgets (Word of the day, Review 6).

---

## State (suggested `@Observable AppState`)
`userName, nativeLanguage, goal, level, dailyTime, nudgeTime, interests: Set, permissions, isPro, settings toggles, memoryItems, phrasebook, solvedRules: Set, savedTranslations`, plus per-feature view models: `ConversationModel(phase, messages, step, mode, showHint)`, `ActivityModel(index, picked, score, done)`, `RuleModel(picked: [Int], result)`.

## Simulated vs real
- **Real in native build (phase 1):** navigation, all UI states, AVSpeechSynthesizer pronunciation, haptics, local mock data, SwiftData persistence.
- **Real on iPhone:** German speech recognition with `SpeechAnalyzer` (on device; the simulator keeps the simulated listening). Saying roughly the scripted line continues the script; anything else is your own sentence and gets feedback.
- **Real with Apple Intelligence:** feedback on sentences the learner makes up, and debriefs (Foundation Models, on device). Without it, Alltag uses the samples. Conversations keep their scripted replies so each scenario reaches its goal.
- **Simulated:** scripted companion replies & feedback, translations (3 samples), placement.
- **Later:** see the framework table below.

## Localization
- All UI text is in `Resources/Localizable.xcstrings`, written in **British English** ("Practise", "neighbours").
- UI text in models (onboarding options, level descriptions, Smart Bar placeholders) is `LocalizedStringResource`, so it is extracted too. Lesson content (scenarios, rules, translations) stays `String`: it is learning material, not interface text.
- Xcode adds new strings to the catalogs (`Localizable` and `AppShortcuts`) when you build; outside Xcode, run `scripts/sync_string_catalog.sh`. CI fails if a committed catalog is missing a string or still lists one the code no longer uses.

## Frameworks
All Apple frameworks — nothing to install.

**Phase 1**
| Framework | Used for |
|---|---|
| SwiftUI + Observation | All screens and app state |
| SwiftData | Profile, words, phrasebook, progress, saved translations |
| AVFoundation (`AVSpeechSynthesizer`) | Speaking German aloud |
| `sensoryFeedback` | Haptics for taps, answers, conversation states |
| String Catalogs | All UI text, ready for localization |
| Swift Testing | Unit tests for logic |
| OSLog | Logging |

**Later**
| Framework | Used for | Needs paid Developer Program |
|---|---|---|
| **App Intents** | Siri AI and Apple Intelligence: App Entities (words, phrases, scenarios, rules) indexed for personal context, intents conforming to App Schemas so Siri can act through natural language, onscreen awareness via entity-linked views, App Shortcuts, Spotlight, Action Button | No for development; Siri AI is a Developer Preview from iOS 27.3 beta |
| Speech (`SpeechAnalyzer`) | Hearing the learner's German | No |
| Foundation Models | On-device companion replies, corrections, debrief | No |
| Translation | Real translation | No |
| EventKit | "Coming up" from Calendar | No |
| UserNotifications | Daily nudges (local) | No |
| WidgetKit | Word of the day, Review widgets | Yes (App Groups for shared data) |
| SwiftData + CloudKit | Sync and backup across the learner's iPhones | Yes |
| TipKit | In-app hints | No |
| StoreKit 2 | Alltag Pro subscription | Yes (to sell) |
| Keyboard extension / Safari Web Extension | "Learn from my day" | Yes (App Groups) |

**Developer account:** development starts on a free account. Everything marked "Yes" is built behind the service protocols and switched on once the paid Developer Program is active (before release). TestFlight also needs the paid program.

**App Intents first-class:** every core noun (word, phrase, scenario, grammar rule) is modelled as an `AppEntity` from the start, and every core action (start a conversation, translate, review words, open a rule) as an `AppIntent`, so the app is ready for Siri AI without later refactoring. Siri AI integrations can be tested in Xcode now but can't ship to the App Store until Apple opens submissions.

## Assets
No images. Icons are Material Symbols Rounded in the HTML → replace with SF Symbols, e.g. `mic`, `waveform`, `translate`, `book`, `bolt`, `chart.line.uptrend.xyaxis`, `gearshape`, `calendar`, `headphones`, `person.wave.2`, `text.badge.checkmark`, `cross.case`, `tram`, `shippingbox`, `lightbulb`, `keyboard`, `speaker.wave.2`, `bookmark`, `checkmark.circle.fill`, `xmark.circle.fill`.

## Files
- `Alltag Prototype.dc.html` — the full interactive prototype (template + logic + all mock data in the `<script>` class: `SCEN`, `TR`, `MEM`, `ACTS`, `RULES`, `LEVELS`, `PB`, `DB`, `BRIEF`).
- `support.js` — runtime needed to open the HTML locally.
- `screenshots/` — 30 numbered captures of every screen and key state (onboarding → home → features → settings). Some transient states (conversation reply, debrief result, rule "Try it" result) are best seen live in the HTML.
