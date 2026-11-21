---
name: alltag-preflight
description: Check Alltag for App Store rejection reasons before a TestFlight or App Store submission. Use only when asked for a preflight, a submission check or after a rejection.
---

# Alltag App Store preflight

Check the code first; the App Store Connect part needs the app's record (`asc apps list` shows whether it exists).
Report, don't fix: each finding becomes an issue or a line in the PR, unless the maintainer says to fix it.

## What Alltag is (so only the relevant rules are checked)

Free v1, no in-app purchases, no ads, no tracking, no visible account (Supabase signs in anonymously),
no web views. It sends text and voice to OpenAI through its own server when the learner allows cloud use.
Targets: the app and the `AlltagTranslation` and `AlltagShare` extensions.

## 1. Code checks

| Guideline | Check | How |
|---|---|---|
| Privacy manifest | `PrivacyInfo.xcprivacy` in **all three** targets (#441; CI checks they are in the built bundles), with every required-reason API, including those of app files the extensions also build | `find . -name PrivacyInfo.xcprivacy`; grep `UserDefaults`, `@AppStorage` (CA92.1), file `creationDate`/`modificationDate` (DDA9.1/C617.1), `systemUptime` (35F9.1), `volumeAvailableCapacity` (E174.1) |
| 5.1.1(i) | A privacy policy link **in the app** (Settings) and in App Store Connect | grep `Link(` / `URL(string:` in `Features/Settings/` |
| 5.1.2(i) | Explicit consent before personal data goes to OpenAI | the cloud toggle in Settings, the translation extension's consent, the usage descriptions naming OpenAI |
| 5.1.1 | Every permission has a usage description that says why | `INFOPLIST_KEY_NS*UsageDescription` in `project.pbxproj`; every framework that asks (`AVAudioApplication`, `SFSpeechRecognizer`, `EKEventStore`, `UNUserNotificationCenter`) has its key |
| 2.4.5 / entitlements | Every entitlement is used | `plutil -p` on both `.entitlements`; `translation-app` and the App Group need a sentence in the review notes |
| 2.1 | No shell, mock content or "coming soon" on a visible screen | the four Learn skills, `AppServices.live()` fallbacks, hidden-at-week-end items (AGENTS.md "Real or hidden") |
| 2.1 | The server works during review, and the daily limit can't block the reviewer | `supabase/` limits; say in the review notes how to reach each feature |
| 4.2 | Plenty of native function: say so in the review notes | |
| 5.2.5 / 2.3.7 | "OpenAI", "GPT", "ChatGPT" not in the app name, subtitle or keywords; fine in privacy text | |
| China | Metadata mentioning OpenAI is refused in China mainland; either leave it out or exclude that storefront | maintainer's decision |

## 2. App Store Connect checks (when the record exists)

```sh
asc apps list
asc metadata pull --app "<APP_ID>" --version "<VERSION>" --dir ./metadata   # into the scratchpad, never the repo
```

- Name ≤ 30 characters, no brand names, no prices, no other platforms (2.3.7, 2.3.10).
- Screenshots show the app in use (2.3.3); support URL and privacy policy URL filled in (1.5, 5.1.1).
- App Privacy answers match the manifests: an anonymous user ID and usage (linked to it), audio to Google (Gemini Live) and text to OpenAI (not linked), all for app functionality; no tracking.
- Age rating and the review notes (the cloud toggle, the live voice, where each Learn feature is).

## 3. Report

```markdown
## Preflight
### Will be rejected (N)
- [5.1.1] What is wrong, `file`, fix
### Risk (N)
- [2.1] …
### Passed (N)
- [Privacy] …
```

Based on truongduy2611/app-store-preflight-skills (MIT).
