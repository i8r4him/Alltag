//
//  AppTab.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 08.11.26.
//

import Foundation

/// The app's tabs. Translate is the system search tab.
enum AppTab: Hashable, CaseIterable {
    case today
    case learn
    case memory
    case translate

    /// The screen at the bottom of the tab's stack. Today shows Home.
    var root: Route? {
        switch self {
        case .today: nil
        case .learn: .learn
        case .memory: .memory()
        case .translate: .translate()
        }
    }
}

extension Route {
    /// The tab this screen is the root of, if any.
    var rootTab: AppTab? {
        switch self {
        case .learn: .learn
        case .memory: .memory
        case .translate: .translate
        default: nil
        }
    }

    /// The tab a screen opened from outside the app (Siri, Shortcuts) is pushed onto.
    var homeTab: AppTab {
        switch self {
        case .grammar, .rule, .progress: .learn
        case .memory: .memory
        case .translate: .translate
        default: .today
        }
    }
}
