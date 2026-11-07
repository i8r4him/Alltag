//
//  BeyondView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// Concept previews of Alltag outside the app: keyboard, select & translate,
/// Siri, widgets and Watch. Nothing here registers an extension.
struct BeyondView: View {
    @State private var toast: ToastMessage?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                concept("Keyboard") { KeyboardConcept() }
                Text("Only sees what you type in its own field — never other apps' content.")
                    .textRole(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 4)

                concept("Select & translate") { SelectTranslateConcept(toast: $toast) }
                concept("Siri") { SiriConcept() }
                concept("Widgets & Watch") { WidgetsConcept() }
            }
            .padding(.horizontal, Spacing.screen)
            .padding(.bottom, 32)
        }
        .readableContentMargins()
        .background(.screenBackground)
        .navigationTitle("Beyond the app")
        .navigationBarTitleDisplayMode(.large)
        .navigationSubtitle(Text("Concept previews. Nothing here is installed on this device yet."))
        .toast($toast)
    }

    private func concept(_ title: LocalizedStringKey, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Text(title).textRole(.cardTitle).accessibilityAddTraits(.isHeader)
                ConceptBadge()
            }
            .padding(.horizontal, 4)
            content()
        }
        .padding(.top, 14)
    }
}

/// "CONCEPT", outlined.
private struct ConceptBadge: View {
    var body: some View {
        Text("Concept")
            .textCase(.uppercase)
            .font(.system(size: 9, weight: .semibold))
            .tracking(0.6)
            .foregroundStyle(.secondary)
            .padding(.horizontal, 5)
            .padding(.vertical, 2)
            .overlay(RoundedRectangle(cornerRadius: 4).strokeBorder(.secondary.opacity(0.6), lineWidth: 0.5))
    }
}

/// The Alltag keyboard suggesting a more natural sentence.
private struct KeyboardConcept: View {
    @State private var isReplaced = false
    @State private var showsWhy = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(verbatim: isReplaced ? "Ich wohne seit drei Jahren hier." : "Ich wohne hier für drei Jahren.")
                .textRole(.bodySmall)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.surfaceSecondary, in: .rect(cornerRadius: 16, style: .continuous))
                .frame(maxWidth: .infinity, alignment: .trailing)

            if isReplaced {
                Label("Replaced · logged as a mistake to review", systemImage: "checkmark.circle.fill")
                    .textRole(.meta)
                    .foregroundStyle(.success)
            } else {
                suggestion
            }
            keys
        }
        .padding(12)
        .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))
        .animation(.default, value: isReplaced)
        .animation(.default, value: showsWhy)
        .sensoryFeedback(.success, trigger: isReplaced)
    }

    private var suggestion: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("More natural").textRole(.caption).foregroundStyle(.accent)
            Text(verbatim: "Ich wohne seit drei Jahren hier.").textRole(.bodySmall)
            if showsWhy {
                Text("„seit“ for something that began in the past and is still true. Dative plural: Jahren.")
                    .textRole(.meta)
                    .foregroundStyle(.secondary)
            }
            HStack(spacing: 8) {
                Button("Replace") { isReplaced = true }
                    .buttonStyle(.primaryCompact)
                Button("Why?") { showsWhy.toggle() }
                    .buttonStyle(.chip(isSelected: showsWhy))
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.surfaceSecondary, in: .rect(cornerRadius: Radius.option, style: .continuous))
    }

    /// Three rows of blank keys.
    private var keys: some View {
        VStack(spacing: 6) {
            keyRow(10)
            keyRow(9).padding(.horizontal, 12)
            HStack(spacing: 6) {
                key.frame(width: 44)
                key
                key.frame(width: 44)
            }
        }
        .frame(height: 96)
        .accessibilityHidden(true)
    }

    private func keyRow(_ count: Int) -> some View {
        HStack(spacing: 6) {
            ForEach(0..<count, id: \.self) { _ in key }
        }
    }

    private var key: some View {
        RoundedRectangle(cornerRadius: 5, style: .continuous).fill(.surfaceSecondary)
    }
}

