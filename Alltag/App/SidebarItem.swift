//
//  SidebarItem.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The sections in the unfolded foldable's sidebar.
///
/// In a split view the selected section is the root of the detail column.
/// `AppState.path` stays the same in both layouts: its first route is the
/// section, the rest is pushed on top. Resizing between compact and regular
/// width keeps the learner where they were.
enum SidebarItem: Hashable, CaseIterable, Identifiable {
    case home, translate, memory, learn, grammar, progress, profile, settings

    var id: Self { self }

    static let main: [SidebarItem] = [.home, .translate, .memory, .learn, .grammar, .progress]
    static let personal: [SidebarItem] = [.profile, .settings]

    /// The section a route belongs to, if it is one.
    init?(route: Route) {
        switch route {
        case .translate: self = .translate
        case .memory: self = .memory
        case .learn: self = .learn
        case .grammar: self = .grammar
        case .progress: self = .progress
        case .profile: self = .profile
        case .settings: self = .settings
        default: return nil
        }
    }

    /// The route that opens this section; Home is the empty path.
    var route: Route? {
        switch self {
        case .home: nil
        case .translate: .translate()
        case .memory: .memory()
        case .learn: .learn
        case .grammar: .grammar
        case .progress: .progress
        case .profile: .profile
        case .settings: .settings
        }
    }

    var title: LocalizedStringResource {
        switch self {
        case .home: "Today"
        case .translate: "Translate"
        case .memory: "Memory"
        case .learn: "Learn"
        case .grammar: "Grammar"
        case .progress: "Progress"
        case .profile: "Profile"
        case .settings: "Settings"
        }
    }

    var systemImage: String {
        switch self {
        case .home: "sun.max"
        case .translate: "translate"
        case .memory: "book"
        case .learn: "bolt"
        case .grammar: "text.badge.checkmark"
        case .progress: "chart.line.uptrend.xyaxis"
        case .profile: "person.crop.circle"
        case .settings: "gearshape"
        }
    }

    // MARK: Path in a split view

    /// The detail column's root: the path's first route when it is a section.
    static func root(of path: [Route]) -> Route? {
        guard let first = path.first, SidebarItem(route: first) != nil else { return nil }
        return first
    }

    /// The selected section for `path`.
    static func selection(for path: [Route]) -> SidebarItem {
        root(of: path).flatMap { SidebarItem(route: $0) } ?? .home
    }

    /// What is pushed on top of the root in the detail column.
    static func detailPath(of path: [Route]) -> [Route] {
        root(of: path) == nil ? path : Array(path.dropFirst())
    }

    /// The full path for a root and what is pushed on top of it.
    static func path(root: Route?, detail: [Route]) -> [Route] {
        (root.map { [$0] } ?? []) + detail
    }
}
