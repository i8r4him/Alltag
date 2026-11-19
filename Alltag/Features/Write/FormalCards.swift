//
//  FormalCards.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// A formal email that came in: who sent it, its subject and its first lines,
/// and the button to answer it with *Sie*.
struct EmailCard: View {
    let email: FormalEmail
    let onReply: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                ScenarioArtwork(systemImage: "envelope.fill", symbolSize: 20, cornerRadius: 12)
                    .frame(width: 44, height: 44)
                VStack(alignment: .leading, spacing: 2) {
                    Text(verbatim: email.sender)
                        .font(.headline)
                    Text(verbatim: email.subject)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .accessibilityElement(children: .combine)
            }
            Text(verbatim: email.body)
                .font(.body)
                .environment(\.locale, Locale(identifier: "de_DE"))
                .lineLimit(5)
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.fill.tertiary, in: .rect(cornerRadius: Radius.option, style: .continuous))
            GlassEffectContainer {
                Button(action: onReply) {
                    Label("Reply formally", systemImage: "arrowshape.turn.up.left.fill")
                }
                .buttonStyle(.primary)
            }
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

/// A letter as a language course sets it: the length for the level, the
/// situation, the points to write about and the reminder of the greeting.
struct LetterTaskCard: View {
    let task: LetterTask
    let level: Level
    let onStart: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TopicLengthText(level: level)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.accent)
            Text(verbatim: task.situation)
                .font(.title3.weight(.semibold))
                .environment(\.locale, Locale(identifier: "de_DE"))
                .fixedSize(horizontal: false, vertical: true)
            VStack(alignment: .leading, spacing: 10) {
                ForEach(task.points, id: \.self) { point in
                    HStack(alignment: .firstTextBaseline, spacing: 10) {
                        Image(systemName: "circle")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.accent)
                            .accessibilityHidden(true)
                        Text(verbatim: point)
                            .font(.body)
                    }
                }
            }
            Text(verbatim: "Anrede und Gruß nicht vergessen.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            GlassEffectContainer {
                Button(action: onStart) {
                    Label("Start writing", systemImage: "pencil")
                }
                .buttonStyle(.primary)
            }
        }
        .padding(Spacing.cardLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

/// A German form: its title, short fields and one field for full sentences.
struct FormCard: View {
    let form: WritingForm
    let onStart: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                ScenarioArtwork(systemImage: "list.clipboard.fill", symbolSize: 20, cornerRadius: 12)
                    .frame(width: 44, height: 44)
                Text(verbatim: form.title)
                    .font(.headline)
            }
            ForEach(form.fields, id: \.self) { field in
                FormField(label: field, height: 36)
            }
            FormField(label: form.question, height: 76)
            GlassEffectContainer {
                Button(action: onStart) {
                    Label("Fill it in", systemImage: "pencil.line")
                }
                .buttonStyle(.primary)
            }
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

/// An empty field of the form with its label above it.
private struct FormField: View {
    let label: String
    let height: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(verbatim: label)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
            RoundedRectangle(cornerRadius: Radius.tile, style: .continuous)
                .fill(.fill.tertiary)
                .frame(height: height)
                .accessibilityHidden(true)
        }
    }
}
