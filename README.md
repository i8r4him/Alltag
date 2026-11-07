# Handoff: Alltag — iOS Language-Learning Companion (Prototype v0.1)

## Overview
Alltag ("everyday") is an ambient German-learning companion for iPhone: *"Learn German through the life you're already living."* The app turns everyday activity (reading, writing, Calendar events, conversations) into short practice. This bundle documents the first interactive design prototype so it can be rebuilt natively in **Swift + SwiftUI** (iOS 26 SDK, Liquid Glass where noted).

## About the Design Files
`Alltag Prototype.dc.html` is a **design reference built in HTML** — it shows intended look, copy, and behaviour. It is **not** production code. Recreate it in a new Xcode project using SwiftUI, SF Symbols, native materials, and Apple's navigation/animation systems. No third-party UI libraries. Open the HTML in Safari/Chrome (keep `support.js` next to it) and click through the phone; the left panel jumps to any screen.

## Fidelity
**High-fidelity.** Colours, type scale, radii, spacing and copy are final for this iteration. Map them to native equivalents (SF Pro via system font, SF Symbols for the Material Symbols used in the HTML, `.ultraThinMaterial` / `.glassEffect()` for glass surfaces).

---

## Getting started in Xcode
1. Xcode → New Project → iOS App · Interface: SwiftUI · Language: Swift · Storage: SwiftData (for later). Name: `Alltag`.
2. Create the folder structure below (groups in Xcode).
3. Build `DesignSystem/` first (tokens + reusable components), then `Home`, then each feature.
4. Use `NavigationStack(path:)` with an `enum Route: Hashable` — **no TabView**.
5. Add SwiftUI `#Preview`s for each screen and key states (conversation idle/listening/thinking/speaking; activity answered right/wrong; onboarding steps).

Suggested structure:
```
Alltag/
  App/            AlltagApp.swift, AppState.swift (@Observable), Route.swift
  DesignSystem/   Tokens.swift (Color/Font/Radius/Spacing), GlassButton, CardRow, SectionHeader,
                  Pill, Toggle row, OptionCard, ProgressSegments, StrengthDots, Toast
  Components/     SmartBar, VoiceOrb, WordTile, PatternBar, EqualizerBars
  Features/
    Onboarding/   OnboardingFlow + 8 step views
    Home/         HomeView, FocusCard, ComingUpCard, EntryGrid, GrammarCard, FromYourDayList
    Conversation/ ConversationView, ConversationModel (state machine), SummarySheet
    Translate/    TranslateView
    Memory/       MemoryView (Words | Phrasebook)
    Learn/        LearnView, ActivityView (multiple-choice runner)
    Grammar/      GrammarView, RuleView (word-order task)
    Debrief/      DebriefView
    Briefing/     BriefingView
    Progress/     ProgressView
    Profile/      ProfileView
    Settings/     SettingsView
    Beyond/       BeyondView (concept previews only)
  MockData/       Scenarios, Translations, MemoryItems, Activities, Rules, Levels, Phrasebook, Briefing
```

---

## Design Tokens
**Colours (dark only)**
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
Support Dynamic Type — use text styles (`.largeTitle`, `.title2`, `.headline`, `.body`, `.footnote`) rather than fixed sizes.

**Radii:** hero cards 28 · cards 24 · inner cards 20 · tiles 16–20 · option buttons 18 · chips/pills full · glass buttons circle (36–48). Use `.continuous` corner style.
**Spacing:** screen padding 16 (onboarding 20) · card padding 16–22 · grid gap 12 · row height ≥ 50 · touch targets ≥ 44.
**Phone frame reference:** 393×852 (iPhone 15/16 Pro).

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
Top: back glass button · 6 progress segments (accent filled) · "Skip". Bottom: full-width 54pt accent capsule CTA.
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
Greeting "Good evening, {name}." + subtitle with inline bold "3 new words" and globe symbol "Safari".
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
Native: `Speech` (SFSpeechRecognizer de-DE), `AVSpeechSynthesizer`, haptics on state changes.

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
- **Later:** Foundation Models (on-device) + cloud for Pro, Translation framework, App Intents/Siri, WidgetKit, keyboard extension, EventKit, Watch.

## Assets
No images. Icons are Material Symbols Rounded in the HTML → replace with SF Symbols, e.g. `mic`, `waveform`, `translate`, `book`, `bolt`, `chart.line.uptrend.xyaxis`, `gearshape`, `calendar`, `headphones`, `person.wave.2`, `text.badge.checkmark`, `cross.case`, `tram`, `shippingbox`, `lightbulb`, `keyboard`, `speaker.wave.2`, `bookmark`, `checkmark.circle.fill`, `xmark.circle.fill`.

## Files
- `Alltag Prototype.dc.html` — the full interactive prototype (template + logic + all mock data in the `<script>` class: `SCEN`, `TR`, `MEM`, `ACTS`, `RULES`, `LEVELS`, `PB`, `DB`, `BRIEF`).
- `support.js` — runtime needed to open the HTML locally.
- `screenshots/` — 30 numbered captures of every screen and key state (onboarding → home → features → settings). Some transient states (conversation reply, debrief result, rule "Try it" result) are best seen live in the HTML.
