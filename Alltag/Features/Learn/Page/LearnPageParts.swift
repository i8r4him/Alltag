//
//  LearnPageParts.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The designs of everything on Learn under the tools, behind the temporary switcher.
enum LearnPageDesign: Int, CaseIterable {
    case ticket, notebook, orbit, week, sentence, receipt, playlist, chat, board, bento
    case greenhouse, loom, stage, circuit, scales

    /// The design's working name, only for talking about it while one is picked.
    var name: String {
        switch self {
        case .ticket: "Fahrkarte"
        case .notebook: "Heft"
        case .orbit: "Orbit"
        case .week: "Woche"
        case .sentence: "Satz"
        case .receipt: "Kassenbon"
        case .playlist: "Playlist"
        case .chat: "Chat"
        case .board: "Pinnwand"
        case .bento: "Bento"
        case .greenhouse: "Gewächshaus"
        case .loom: "Webstuhl"
        case .stage: "Bühne"
        case .circuit: "Schaltkreis"
        case .scales: "Waage"
        }
    }
}

/// Learn under the tools in the design picked with the temporary "‹ n / N ›"
/// switcher: Today's lesson and the four parts, each design its own idea.
struct LearnPageDesigns: View {
    let content: LearnPageContent

    @AppStorage("learnPage.design") private var design = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Spacer()
                LearnDesignSwitcher(design: $design)
            }
            switch LearnPageDesign(rawValue: design) ?? .ticket {
            case .ticket: LearnTicketDesign(content: content)
            case .notebook: LearnNotebookDesign(content: content)
            case .orbit: LearnOrbitDesign(content: content)
            case .week: LearnWeekDesign(content: content)
            case .sentence: LearnSentenceDesign(content: content)
            case .receipt: LearnReceiptDesign(content: content)
            case .playlist: LearnPlaylistDesign(content: content)
            case .chat: LearnChatDesign(content: content)
            case .board: LearnBoardDesign(content: content)
            case .bento: LearnBentoDesign(content: content)
            case .greenhouse: LearnGreenhouseDesign(content: content)
            case .loom: LearnLoomDesign(content: content)
            case .stage: LearnStageDesign(content: content)
            case .circuit: LearnCircuitDesign(content: content)
            case .scales: LearnScalesDesign(content: content)
            }
        }
    }
}

/// The temporary switcher between page designs goes once the maintainer has picked one.
private struct LearnDesignSwitcher: View {
    @Binding var design: Int

    private var count: Int { LearnPageDesign.allCases.count }
    private var current: LearnPageDesign { LearnPageDesign(rawValue: design) ?? .ticket }

    var body: some View {
        HStack(spacing: 0) {
            Button { step(by: -1) } label: {
                Image(systemName: "chevron.left")
                    .frame(width: 36, height: 36)
                    .contentShape(.rect)
            }
            .accessibilityLabel(Text("Previous design"))
            Text(verbatim: "\(current.name) · \(current.rawValue + 1) / \(count)")
                .monospacedDigit()
            Button { step(by: 1) } label: {
                Image(systemName: "chevron.right")
                    .frame(width: 36, height: 36)
                    .contentShape(.rect)
            }
            .accessibilityLabel(Text("Next design"))
        }
        .buttonStyle(.plain)
        .font(.subheadline.weight(.semibold))
        .padding(.horizontal, 4)
        .glassEffect(.regular.interactive(), in: .capsule)
        .sensoryFeedback(.selection, trigger: design)
    }

    private func step(by offset: Int) {
        withAnimation(.smooth) {
            design = (current.rawValue + offset + count) % count
        }
    }
}

/// A section's title with a small note on the right, as the designs head their parts.
struct LearnSectionTitle: View {
    let title: Text
    var note: Text?

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            title
                .textRole(.sectionHeader)
            Spacer(minLength: 8)
            if let note {
                note
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 4)
    }
}

/// A thin bar of a part's progress, in the theme colour.
struct PartBar: View {
    let fraction: Double

    var body: some View {
        Capsule()
            .fill(.controlFill)
            .frame(height: 6)
            .overlay(alignment: .leading) {
                Capsule()
                    .fill(.accentFill)
                    .scaleEffect(x: max(0.02, min(fraction, 1)), anchor: .leading)
            }
            .accessibilityHidden(true)
    }
}

extension LearnPageContent {
    /// The next step of today's lesson, or `nil` once it is done.
    var current: LessonStep? { DailyLesson.current(in: steps) }
    /// How many steps are done today.
    var doneCount: Int { steps.filter(\.isDone).count }
    /// The whole lesson's minutes.
    var totalMinutes: Int { steps.map(\.minutes).reduce(0, +) }

    var lessonNote: Text {
        current == nil ? Text("Done for today") : Text("About \(DailyLesson.minutesLeft(in: steps)) min")
    }

    func status(of step: LessonStep) -> Text {
        if step.isDone { return Text("Done") }
        return step.id == current?.id ? Text("Next") : Text(verbatim: "")
    }
}

extension LessonPart {
    /// The part's name in German, as the playful designs write it (a stop, a word on a ticket).
    var germanName: String {
        switch self {
        case .words: "Wörter"
        case .grammar: "Regel"
        case .read: "Lesen"
        case .write: "Schreiben"
        case .mistakes: "Fehler"
        }
    }
}

extension LearnOverview.Part {
    /// Done from 0 to 1 for a ring or a bar; Write, with no total, fills up over ten texts.
    var shownFraction: Double {
        fraction ?? min(Double(done) / 10, 1)
    }

    /// The count as a departure board or an index shows it: "08/20", or "2 ✎" for Write.
    var count: String {
        total > 0 ? String(format: "%02d/%02d", done, total) : "\(done) ✎"
    }
}

extension Date {
    /// The date in German, as the designs write it ("Freitag, 20. November").
    func german(_ style: Date.FormatStyle) -> String {
        formatted(style.locale(Locale(identifier: "de_DE")))
    }
}

/// A part's real progress in a few words: "8 of 20 solved", "3 of 24 read",
/// "2 texts written", "1 of 6 saved", or "Coming soon".
struct PartProgressText: View {
    let part: LearnOverview.Part

    var body: some View {
        switch part.kind {
        case .grammar:
            Text("\(part.done) of \(part.total) solved")
        case .read:
            Text("\(part.done) of \(part.total) read")
        case .words:
            Text("\(part.done) of \(part.total) saved")
        case .write:
            if part.done > 0 {
                Text("^[\(part.done) text](inflect: true) written")
            } else {
                Text("Nothing written yet")
            }
        case .listen:
            Text("Coming soon")
        }
    }
}
