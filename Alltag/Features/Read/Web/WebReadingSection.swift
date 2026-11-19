//
//  WebReadingSection.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Read's "Read from the web": any German article the learner shares to
/// Alltag or pastes, the articles they kept, and sites to start from at their level.
struct WebReadingSection: View {
    let level: Level
    let saved: [WebArticle]
    /// Links shared to Alltag from another app, not read yet.
    let shared: [URL]
    let onOpen: (WebSource) -> Void

    @Environment(\.openURL) private var openURL
    @State private var siteTaps = 0

    var body: some View {
        LearnSection(title: "Read from the web") {
            VStack(alignment: .leading, spacing: 14) {
                Text("Read any German article here: share it to Alltag from Safari, or copy its link and paste it.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 4)
                PasteButton(payloadType: URL.self) { urls in
                    guard let url = urls.first else { return }
                    Task { @MainActor in onOpen(.link(url)) }
                }
                .buttonBorderShape(.capsule)
                .labelStyle(.titleAndIcon)
                .frame(maxWidth: .infinity)
                if !shared.isEmpty {
                    sharedLinks
                }
                if !saved.isEmpty {
                    savedArticles
                }
                sites
            }
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: siteTaps)
    }

    private var sharedLinks: some View {
        VStack(alignment: .leading, spacing: 8) {
            heading("Shared to Alltag")
            WriteGlassList {
                ForEach(shared.prefix(5), id: \.self) { url in
                    LearnRow(systemImage: "square.and.arrow.down.fill", title: Text(verbatim: WebArticles.name(of: url)),
                             detail: Text(verbatim: url.host() ?? ""), action: { onOpen(.link(url)) },
                             trailing: { LearnChevron() })
                }
            }
        }
    }

    private func heading(_ title: LocalizedStringKey) -> some View {
        Text(title)
            .font(.footnote.weight(.heavy))
            .textCase(.uppercase)
            .foregroundStyle(.secondary)
            .padding(.horizontal, 4)
    }

    private var savedArticles: some View {
        VStack(alignment: .leading, spacing: 8) {
            heading("Your articles")
            WriteGlassList {
                ForEach(saved.prefix(5), id: \.url) { article in
                    LearnRow(systemImage: "globe", title: Text(verbatim: article.title),
                             detail: Text(verbatim: article.site), action: { onOpen(.saved(article)) },
                             trailing: { LearnChevron() })
                }
            }
        }
    }

    private var sites: some View {
        VStack(alignment: .leading, spacing: 8) {
            heading("Good for \(level.title)")
            WriteGlassList {
                ForEach(WebReadingSite.sites(for: level)) { site in
                    LearnRow(systemImage: site.systemImage, title: Text(verbatim: site.name),
                             detail: Text(site.about),
                             action: {
                                 siteTaps += 1
                                 openURL(site.url)
                             },
                             trailing: {
                                 Image(systemName: "arrow.up.right")
                                     .font(.subheadline.weight(.semibold))
                                     .foregroundStyle(.secondary)
                                     .accessibilityHidden(true)
                             })
                }
            }
        }
    }
}
