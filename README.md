# Handoff: Alltag — iOS Language-Learning Companion (Prototype v0.1)

## Overview
Alltag ("everyday") is an ambient German-learning companion: *"Learn German through the life you're already living."* The app turns everyday activity (reading, writing, Calendar events, conversations) into short practice. This bundle documents the first interactive design prototype so it can be rebuilt natively in **Swift + SwiftUI** (iOS 27+ SDK, Liquid Glass where noted).

### Platforms
| Platform | Minimum | Notes |
|---|---|---|
| iPhone | iOS 27 | Primary design target — every screen in this document is designed for iPhone. |
| Foldable iPhone | iOS 27 | Same app; layouts must adapt to the unfolded width via size classes. |
| iPad | iPadOS 27 | Same app; adaptive layouts (wider content, `NavigationSplitView` where it helps). |
| Apple Watch | watchOS 27 | Separate watchOS target — companion only (1-minute challenge, word review). Not designed yet. |
Apple Vision Pro is **not** supported. The design reference is a 393×852 iPhone frame; larger sizes are derived from it.

## About the Design Files
`Alltag Prototype.dc.html` is a **design reference built in HTML** — it shows intended look, copy, and behaviour. It is **not** production code. Recreate it in a new Xcode project using SwiftUI, SF Symbols, native materials, and Apple's navigation/animation systems. No third-party UI libraries. Open the HTML in Safari/Chrome (keep `support.js` next to it) and click through the phone; the left panel jumps to any screen.

## Fidelity
**High-fidelity.** Colours, type scale, radii, spacing and copy are final for this iteration. Map them to native equivalents (SF Pro via system font, SF Symbols for the Material Symbols used in the HTML, `.ultraThinMaterial` / `.glassEffect()` for glass surfaces).

---

## Getting started in Xcode
1. The Xcode project `Alltag` exists (iOS App · SwiftUI · Swift). Persistence uses **SwiftData** — add the `ModelContainer` in `AlltagApp` with the first `@Model` types (user profile, memory items, phrasebook, solved rules, saved translations). The Watch app is added later as a separate watchOS target.
2. Create the folder structure in **Architecture** below.
3. Build `DesignSystem/` first (tokens + reusable components), then `Home`, then each feature.
4. Use `NavigationStack(path:)` with an `enum Route: Hashable` — **no TabView**.
5. Add SwiftUI `#Preview`s for each screen and key states (conversation idle/listening/thinking/speaking; activity answered right/wrong; onboarding steps).

## Architecture
Plain SwiftUI with `@Observable` models and services injected through the SwiftUI environment. No third-party libraries in the app (SwiftLint is a development tool only).

