//
//  ShareViewController.swift
//  AlltagShare
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI
import UIKit
import UniformTypeIdentifiers

/// "Alltag" in the share sheet: keeps the shared link in the App Group, where
/// Learn › Read finds it and opens the article with help. Nothing is loaded
/// or sent from here.
final class ShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        if let raw = UserDefaults(suiteName: ReadingInbox.group)?.string(forKey: CompanionLook.Key.palette),
           let palette = CompanionPalette(rawValue: raw) { AppTheme.shared.palette = palette }
        let panel = SharePanel(findLink: { [weak self] in await self?.sharedLink() },
                               onDone: { [weak self] in self?.extensionContext?.completeRequest(returningItems: nil) })
        let host = UIHostingController(rootView: panel)
        addChild(host)
        host.view.frame = view.bounds
        host.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(host.view)
        host.didMove(toParent: self)
    }

    /// The web link shared: a URL, or the first link in shared text.
    private func sharedLink() async -> URL? {
        let providers = (extensionContext?.inputItems as? [NSExtensionItem] ?? []).flatMap { $0.attachments ?? [] }
        for provider in providers where provider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
            if let url = try? await provider.loadItem(forTypeIdentifier: UTType.url.identifier) as? URL,
               url.scheme == "https" || url.scheme == "http" {
                return url
            }
        }
        for provider in providers where provider.hasItemConformingToTypeIdentifier(UTType.plainText.identifier) {
            if let text = try? await provider.loadItem(forTypeIdentifier: UTType.plainText.identifier) as? String,
               let url = Self.firstLink(in: text) {
                return url
            }
        }
        return nil
    }

    private static func firstLink(in text: String) -> URL? {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let range = NSRange(text.startIndex..., in: text)
        return detector?.matches(in: text, range: range).compactMap(\.url)
            .first { $0.scheme == "https" || $0.scheme == "http" }
    }
}

/// What the share sheet shows: the link is kept, and where to read it.
struct SharePanel: View {
    let findLink: () async -> URL?
    let onDone: () -> Void

    private enum Phase { case finding, saved(URL), noLink, failed }
    @State private var phase = Phase.finding
    @State private var taps = 0

    var body: some View {
        VStack(spacing: 18) {
            Spacer(minLength: 0)
            switch phase {
            case .finding:
                ProgressView()
            case .saved(let url):
                message(symbol: "checkmark.circle.fill", title: "Saved to Alltag",
                        text: "Open Alltag, then Learn › Read, to read it with help.", detail: url.host())
            case .noLink:
                message(symbol: "link.badge.plus", title: "No link to read",
                        text: "Share a web page with an article in German.", detail: nil)
            case .failed:
                message(symbol: "exclamationmark.triangle.fill", title: "Couldn’t save it",
                        text: "Open Alltag once, then try again.", detail: nil)
            }
            Spacer(minLength: 0)
            Button {
                taps += 1
                onDone()
            } label: {
                Text("Done")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.glassProminent)
            .controlSize(.large)
        }
        .padding(Spacing.screen)
        .fontDesign(.rounded)
        .tint(Color.accent)
        .background { Color.screenBackground.ignoresSafeArea() }
        .sensoryFeedback(.impact(weight: .medium), trigger: taps)
        .task {
            guard let url = await findLink() else {
                phase = .noLink
                return
            }
            do {
                try ReadingInbox.save(url)
                phase = .saved(url)
            } catch {
                phase = .failed
            }
        }
    }

    private func message(symbol: String, title: LocalizedStringKey, text: LocalizedStringKey, detail: String?) -> some View {
        VStack(spacing: 10) {
            Image(systemName: symbol)
                .font(.system(size: 52))
                .foregroundStyle(Color.accent)
                .accessibilityHidden(true)
            Text(title)
                .font(.title2.weight(.bold))
            Text(text)
                .foregroundStyle(.secondary)
            if let detail {
                Text(verbatim: detail)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
        }
        .multilineTextAlignment(.center)
    }
}
