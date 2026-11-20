//
//  ToolPanel.swift
//  AlltagKeyboard
//
//  Created by Ibrahim Abdullah on 21.11.26.
//

import SwiftUI

/// What a tool shows in place of the tools row: that it is working, its answer, or why it has none.
/// A fix is one strip with Why? and Replace; its reasons and the answer of "How do I say …?"
/// take the numbers row too.
struct ToolPanel: View {
    let tools: KeyboardTools
    @State private var taps = 0
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        content
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(KeyCap.fill(isDark: colorScheme == .dark))
                    .strokeBorder(Color.accent.opacity(0.35), lineWidth: 1)
                    // A tap on the card must not reach the keys under it.
                    .onTapGesture {}
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .sensoryFeedback(.impact(weight: .medium), trigger: taps)
    }

    @ViewBuilder private var content: some View {
        switch tools.panel {
        case .working(let tool):
            HStack(spacing: 8) {
                closeButton
                ProgressView()
                    .controlSize(.small)
                (tool == .fix ? Text("Checking your German…") : Text("Finding the words…"))
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
                Spacer(minLength: 0)
            }
        case .notice(let notice):
            HStack(spacing: 8) {
                closeButton
                Self.text(of: notice)
                    .font(.system(size: 13))
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                Spacer(minLength: 0)
            }
        case .fix(let fix):
            FixCard(fix: fix, showsWhy: tools.showsWhy, close: closeButton,
                    why: { tap { tools.toggleWhy() } }, replace: { tap { tools.replaceText() } })
        case .answer(let answer, let register):
            AnswerCard(answer: answer, register: register, isAsking: tools.isAskingAgain, close: closeButton,
                       choose: { register in tap { Task { await tools.sayAgain(register: register) } } },
                       replace: { tap { tools.replaceText() } })
        case nil:
            EmptyView()
        }
    }

    private var closeButton: some View {
        Button {
            tools.close()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(.secondary)
                .frame(width: 26, height: 26)
                .background(Color.primary.opacity(0.08), in: .circle)
                .contentShape(.circle)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text("Close"))
    }

    private func tap(_ action: () -> Void) {
        taps += 1
        action()
    }

    static func text(of notice: KeyboardTools.Notice) -> Text {
        switch notice {
        case .needsFullAccess: Text("Turn on Full Access for the Alltag keyboard in Settings to use its tools.")
        case .nothingTyped(.fix): Text("Type something in German first, then tap Fix.")
        case .nothingTyped(.say): Text("Type what you want to say, in any language, then tap again.")
        case .looksRight: Text("Looks right. Nothing to fix.")
        case .dailyLimit: Text("You’ve reached today’s limit. Try again tomorrow.")
        case .failed: Text("Check your connection, then try again.")
        case .textChanged: Text("The text has changed. Tap the tool again.")
        }
    }
}

/// A small pill in a tool's card. The filled one is the card's main step.
private struct PanelPill: View {
    let title: Text
    var isMain = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            title
                .font(.system(size: 15, weight: .semibold))
                .lineLimit(1)
                .foregroundStyle(isMain ? Color.onAccent : Color.primary)
                .padding(.horizontal, 12)
                .frame(height: 28)
                .background(isMain ? Color.accentFill : Color.primary.opacity(0.1), in: .capsule)
                .contentShape(.capsule)
        }
        .buttonStyle(.plain)
    }
}

/// The corrected text with what changed in green, Why? and Replace; the reasons open under it.
private struct FixCard<Close: View>: View {
    let fix: KeyboardFix
    let showsWhy: Bool
    let close: Close
    let why: () -> Void
    let replace: () -> Void

    /// The corrected words in one text, the changed ones coloured.
    private var marked: AttributedString {
        let excerpt = FixMarks.excerpt(of: fix)
        var text = AttributedString(excerpt.startsLater ? "… " : "")
        for (index, word) in excerpt.words.enumerated() {
            var part = AttributedString(word.text + (index < excerpt.words.count - 1 ? " " : ""))
            if word.isChanged {
                part.swiftUI.foregroundColor = Color.success
                part.swiftUI.font = Font.system(size: 16, weight: .semibold)
            }
            text.append(part)
        }
        return text
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 8) {
                close
                Text(marked)
                    .font(.system(size: 16))
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if !fix.reasons.isEmpty {
                    PanelPill(title: Text("Why?"), action: why)
                }
                PanelPill(title: Text("Replace"), isMain: true, action: replace)
            }
            .frame(height: 32)
            if showsWhy {
                ScrollView {
                    Text(verbatim: fix.reasons.joined(separator: "\n"))
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 4)
                }
                .scrollEdgeEffectStyle(.soft, for: .all)
                .scrollIndicators(.hidden)
                .padding(.bottom, 4)
            }
        }
    }
}

/// The German for what was typed, a choice of everyday and formal, and Replace.
private struct AnswerCard<Close: View>: View {
    let answer: KeyboardAnswer
    let register: KeyboardRegister
    let isAsking: Bool
    let close: Close
    let choose: (KeyboardRegister) -> Void
    let replace: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            ScrollView {
                Text(verbatim: answer.german)
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 4)
                    .padding(.top, 6)
            }
            .scrollEdgeEffectStyle(.soft, for: .all)
            .scrollIndicators(.hidden)
            .opacity(isAsking ? 0.4 : 1)
            HStack(spacing: 8) {
                HStack(spacing: 0) {
                    ForEach(KeyboardRegister.allCases, id: \.self) { option in
                        Button {
                            choose(option)
                        } label: {
                            (option == .everyday ? Text("Everyday") : Text("Formal"))
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(option == register ? Color.primary : Color.secondary)
                                .padding(.horizontal, 10)
                                .frame(height: 24)
                                .background(option == register ? Color.primary.opacity(0.14) : .clear, in: .capsule)
                                .contentShape(.capsule)
                        }
                        .buttonStyle(.plain)
                        .accessibilityAddTraits(option == register ? .isSelected : [])
                    }
                }
                .padding(2)
                .background(Color.primary.opacity(0.06), in: .capsule)
                if isAsking {
                    ProgressView()
                        .controlSize(.small)
                }
                Spacer(minLength: 0)
                close
                PanelPill(title: Text("Replace"), isMain: true, action: replace)
            }
            .padding(.bottom, 5)
        }
    }
}
