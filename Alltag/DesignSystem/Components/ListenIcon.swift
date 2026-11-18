//
//  ListenIcon.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The speaker on a Listen button. While the natural voice for `text` is still being made (a new
/// sentence takes a few seconds the first time), a small spinner stands in its place, so the tap
/// clearly did something. Style it like an `Image`; the spinner keeps the icon's size.
struct ListenIcon: View {
    let text: String
    var systemImage = "speaker.wave.2.fill"

    @Environment(\.services) private var services

    var body: some View {
        let isPreparing = services.voice.preparing == text
        Image(systemName: systemImage)
            .opacity(isPreparing ? 0 : 1)
            .overlay {
                if isPreparing {
                    ProgressView()
                        .controlSize(.small)
                        .tint(.secondary)
                        .transition(.opacity)
                }
            }
            .animation(.easeOut(duration: 0.15), value: isPreparing)
            .accessibilityValue(isPreparing ? Text("Loading") : Text(verbatim: ""))
    }
}
