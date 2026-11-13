//
//  ArticleLookupCard.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 13.11.26.
//

import SwiftData
import SwiftUI

/// "Look up a word": a noun or its meaning in the field, and its article,
/// plural, meaning and an example in a glass card below, to save to Memory.
struct ArticleLookupCard: View {
    let level: Level
    @Environment(\.services) private var services
    @Environment(\.modelContext) private var context
    @FocusState private var isFieldFocused: Bool
    @State private var text = ""
    @State private var answer: ArticleAnswer?
    @State private var isLookingUp = false
    @State private var notice: ToastMessage?
    @State private var saved = Set<String>()
    @State private var task: Task<Void, Never>?

    var body: some View {
        VStack(spacing: Spacing.grid) {
            field
            if isLookingUp {
                Label {
                    Text("Looking it up…")
                } icon: {
                    ProgressView()
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .transition(.opacity)
            }
            if let answer {
                if !answer.note.isEmpty {
                    Text(verbatim: answer.note)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 4)
                }
                ForEach(answer.nouns) { noun in
                    ArticleResultCard(noun: noun, isSaved: saved.contains(noun.id)) { save(noun) }
                }
            }
        }
        .animation(.easeOut(duration: 0.25), value: answer?.nouns)
        .animation(.easeOut(duration: 0.25), value: isLookingUp)
        .toast($notice)
        .onChange(of: text) { _, _ in
            task?.cancel()
            isLookingUp = false
            answer = nil
            saved = []
        }
        .onDisappear { task?.cancel() }
    }

    /// The field, in the look of "How do I say …?": a glass capsule with the symbol on the left.
    private var field: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.title3)
                .foregroundStyle(.accent)
                .accessibilityHidden(true)
            TextField("A noun, or what it means", text: $text)
                .font(.title3)
                .focused($isFieldFocused)
                .submitLabel(.search)
                .autocorrectionDisabled()
                .onSubmit(lookUp)
            if !text.isEmpty {
                Button("Clear", systemImage: "xmark.circle.fill") { text = "" }
                    .labelStyle(.iconOnly)
                    .foregroundStyle(.secondary)
                    .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 60)
        .glassEffect(.regular.interactive(), in: .capsule)
    }

    private func lookUp() {
        let word = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !word.isEmpty, !isLookingUp else { return }
        isFieldFocused = false
        isLookingUp = true
        task = Task {
            do {
                let result = try await services.articles.request(word: word, level: level, excluding: [])
                guard !Task.isCancelled else { return }
                answer = result
            } catch {
                guard !Task.isCancelled else { return }
                notice = ToastMessage(text: "Couldn’t look it up. Check your connection and that Alltag may use the cloud.",
                                      systemImage: "wifi.exclamationmark")
            }
            isLookingUp = false
        }
    }

    private func save(_ noun: Noun) {
        do {
            try ArticleMemory.save(noun, in: context)
            saved.insert(noun.id)
            notice = ToastMessage(text: "Saved to Memory")
        } catch {
            notice = ToastMessage(text: "Couldn’t save it. Try again.", systemImage: "exclamationmark.triangle")
        }
    }
}

/// One meaning of the looked-up noun, with "Save to Memory".
private struct ArticleResultCard: View {
    let noun: Noun
    let isSaved: Bool
    let onSave: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            ArticleNounDetail(noun: noun)
            Button(action: onSave) {
                if isSaved {
                    Label("Saved", systemImage: "checkmark")
                } else {
                    Label("Save to Memory", systemImage: "bookmark")
                }
            }
            .buttonStyle(.primaryCompact)
            .disabled(isSaved)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

/// A noun with its article in the theme colour, its meaning, plural, note and example.
struct ArticleNounDetail: View {
    let noun: Noun

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(verbatim: "\(noun.article.rawValue) \(noun.word)")
                .font(.title2.weight(.bold))
                .foregroundStyle(.accent)
            Text(verbatim: noun.meaning)
                .font(.title3)
            if noun.hasPlural {
                Text("Plural: die \(noun.plural)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            if !noun.explanation.isEmpty {
                Text(verbatim: noun.explanation)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            }
            if !noun.example.isEmpty {
                Text(verbatim: noun.example)
                    .font(.body.italic())
                    .padding(.top, 4)
            }
        }
        .environment(\.locale, Locale(identifier: "de"))
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    ScrollView {
        ArticleLookupCard(level: .a2)
            .padding(Spacing.screen)
    }
    .skyBackground()
    .fontDesign(.rounded)
    .modelContainer(AlltagStore.preview)
}
