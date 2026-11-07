//
//  PlaceholderScreens.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Stand-in for a pushed screen that hasn't been built yet.
struct PlaceholderScreen: View {
    let title: LocalizedStringResource
    /// GitHub issue that builds the real screen.
    let issue: Int

    var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: "hammer")
        } description: {
            Text("This screen is built in #\(issue).")
        }
        .background(.screenBackground)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.large)
    }
}
