//
//  OnscreenEntity.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import AppIntents
import SwiftUI

extension View {
    /// Tells Siri and Apple Intelligence which entity is on screen, so a
    /// request like "explain this" or "add this to my notes" refers to it.
    func onscreenEntity<Entity: AppEntity>(_ entity: Entity?, title: String) -> some View {
        userActivity("i8r4him.Alltag.viewing", isActive: entity != nil) { activity in
            guard let entity else { return }
            activity.title = title
            activity.appEntityIdentifier = EntityIdentifier(for: entity)
        }
    }
}
