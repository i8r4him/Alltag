//
//  ReadView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 10.11.26.
//

import SwiftUI

/// Learn › Read: the letter scan, your reading list from Safari, a text picked
/// for you and more texts from daily life. A text opens in the reader, zooming
/// out of its card; the scan and the reading list are still UI only, with mock content.
struct ReadView: View {
    @State private var taps = 0
    /// The text open in the reader, by its id.
    @State private var opened: String?
    @Namespace private var zoom

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.section) {
                ScanLetterCard(action: tapped)
                ReadingListSection(articles: MockReading.articles, onOpen: { _ in tapped() })
                PickedTextCard(text: MockReading.picked, zoom: zoom) { open(MockReading.picked) }
                MoreTextsSection(texts: MockReading.more, zoom: zoom, onOpen: open)
            }
            .padding(.horizontal, Spacing.screen)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .fontDesign(.rounded)
        .readableContentMargins()
        .skyBackground()
        .navigationTitle("Read")
        .toolbarTitleDisplayMode(.inlineLarge)
        .scrollEdgeEffectStyle(.soft, for: .all)
        .sensoryFeedback(.impact(weight: .medium), trigger: taps)
        .navigationDestination(item: $opened) { id in
            if let text = MockReading.text(id: id) {
                ReaderView(text: text)
                    .navigationTransition(.zoom(sourceID: id, in: zoom))
            }
        }
    }

    private func open(_ text: ReadingText) {
        taps += 1
        opened = text.id
    }

    /// The scan and the reading list come later; for now a tap only gives feedback.
    private func tapped() {
        taps += 1
    }
}

/// "Got a letter?": scan a real letter and have it explained.
private struct ScanLetterCard: View {
    let action: () -> Void

    var body: some View {
        VStack(spacing: 18) {
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Got a letter?")
                        .font(.title3.weight(.semibold))
                    Text("Scan it, and Alltag explains it simply.")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
                ScenarioArtwork(systemImage: "doc.viewfinder")
                    .frame(width: 88, height: 88)
            }
            Button(action: action) {
                Label("Scan a letter", systemImage: "camera.viewfinder")
            }
            .buttonStyle(.primary)
        }
        .padding(Spacing.cardLarge)
        .learnSurface()
    }
}

/// "Your reading list": articles you shared from Safari.
private struct ReadingListSection: View {
    let articles: [SavedArticle]
    let onOpen: (SavedArticle) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text("Your reading list")
                    .textRole(.sectionHeader)
                Spacer()
                Label("From Safari", systemImage: "safari")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 4)

            VStack(spacing: 0) {
                ForEach(Array(articles.enumerated()), id: \.element.id) { index, article in
                    if index > 0 { Divider().padding(.leading, 82) }
                    Button { onOpen(article) } label: {
                        HStack(spacing: 14) {
                            Text(verbatim: article.site.prefix(1).uppercased())
                                .font(.title2.weight(.bold))
                                .foregroundStyle(.accent)
                                .frame(width: 52, height: 52)
                                .background(.accent.opacity(0.14),
                                            in: .rect(cornerRadius: 14, style: .continuous))
                                .accessibilityHidden(true)
                            VStack(alignment: .leading, spacing: 3) {
                                Text(verbatim: article.title)
                                    .font(.headline)
                                    .lineLimit(2)
                                Text("\(Text(verbatim: article.site)) · \(article.level) · \(article.minutes) min")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Image(systemName: "chevron.right")
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(.tertiary)
                                .accessibilityHidden(true)
                        }
                        .multilineTextAlignment(.leading)
                        .padding(Spacing.card)
                        .contentShape(.rect)
                    }
                    .buttonStyle(.plain)
                    .accessibilityElement(children: .combine)
                }
            }
            .learnSurface(radius: Radius.card)
        }
    }
}

/// One text picked for you, in the Focus card's layout.
private struct PickedTextCard: View {
    let text: ReadingText
    let zoom: Namespace.ID
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Picked for you")
                .textRole(.sectionHeader)
                .padding(.horizontal, 4)
            VStack(spacing: 18) {
                HStack(alignment: .center, spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(text.title)
                            .font(.title3.weight(.semibold))
                            .fixedSize(horizontal: false, vertical: true)
                        Text(text.detail)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityElement(children: .combine)
                    ScenarioArtwork(systemImage: text.systemImage)
                        .frame(width: 88, height: 88)
                }
                Button(action: action) {
                    Label("Start reading · \(text.minutes) min", systemImage: "book.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: 34)
                }
                .buttonStyle(.glass)
            }
            .padding(Spacing.cardLarge)
            .learnSurface()
            .matchedTransitionSource(id: text.id, in: zoom)
        }
    }
}

/// "From daily life": more letters, notices and forms.
private struct MoreTextsSection: View {
    let texts: [ReadingText]
    let zoom: Namespace.ID
    let onOpen: (ReadingText) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("From daily life")
                .textRole(.sectionHeader)
                .padding(.horizontal, 4)
            VStack(spacing: 0) {
                ForEach(Array(texts.enumerated()), id: \.element.id) { index, text in
                    if index > 0 { Divider().padding(.leading, 82) }
                    Button { onOpen(text) } label: {
                        HStack(spacing: 14) {
                            ScenarioArtwork(systemImage: text.systemImage, symbolSize: 22, cornerRadius: 12)
                                .frame(width: 52, height: 52)
                            VStack(alignment: .leading, spacing: 3) {
                                Text(text.title)
                                    .font(.headline)
                                Text("\(text.level) · \(text.minutes) min")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Image(systemName: "chevron.right")
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(.tertiary)
                                .accessibilityHidden(true)
                        }
                        .multilineTextAlignment(.leading)
                        .padding(Spacing.card)
                        .contentShape(.rect)
                    }
                    .buttonStyle(.plain)
                    .accessibilityElement(children: .combine)
                    .matchedTransitionSource(id: text.id, in: zoom)
                }
            }
            .learnSurface(radius: Radius.card)
        }
    }
}

#Preview {
    NavigationStack { ReadView() }
        .modelContainer(AlltagStore.preview)
}
