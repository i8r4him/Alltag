//
//  AlltagAppTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
@testable import Alltag

@Suite("App")
struct AlltagAppTests {
    @Test("Tests run inside the Alltag app")
    func hostAppBundle() {
        #expect(Bundle.main.bundleIdentifier == "i8r4him.Alltag")
    }

    @Test("App targets iOS 27 or later")
    func minimumOSVersion() throws {
        let version = try #require(Bundle.main.object(forInfoDictionaryKey: "MinimumOSVersion") as? String)
        #expect(version.compare("27.0", options: .numeric) != .orderedAscending)
    }
}