**One app target, organised in folders** (Xcode synchronized folders — the folders on disk are the groups in Xcode). Shared code can move into a local Swift package later, when the Watch app and extensions arrive.
```
Alltag/                                   ← repo root
├─ Alltag.xcodeproj
├─ Alltag/                                app target (iPhone, iPad, foldable)
│  ├─ App/
│  │  ├─ AlltagApp.swift                  @main, ModelContainer, environment setup
│  │  ├─ AppState.swift                   @Observable: user, settings, permissions, isPro
│  │  ├─ AppServices.swift                bundles all services; mock or live
│  │  ├─ Route.swift                      enum Route: Hashable
│  │  └─ RootView.swift                   NavigationStack(path:), covers, onboarding gate
│  │
│  ├─ DesignSystem/
│  │  ├─ Tokens/
│  │  │  ├─ Colors.swift                  semantic + asset colours (light/dark)
│  │  │  ├─ Typography.swift              text roles mapped to Dynamic Type styles
│  │  │  ├─ Radius.swift
│  │  │  ├─ Spacing.swift
│  │  │  └─ Motion.swift                  push/modal animations, Reduce Motion
│  │  └─ Components/
│  │     ├─ GlassButton.swift
│  │     ├─ PrimaryButton.swift           54pt accent capsule CTA
│  │     ├─ CardRow.swift
│  │     ├─ SectionHeader.swift
│  │     ├─ Eyebrow.swift
│  │     ├─ Pill.swift
│  │     ├─ ToggleRow.swift
│  │     ├─ OptionCard.swift
│  │     ├─ ProgressSegments.swift
│  │     ├─ StrengthDots.swift
│  │     └─ Toast.swift
│  │
│  ├─ Components/                         app-specific building blocks
│  │  ├─ SmartBar/
│  │  │  ├─ SmartBar.swift
│  │  │  └─ SmartBarChips.swift
│  │  ├─ VoiceOrb.swift
│  │  ├─ WordTile.swift
│  │  ├─ PatternBar.swift
│  │  └─ EqualizerBars.swift
│  │
│  ├─ Models/
│  │  ├─ Persistent/                      SwiftData @Model
│  │  │  ├─ UserProfile.swift
│  │  │  ├─ MemoryItem.swift
│  │  │  ├─ Phrase.swift
│  │  │  ├─ SolvedRule.swift
│  │  │  └─ SavedTranslation.swift
│  │  ├─ Content/                         plain structs for lesson content
│  │  │  ├─ Scenario.swift
│  │  │  ├─ ConversationLine.swift
│  │  │  ├─ Activity.swift
│  │  │  ├─ GrammarRule.swift
│  │  │  ├─ TranslationResult.swift
│  │  │  └─ Briefing.swift
│  │  └─ Enums/
│  │     ├─ Level.swift                   A1–C2
│  │     ├─ Goal.swift
│  │     ├─ NativeLanguage.swift
│  │     ├─ Interest.swift
│  │     ├─ DailyTime.swift
│  │     └─ NudgeTime.swift
│  │
│  ├─ Services/                           protocol + mock (+ live later) per service
│  │  ├─ Speech/
│  │  │  ├─ SpeechService.swift
│  │  │  └─ MockSpeechService.swift
│  │  ├─ Voice/
│  │  │  ├─ VoiceService.swift
│  │  │  └─ SystemVoiceService.swift      AVSpeechSynthesizer (real in phase 1)
│  │  ├─ Translation/
│  │  │  ├─ TranslationService.swift
│  │  │  └─ MockTranslationService.swift
│  │  ├─ Companion/
│  │  │  ├─ CompanionService.swift
│  │  │  └─ MockCompanionService.swift
│  │  ├─ Calendar/
│  │  │  ├─ CalendarService.swift
│  │  │  └─ MockCalendarService.swift
│  │  └─ Notifications/
│  │     ├─ NotificationService.swift
│  │     └─ MockNotificationService.swift
│  │
│  ├─ Intents/                            App Intents — Siri AI, Spotlight, Shortcuts
│  │  ├─ Entities/
│  │  │  ├─ WordEntity.swift
│  │  │  ├─ PhraseEntity.swift
│  │  │  ├─ ScenarioEntity.swift
│  │  │  └─ GrammarRuleEntity.swift
│  │  ├─ Actions/
│  │  │  ├─ StartConversationIntent.swift
│  │  │  ├─ TranslateIntent.swift
│  │  │  ├─ ReviewWordsIntent.swift
│  │  │  └─ OpenRuleIntent.swift
│  │  └─ AlltagShortcuts.swift            AppShortcutsProvider
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
│  │  │  ├─ HomeTopBar.swift
│  │  │  ├─ FocusCard.swift
│  │  │  ├─ ComingUpCard.swift
│  │  │  ├─ EntryGrid.swift
│  │  │  ├─ GrammarCard.swift
│  │  │  ├─ FromYourDayList.swift
│  │  │  └─ BeyondRow.swift
│  │  ├─ Conversation/
│  │  │  ├─ ConversationView.swift
│  │  │  ├─ ConversationModel.swift       state machine
│  │  │  ├─ ConversationHeader.swift
│  │  │  ├─ TranscriptView.swift
│  │  │  ├─ MessageRow.swift
│  │  │  ├─ FeedbackCard.swift
│  │  │  └─ SummarySheet.swift
│  │  ├─ Translate/
│  │  │  ├─ TranslateView.swift
│  │  │  ├─ TranslateModel.swift
│  │  │  ├─ LanguageCapsule.swift
│  │  │  ├─ ResultCard.swift
│  │  │  ├─ WordByWordSection.swift
│  │  │  ├─ ToneSection.swift
│  │  │  └─ InContextSection.swift
│  │  ├─ Memory/
│  │  │  ├─ MemoryView.swift              Words | Phrasebook
│  │  │  ├─ WordsTab.swift
│  │  │  ├─ WordRow.swift
│  │  │  ├─ ReviewCard.swift
│  │  │  └─ PhrasebookTab.swift
│  │  ├─ Learn/
│  │  │  ├─ LearnView.swift
│  │  │  ├─ ActivityView.swift
│  │  │  ├─ ActivityModel.swift
│  │  │  ├─ OptionButton.swift
│  │  │  ├─ AudioPlayerCard.swift
│  │  │  └─ ActivityResultView.swift
│  │  ├─ Grammar/
│  │  │  ├─ GrammarView.swift
│  │  │  ├─ TopicRow.swift
│  │  │  ├─ RuleView.swift
│  │  │  ├─ RuleModel.swift
│  │  │  └─ WordOrderTask.swift
│  │  ├─ Debrief/
│  │  │  ├─ DebriefView.swift
│  │  │  └─ DebriefModel.swift
│  │  ├─ Briefing/
│  │  │  └─ BriefingView.swift
│  │  ├─ Progress/
│  │  │  ├─ ProgressOverviewView.swift    not `ProgressView` — clashes with SwiftUI
│  │  │  ├─ CEFRTrack.swift
│  │  │  ├─ SituationRow.swift
│  │  │  └─ SkillBars.swift
│  │  ├─ Profile/
│  │  │  └─ ProfileView.swift
│  │  ├─ Settings/
│  │  │  └─ SettingsView.swift
│  │  └─ Beyond/
│  │     └─ BeyondView.swift              concept previews only
│  │
│  ├─ MockData/
│  │  ├─ MockScenarios.swift
│  │  ├─ MockTranslations.swift
│  │  ├─ MockMemoryItems.swift
│  │  ├─ MockActivities.swift
│  │  ├─ MockRules.swift
│  │  ├─ MockLevels.swift
│  │  ├─ MockPhrasebook.swift
│  │  ├─ MockDebrief.swift
│  │  └─ MockBriefing.swift
│  │
│  └─ Resources/
│     ├─ Assets.xcassets                  AppIcon, AccentColor, Success, Mistake (light + dark)
│     ├─ Localizable.xcstrings
│     └─ AppShortcuts.xcstrings           Siri phrases
│
├─ AlltagTests/                           Swift Testing (added in M0)
│  ├─ ConversationModelTests.swift
│  ├─ ActivityModelTests.swift
│  ├─ RuleModelTests.swift
│  └─ OnboardingModelTests.swift
│
├─ AlltagWatch/                           watchOS target (M5)
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
├─ .swiftlint.yml
├─ .gitignore
└─ README.md
```
**Services rule:** screens talk to service protocols, never to a framework directly. Phase 1 uses the mock implementations; later milestones swap in the real ones (Speech, Foundation Models, Translation, EventKit) without touching the screens.

