//
//  LearnSentenceDesign.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Page design 5, "Satz": today's lesson is one big German sentence ("Heute
/// lernst du die Wörter Mein Zuhause, übst die Regel Der Akkusativ, liest
/// einen Text und schreibst Lena."), each step a tappable word that is struck
/// through once done. The parts of Learn follow as a numbered index, like a
/// magazine's contents.
struct LearnSentenceDesign: View {
    let content: LearnPageContent

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.section) {
            if !content.steps.isEmpty {
                LessonSentence(content: content)
            }
            VStack(alignment: .leading, spacing: 4) {
                LearnSectionTitle(title: Text(verbatim: "Alles"))
                VStack(spacing: 0) {
                    ForEach(Array(content.overview.doors.enumerated()), id: \.element.id) { index, part in
                        if index > 0 {
                            Divider()
                        }
                        Button { content.openPart(part.kind) } label: { row(part, number: index + 1) }
                            .buttonStyle(.plain)
                            .accessibilityElement(children: .combine)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }

    private func row(_ part: LearnOverview.Part, number: Int) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 14) {
            Text(verbatim: String(format: "%02d", number))
                .font(.system(size: 34, weight: .light, design: .rounded))
                .foregroundStyle(.accent)
                .frame(width: 48, alignment: .leading)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(part.kind.title)
                    .font(.title2.weight(.heavy))
                if let next = part.next {
                    HStack(spacing: 4) {
                        Text("Next:")
                        next.title.text
                    }
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Text(verbatim: part.count)
                .font(.subheadline.weight(.heavy))
                .monospacedDigit()
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 14)
        .contentShape(.rect)
    }
}

/// The day, the sentence with a word per step, its English, and "Los geht’s".
private struct LessonSentence: View {
    let content: LearnPageContent

    var body: some View {
        let steps = content.steps
        let current = DailyLesson.current(in: steps)
        let minutes = steps.map(\.minutes).reduce(0, +)
        VStack(alignment: .leading, spacing: 16) {
            Text(verbatim: "\(Date.now.german(.dateTime.weekday(.wide))) · \(minutes) MIN".uppercased())
                .font(.subheadline.weight(.heavy))
                .tracking(1.4)
                .foregroundStyle(.accent)
            FlowLayout(spacing: 7, lineSpacing: 10) {
                ForEach(Array(tokens(for: steps).enumerated()), id: \.offset) { _, token in
                    switch token.kind {
                    case .word(let word):
                        Text(verbatim: word)
                    case .step(let step, let label, let punctuation):
                        chip(step, label: label, punctuation: punctuation)
                    }
                }
            }
            .font(.title2.weight(.heavy))
            .padding(.horizontal, 4)
            Text("One thing from every part of Learn. Tap a word to start there.")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 4)
            if let current {
                GlassEffectContainer {
                    Button { content.open(current.target) } label: {
                        Label {
                            Text(verbatim: "Los geht’s")
                        } icon: {
                            Image(systemName: "play.fill")
                        }
                    }
                    .buttonStyle(.primary)
                }
            } else {
                Label("Done for today", systemImage: "checkmark.circle.fill")
                    .font(.headline)
                    .foregroundStyle(.accent)
                    .padding(.horizontal, 4)
            }
        }
    }

    private func chip(_ step: LessonStep, label: String, punctuation: String) -> some View {
        HStack(spacing: 1) {
            Button { content.open(step.target) } label: {
                Text(verbatim: label)
                    .strikethrough(step.isDone)
                    .foregroundStyle(step.isDone ? AnyShapeStyle(.tertiary) : AnyShapeStyle(.accent))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 2)
                    .background {
                        Capsule()
                            .fill(step.isDone ? Color.clear : Color.accentFill.opacity(0.18))
                    }
                    .overlay {
                        Capsule()
                            .strokeBorder(step.isDone ? Color.secondary.opacity(0.3) : Color.accentFill.opacity(0.55),
                                          lineWidth: 1)
                    }
                    .contentShape(.capsule)
            }
            .buttonStyle(.tile)
            .matchedTransitionSource(id: step.target, in: content.zoom)
            .accessibilityLabel(step.title.text)
            .accessibilityValue(step.isDone ? Text("Done") : Text(verbatim: ""))
            if !punctuation.isEmpty {
                Text(verbatim: punctuation)
            }
        }
    }

    /// The sentence as words and steps: "Heute", then for each step its verb
    /// ("lernst du", "übst", "liest", "schreibst", "verbesserst") and the step
    /// itself, joined with commas and "und" before the last.
    private func tokens(for steps: [LessonStep]) -> [SentenceToken] {
        var tokens = [SentenceToken(kind: .word("Heute"))]
        for (index, step) in steps.enumerated() {
            let (verb, label) = Self.phrase(for: step)
            if index > 0, index == steps.count - 1 {
                tokens.append(SentenceToken(kind: .word("und")))
            }
            for word in verb.split(separator: " ") {
                tokens.append(SentenceToken(kind: .word(String(word))))
            }
            if index == 0 {
                tokens.append(SentenceToken(kind: .word("du")))
            }
            let punctuation = index == steps.count - 1 ? "." : (index == steps.count - 2 ? "" : ",")
            tokens.append(SentenceToken(kind: .step(step, label, punctuation)))
        }
        return tokens
    }

    /// The verb before a step, and the step as a word in the sentence.
    private static func phrase(for step: LessonStep) -> (verb: String, label: String) {
        switch step.part {
        case .words:
            return ("lernst", "die Wörter \(german(step.title))")
        case .grammar:
            return ("übst", "die Regel \(german(step.title))")
        case .read:
            if case .scene = step.target { return ("liest", "etwas aus dem Alltag") }
            return ("liest", "einen Text")
        case .write:
            if case .chat(let contact) = step.title { return ("schreibst", contact) }
            return ("schreibst", "einen Text")
        case .mistakes:
            if case .mistakes(let count) = step.title { return ("verbesserst", "\(count) Fehler") }
            return ("verbesserst", "deine Fehler")
        }
    }

    private static func german(_ title: LessonTitle) -> String {
        if case .german(let text) = title { return text }
        return ""
    }
}

/// A word of the sentence, or a step shown as a word with the punctuation after it.
private struct SentenceToken {
    enum Kind {
        case word(String)
        case step(LessonStep, String, String)
    }

    let kind: Kind
}
