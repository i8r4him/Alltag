//
//  MockWriteListen.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 10.11.26.
//

import Foundation

/// A short audio clip from daily life.
struct ListeningClip: Identifiable {
    let id = UUID()
    let title: LocalizedStringResource
    let detail: LocalizedStringResource
    /// The length, e.g. "0:40".
    let length: String
    let systemImage: String
}

/// Sample content for Listen until listening is built.
enum MockListening {
    static let picked = ListeningClip(title: "Platform change in Munich", detail: "For your trip on Friday.",
                                      length: "1:00", systemImage: "tram.fill")

    static let clips = [
        ListeningClip(title: "A voicemail from the doctor", detail: "Your test results",
                      length: "0:40", systemImage: "phone.fill"),
        ListeningClip(title: "At the supermarket", detail: "An announcement",
                      length: "0:25", systemImage: "cart.fill"),
        ListeningClip(title: "The weather on the radio", detail: "The weekend",
                      length: "1:10", systemImage: "cloud.sun.fill"),
        ListeningClip(title: "A parcel delivery call", detail: "Where to leave it",
                      length: "0:50", systemImage: "shippingbox.fill"),
        ListeningClip(title: "On hold at the Bürgeramt", detail: "Music and a message",
                      length: "0:35", systemImage: "building.columns.fill")
    ]
}