**Moving existing files:** `AlltagApp.swift` moves to `App/`, `Assets.xcassets` to `Resources/`, and `ContentView.swift` is replaced by `RootView.swift`.

---

## Design Tokens
**Colours — light and dark**
The app supports **both appearances** and follows the system setting. The prototype was designed in dark mode, so the values below are the **dark** values. For light mode:
- Neutrals (background, surfaces, labels, separators) map to iOS semantic colours, which adapt automatically: `systemBackground`, `secondarySystemBackground`, `tertiarySystemBackground`, `systemFill`, `label`, `secondaryLabel`, `tertiaryLabel`, `separator`.
- Accent, success and mistake are colour sets in the asset catalog with a dark and a light variant. The light variants need to be darker so they keep enough contrast on white (to be defined and checked against WCAG AA).
- Glass surfaces use native materials / `.glassEffect()`, which adapt on their own.

Dark values:
| Token | Value |
|---|---|
| background | `#000000` |
| surface (cards) | `#1C1C1E` |
| surface2 (inner tiles, rows pressed) | `#2C2C2E` |
| surface3 (bars, keys, inactive) | `#3A3A3C` |
| result card | `#232325` |
| label | `#F5F5F7` |
| secondaryLabel | `rgba(235,235,245,0.60)` (0.55 / 0.50 used for small meta) |
| tertiaryLabel | `rgba(235,235,245,0.30–0.45)` |
| separator | `rgba(255,255,255,0.08–0.10)`, 0.5pt, inset 16 or 68 |
| accent (amber) | `oklch(0.81 0.13 75)` ≈ `#F2B24E` |
| success (green) | `oklch(0.81 0.13 155)` ≈ `#7FD69A` |
| mistake (coral) | `oklch(0.81 0.11 35)` ≈ `#F2A08A` |
| on-accent text | `#1A1408` |
| glass | `rgba(44,44,46,0.7)` + blur 24–28 + 0.5pt `rgba(255,255,255,0.12)` stroke → use native glass/material |
Accent tints: accent @ 0.10–0.22 opacity for selected backgrounds and soft radial glows (top-right of focus/hero cards).

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
Support Dynamic Type. The sizes above are the values at the default text size. In code, every role maps to the closest text style (`.largeTitle`, `.title`, `.title2`, `.title3`, `.headline`, `.body`, `.footnote`, `.caption`) plus weight/tracking — small differences from the exact sizes are accepted. Sizes with no matching style (Hero 44, AI line 23) use a custom size with `relativeTo:` so they still scale.

