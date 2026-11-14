---
name: alltag-accessibility
description: Check one Alltag screen for accessibility (VoiceOver, large text, contrast, touch targets, Reduce Motion) and propose small fixes. Use only when asked for an accessibility check or in the Polish pass (#285).
---

# Alltag accessibility check

One screen at a time, read from the code. Small, local fixes: keep the layout and the text unless accessibility needs a change.
The maintainer tries the result on the iPhone; give them the steps.

## Check

**VoiceOver**
- Every icon-only button has a label (the glass circles: Listen, Slowly, bookmark, swap, history). No "button" in the label.
- A card reads as one sensible element (`.accessibilityElement(children: .combine)`) without saying the same text twice.
- Section titles are headers (`.accessibilityAddTraits(.isHeader)`, or `.textRole(.sectionHeader)` where it adds the trait).
- Reading order follows the screen; decorative symbols and `ScenarioArtwork` are hidden.
- German text is read with a German voice: set the language on the text (an `AttributedString` with `languageIdentifier = "de"`) and confirm on the iPhone.
- A toast or a change without focus is announced (`AccessibilityNotification.Announcement`).
- No `onTapGesture` where a `Button` belongs.

**Large text**
- Text styles only, no fixed font sizes; sizes that must grow use `@ScaledMetric`.
- Fixed widths (`.frame(width:)`) around text break at the largest sizes: use `ViewThatFits` or let it wrap.
- No `minimumScaleFactor` to hide the problem; nothing important cut off with `lineLimit`.

**Colour and contrast**
- Nothing is said by colour alone: a mistake (coral) also has a symbol or a word; selected and disabled states are clear without colour.
- Theme colours keep their contrast on glass in light and dark (`ColorContrastTests`).

**Touch**
- Tappable things are at least 44 × 44 pt; enlarge the hit area with `.contentShape` rather than the look.
- Haptics are never the only feedback.

**Motion**
- With Reduce Motion, zoom transitions, symbol effects and repeating animations are calmer or off (`@Environment(\.accessibilityReduceMotion)`).

## Report

Findings by priority, each with what is wrong, why it matters in one line, and the code change:
- **P0** blocks someone (an unlabelled button, a control VoiceOver can't reach, text cut off).
- **P1** makes it hard (wrong order, colour-only state, small target).
- **P2** polish.

Then the steps for the iPhone: VoiceOver on (swipe through the screen), the largest text size in Settings › Accessibility › Display & Text Size, Reduce Motion on, light and dark. Xcode's Accessibility Inspector (Audit) can run on the maintainer's Mac too.

Based on rgmez/apple-accessibility-skills (`swiftui-accessibility-auditor`) and dadederk/iOS-Accessibility-Agent-Skill (MIT).
