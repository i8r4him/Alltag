//
//  MockWriteListen.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 10.11.26.
//

import Foundation

/// A writing task from daily life.
struct WritingTask: Identifiable {
    enum Register { case formal, informal }

    let id = UUID()
    let title: LocalizedStringResource
    let detail: LocalizedStringResource
    let register: Register
    let minutes: Int
    let systemImage: String
}

/// A phrase for the start or end of a message, in German.
struct WritingPhrase: Identifiable {
    let id = UUID()
    let role: LocalizedStringResource
    let german: String
}

/// A short audio clip from daily life.
struct ListeningClip: Identifiable {
    let id = UUID()
    let title: LocalizedStringResource
    let detail: LocalizedStringResource
    /// The length, e.g. "0:40".
    let length: String
    let systemImage: String
}

/// Sample content for Write until writing is built.
enum MockWriting {
    static let picked = WritingTask(title: "Cancel your appointment", detail: "A short email to the dentist.",
                                    register: .formal, minutes: 4, systemImage: "square.and.pencil")

    static let tasks = [
        WritingTask(title: "Reply to your landlord", detail: "About the broken heating",
                    register: .formal, minutes: 5, systemImage: "house.fill"),
        WritingTask(title: "Tell work you're sick", detail: "A short message to your boss",
                    register: .formal, minutes: 2, systemImage: "briefcase.fill"),
        WritingTask(title: "Complain about a delivery", detail: "An email to the shop",
                    register: .formal, minutes: 5, systemImage: "shippingbox.fill"),
        WritingTask(title: "Invite your neighbour", detail: "Coffee on Sunday",
                    register: .informal, minutes: 3, systemImage: "cup.and.saucer.fill"),
        WritingTask(title: "Thank a friend", detail: "For helping with the move",
                    register: .informal, minutes: 2, systemImage: "heart.fill")
    ]

    static let formalPhrases = [
        WritingPhrase(role: "Opening", german: "Sehr geehrte Damen und Herren,"),
        WritingPhrase(role: "Asking", german: "Könnten Sie mir bitte mitteilen, …"),
        WritingPhrase(role: "Thanks", german: "Vielen Dank im Voraus."),
        WritingPhrase(role: "Closing", german: "Mit freundlichen Grüßen")
    ]

    static let informalPhrases = [
        WritingPhrase(role: "Opening", german: "Liebe Anna, / Lieber Tom,"),
        WritingPhrase(role: "Asking", german: "Hast du Lust, …?"),
        WritingPhrase(role: "Thanks", german: "Danke dir!"),
        WritingPhrase(role: "Closing", german: "Viele Grüße")
    ]
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