**Radii:** hero cards 28 · cards 24 · inner cards 20 · tiles 16–20 · option buttons 18 · chips/pills full · glass buttons circle (36–48). Use `.continuous` corner style.
**Spacing:** screen padding 16 (onboarding 20) · card padding 16–22 · grid gap 12 · row height ≥ 50 · touch targets ≥ 44.
**Phone frame reference:** 393×852 (iPhone 15/16 Pro). Foldable iPhone and iPad use the same tokens with adaptive layouts (wider max content width, more grid columns).

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
Keyboard suggestion strip (Replace / Why?), select-to-translate sheet (Save for practice), Siri phrases (each launches the matching in-app flow), widgets (Word of the day, Review 6), Watch 1-minute challenge.

---

## State (suggested `@Observable AppState`)
`userName, nativeLanguage, goal, level, dailyTime, nudgeTime, interests: Set, permissions, isPro, settings toggles, memoryItems, phrasebook, solvedRules: Set, savedTranslations`, plus per-feature view models: `ConversationModel(phase, messages, step, mode, showHint)`, `ActivityModel(index, picked, score, done)`, `RuleModel(picked: [Int], result)`.

## Simulated vs real
- **Real in native build (phase 1):** navigation, all UI states, AVSpeechSynthesizer pronunciation, haptics, local mock data, SwiftData persistence.
- **Simulated:** speech recognition, companion replies & feedback, translations (3 samples), debrief answer, placement.
- **Later:** see the framework table below.

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
| SwiftData + CloudKit | Sync between iPhone, iPad and Watch | Yes |
| WatchConnectivity | Phone ⇄ Watch | No |
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
