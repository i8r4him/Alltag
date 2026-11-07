//
//  SmartBarTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
@testable import Alltag

@Suite("Smart Bar")
@MainActor
struct SmartBarTests {
    static let translatingContexts: [SmartBarContext] = [.home, .learn, .progress, .grammar]

    @Test("Sending text opens Translate with the text", arguments: translatingContexts)
    func submitTranslates(context: SmartBarContext) {
        #expect(SmartBarRouting.destination(for: .submit("  Where is the station? "), in: context)
                == .push(.translate(text: "Where is the station?")))
    }

    @Test("Sending text on Memory filters the list instead")
    func submitSearchesInMemory() {
        #expect(SmartBarRouting.destination(for: .submit("Termin "), in: .memory) == .search("Termin"))
    }

    @Test("The mic and Practise speaking start today's conversation",
          arguments: [SmartBarAction.speak, .practiseSpeakingChip])
    func speakStartsConversation(action: SmartBarAction) {
        #expect(SmartBarRouting.destination(for: action, in: .home) == .present(.conversation(.dentist)))
    }

    @Test("Fix a mistake and Review words open their activities")
    func chipsOpenActivities() {
        #expect(SmartBarRouting.destination(for: .fixMistakeChip, in: .home) == .present(.activity(.mistakes)))
        #expect(SmartBarRouting.destination(for: .reviewWordsChip, in: .home) == .present(.activity(.recall)))
    }

    @Test("The Translate chip opens Translate with any typed text, or empty")
    func translateChip() {
        #expect(SmartBarRouting.destination(for: .translateChip("Feierabend"), in: .memory)
                == .push(.translate(text: "Feierabend")))
        #expect(SmartBarRouting.destination(for: .translateChip("   "), in: .home) == .push(.translate(text: nil)))
    }

    @Test("Each screen has its own placeholder")
    func placeholders() {
        #expect(String(localized: SmartBarContext.home.placeholder) == "Ask, translate or practise anything…")
        #expect(String(localized: SmartBarContext.memory.placeholder) == "Find or add a word…")
        #expect(String(localized: SmartBarContext.learn.placeholder) == "Ask for a 2-minute challenge…")
        #expect(String(localized: SmartBarContext.progress.placeholder) == "Ask about your progress…")
    }

    @Test("The bar appears on Memory, Learn, Progress and Grammar only")
    func routesWithBar() {
        let withBar: [Route] = [.memory, .learn, .progress, .grammar]
        let without: [Route] = [.translate(), .rule(id: "weil"), .profile, .settings, .beyond, .debrief, .briefing]
        #expect(withBar.allSatisfy { $0.smartBarContext != nil })
        #expect(without.allSatisfy { $0.smartBarContext == nil })
    }
}
