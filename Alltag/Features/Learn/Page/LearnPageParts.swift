//
//  LearnPageParts.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

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
