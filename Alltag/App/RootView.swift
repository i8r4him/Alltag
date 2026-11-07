//
//  RootView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The app's root view. Navigation (`NavigationStack`, routes and the
/// onboarding gate) is added in #15.
struct RootView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "text.bubble")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Alltag")
                .font(.largeTitle.bold())
        }
        .padding()
    }
}

#Preview {
    RootView()
}
