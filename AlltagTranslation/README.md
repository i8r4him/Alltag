# Alltag default translation extension

The ExtensionKit provider receives selected text and presents a scrollable panel using the app's shared glass, typography, colour assets and theme tokens. It uses the same Supabase authentication client and OpenAI stream parser as the app. Voice-only authentication methods remain in the app target.

## Behaviour

- No text is sent until the learner permits cloud translation in the extension.
- The source can arrive after the sheet opens; the view observes it and restarts its task when it changes.
- The translation appears first, followed by words, tones and examples as generated.
- Replacement is offered only when allowed by the source app and after a successful complete response.
- The look follows the app's Translate screen: clear glass cards, a symbol in the accent colour on every header, rows with a line between them, a bookmark on a glass circle, medium haptics.
- A long translation is arranged for reading by `TranslationLayout` (in `TranslationPanelModel.swift`, from line breaks and length alone, no server change): a short first line as a heading, the short lines after it as facts, the rest as paragraphs in body size. A short phrase keeps the large style. A long selection shows its first four lines until "Show all".
- **While #297 is open**, the headers and the long text each have three designs behind a temporary "‹ n / N ›" switcher, stored in the extension's own defaults.
- The bookmark saves and takes out again: taking out removes the entry from the inbox as long as the app hasn't imported it.
- Save the whole translation or an individual word into the shared App Group inbox. The host imports it into its existing SwiftData Memory store when it opens or becomes active. Existing app data is not moved and the schema is unchanged.
- Import is duplicate-safe. A shared file is removed only after the database save succeeds.
- Selected text is limited to the server's 600 UTF-16 code-unit limit; longer selections receive an explanation rather than being silently truncated.

## Signing and device checks

The host and extension require `group.i8r4him.Alltag` in their provisioning profiles. Automatic signing may register the App Group; if Xcode reports it missing, enable the same App Group on both targets using the paid team.

Test on iPhone: select a short sentence in Safari, choose Translate, allow cloud translation, check the streamed answer, save a word, open Alltag → Memory → Saved, and verify that word appears once. Try replacement in an editable text field. Repeat in light/dark mode and with no connection. Simulator builds and stub tests do not prove signed extension launch, Keychain access, App Group provisioning or live-network access on a device.

## Availability and review research

Apple documents default translation apps from iOS/iPadOS 18.4 onward. Its general documentation and UAE iPhone guide do not state an EU-only restriction; this is not a guarantee for every region. Confirm on the intended devices/storefronts.

App Review guideline 4.4 requires accurate disclosure of extension functionality and prohibits marketing, advertising and in-app purchases in extensions.

Sources checked 13 Nov 2026:
- https://developer.apple.com/documentation/translationuiprovider/preparing-your-app-to-be-the-default-translation-app
- https://developer.apple.com/documentation/bundleresources/entitlements/com.apple.developer.translation-app
- https://support.apple.com/en-ae/guide/iphone/iphddb6e7264/ios
- https://developer.apple.com/app-store/review/guidelines/#extensions
