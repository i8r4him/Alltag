# Default translation provider — foundation (#245)

This target uses Apple's Translation Provider Extension template and `TranslationUIProviderSelectedTextScene`. The host embeds `AlltagTranslation.appex` in its `Extensions` directory and declares `com.apple.developer.translation-app`. Both host and extension declare the network-access Info.plist key. No App Group or model-store change is introduced here.

## Development status

The panel currently only receives and displays selected text. It is a development foundation, not a usable translator and not ready for App Store submission. #246 adds the real translation UI and replacement handling; #247 adds the App Group and saving to Memory. Do not ship the placeholder panel.

## Device checks still required

With paid-team signing, let Xcode create profiles for the host and `i8r4him.Alltag.Translation`. Install the app, find it in Settings → Apps → Default Apps → Translation (the precise path can vary by OS), then select text in another app and choose Translate. Verify the provider receives the selected text. Simulator compilation alone does not prove default-app registration or provisioning.

## Availability and App Review research

Apple documents default translation apps from iOS/iPadOS 18.4 onward. Its general documentation and UAE iPhone guide do not state an EU-only restriction; this is evidence that the feature is not described as EU-only, not a guarantee for every region. Confirm on the intended devices/storefronts.

App Review guideline 4.4 requires extension functionality to be accurately described and prohibits marketing, advertising and in-app purchases inside extensions. The development panel must be replaced by the working translation experience before submission. Cloud processing consent and shared Memory handling remain work for #246/#247.

Sources checked 13 Nov 2026:
- https://developer.apple.com/documentation/translationuiprovider/preparing-your-app-to-be-the-default-translation-app
- https://developer.apple.com/documentation/bundleresources/entitlements/com.apple.developer.translation-app
- https://support.apple.com/en-ae/guide/iphone/iphddb6e7264/ios
- https://developer.apple.com/app-store/review/guidelines/#extensions