/// Selecting a word in Safari and saving it for practice.
private struct SelectTranslateConcept: View {
    @Binding var toast: ToastMessage?
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<MemoryItem> { $0.word == "Kündigungsfrist" }) private var saved: [MemoryItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(Self.page)
                .textRole(.bodySmall)
                .foregroundStyle(.secondary)
                .padding(14)
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .firstTextBaseline) {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(verbatim: "die").foregroundStyle(.secondary)
                        Text(verbatim: "Kündigungsfrist")
                    }
                    .textRole(.cardTitle)
                    Spacer()
                    Text(verbatim: "Alltag").textRole(.caption).foregroundStyle(.tertiary)
                }
                Text("notice period — how long before a contract can end")
                    .textRole(.meta)
                    .foregroundStyle(.secondary)
                Button(saved.isEmpty ? "Save for practice" : "Saved", systemImage: saved.isEmpty ? "bookmark" : "checkmark") {
                    save()
                }
                .buttonStyle(.chip(isSelected: !saved.isEmpty))
                .allowsHitTesting(saved.isEmpty)
                .padding(.top, 4)
            }
            .padding(14)
            .background(.surfaceSecondary, in: .rect(cornerRadius: Radius.option, style: .continuous))
            .padding(6)
        }
        .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))
    }

    /// A German page with the selected word highlighted.
    private static var page: AttributedString {
        var text = AttributedString("Mieter sollten wissen: Die Kündigungsfrist beträgt in den meisten Fällen drei Monate …")
        if let range = text.range(of: "Kündigungsfrist") {
            text[range].backgroundColor = .accentFill.opacity(0.35)
            text[range].foregroundColor = .primary
        }
        return text
    }

    private func save() {
        modelContext.insert(MemoryItem(article: "die ", word: "Kündigungsfrist",
                                       meaning: "notice period",
                                       context: "Die Kündigungsfrist beträgt in den meisten Fällen drei Monate.",
                                       kind: .saved, source: .safari))
        toast = ToastMessage(text: "Saved to Memory")
    }
}

/// Siri phrases, each starting the matching flow in the app.
private struct SiriConcept: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        VStack(spacing: 0) {
            phrase("“Start a German speaking session.”") { appState.present(.conversation(.dentist)) }
            Divider().padding(.leading, Spacing.card)
            phrase("“Review my saved words.”") { appState.present(.activity(.recall)) }
            Divider().padding(.leading, Spacing.card)
            phrase("“Practise for two minutes.”") { appState.present(.activity(.listen)) }
        }
        .background(.surface, in: .rect(cornerRadius: Radius.innerCard, style: .continuous))
    }

    private func phrase(_ text: LocalizedStringKey, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(text).textRole(.body).italic()
                Spacer()
                Image(systemName: "play.fill").foregroundStyle(.accent).accessibilityHidden(true)
            }
            .padding(.horizontal, Spacing.card)
            .frame(minHeight: Spacing.rowMinHeight)
            .contentShape(.rect)
        }
        .buttonStyle(.card)
        .accessibilityHint(Text("Starts it in Alltag"))
    }
}

/// Word of the day and Review widgets, and the Watch 1-minute challenge.
private struct WidgetsConcept: View {
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                widget("Word of the day") {
                    Text(verbatim: "der").textRole(.meta).foregroundStyle(.secondary)
                    Text(verbatim: "Feierabend").textRole(.cardTitle)
                    Text("end of the workday").textRole(.caption).foregroundStyle(.secondary)
                }
                widget("Review") {
                    Text(6, format: .number).textRole(.largeTitle)
                    Text("ready · 3 min").textRole(.caption).foregroundStyle(.secondary)
                }
            }
            watch
        }
    }

    private func widget(_ title: LocalizedStringKey, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Eyebrow(title: title)
            Spacer(minLength: 8)
            content()
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 150, alignment: .leading)
        .background(.surface, in: .rect(cornerRadius: 22, style: .continuous))
        .accessibilityElement(children: .combine)
    }

    private var watch: some View {
        VStack(alignment: .leading, spacing: 8) {
            Eyebrow(title: "1-min challenge")
            Text("“notice period”?").textRole(.body).fontWeight(.semibold)
            HStack(spacing: 6) {
                option("Kündigungsfrist")
                option("Feierabend")
            }
        }
        .padding(14)
        .frame(width: 200, alignment: .leading)
        .background(.black, in: .rect(cornerRadius: 40, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 40, style: .continuous).strokeBorder(.gray.opacity(0.4), lineWidth: 4))
        .environment(\.colorScheme, .dark)
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("Apple Watch: 1-minute challenge"))
    }

    private func option(_ word: String) -> some View {
        Text(verbatim: word)
            .font(.caption2.weight(.semibold))
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(.white.opacity(0.14), in: .capsule)
    }
}

#Preview {
    NavigationStack { BeyondView() }
        .environment(AppState())
        .modelContainer(AlltagStore.preview)
}

#Preview("Nothing saved") {
    NavigationStack { BeyondView() }
        .environment(AppState())
        .modelContainer(try! AlltagStore.makeContainer(inMemory: true)) // swiftlint:disable:this force_try
}
