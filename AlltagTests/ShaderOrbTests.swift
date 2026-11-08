//
//  ShaderOrbTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 08.11.26.
//

import Foundation
import Testing
@testable import Alltag

@Suite("Shader orb")
struct ShaderOrbTests {
    @Test("Idle is the calmest state; thinking flows fastest")
    func states() {
        let idle = OrbDynamics(state: .idle)
        let others = [VoiceOrbState.listening, .thinking, .speaking].map { OrbDynamics(state: $0, level: 0.5) }
        #expect(idle.energy == 0)
        #expect(others.allSatisfy { $0.speed > idle.speed && $0.energy > idle.energy })
        #expect(others.map(\.speed).max() == OrbDynamics(state: .thinking).speed)
    }

    @Test("Listening and speaking follow the voice level, clamped to 0…1",
          arguments: [VoiceOrbState.listening, .speaking])
    func level(state: VoiceOrbState) {
        let quiet = OrbDynamics(state: state, level: 0)
        let loud = OrbDynamics(state: state, level: 1)
        #expect(loud.energy > quiet.energy)
        #expect(OrbDynamics(state: state, level: 5) == loud)
        #expect(OrbDynamics(state: state, level: -1) == quiet)
        #expect(loud.energy <= 1)
    }

    @Test("The clock advances by elapsed time times speed")
    func clock() {
        let clock = OrbClock()
        let start = Date(timeIntervalSinceReferenceDate: 0)
        #expect(clock.advance(to: start, speed: 1) == 0)
        #expect(clock.advance(to: start.addingTimeInterval(2), speed: 0.5) == 1)
        #expect(clock.advance(to: start.addingTimeInterval(3), speed: 0) == 1)
    }
}
