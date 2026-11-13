//
//  TranslationProvider.swift
//  AlltagTranslation
//
//  Created by Ibrahim Abdullah on 13.11.26.
//

import ExtensionKit
import SwiftUI
import TranslationUIProvider

/// The system entry point for selected text. The translation panel follows in #246.
@main
final class AlltagTranslationExtension: TranslationUIProviderExtension {
    required init() {}

    var body: some TranslationUIProviderExtensionScene {
        TranslationUIProviderSelectedTextScene { context in
            VStack(alignment: .leading, spacing: 16) {
                Label("Alltag", systemImage: "translate")
                    .font(.headline)
                Text(context.inputText ?? AttributedString(""))
                    .textSelection(.enabled)
                Text("The translation panel is being prepared. Use Translate in Alltag for now.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .fontDesign(.rounded)
            .padding()
        }
    }
}
