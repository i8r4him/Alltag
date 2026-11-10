//
//  AppTab.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 08.11.26.
//

import Foundation

/// The app's three tabs.
enum AppTab: Hashable, CaseIterable {
    case today
    case learn
    case memory

    /// The screen at the bottom of the tab's stack. Today shows Home.
    var root: Route? {
        switch self {
        case .today: nil
        case .learn: .learn
        case .memory: .memory()
        }
    }
}

extension Route {
    /// The tab this screen is the root of, if any.
    var rootTab: AppTab? {
        switch self {
        case .learn: .learn
        case .memory: .memory
        default: nil
        }
    }

    /// The tab a screen opened from outside the app (Siri, Shortcuts) is pushed onto.
    var homeTab: AppTab {
        switch self {
        case .read, .write, .listen, .grammar, .rule, .progress: .learn
        case .memory: .memory
        default: .today
        }
    }
}
