//
//  HomeHeader.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The learner's initial in a circle, or a person symbol without a name.
struct Avatar: View {
    let name: String
    var diameter: CGFloat = 36

    var body: some View {
        Group {
            if let initial = name.trimmingCharacters(in: .whitespaces).first {
                Text(verbatim: String(initial).uppercased())
                    .font(.system(size: diameter * 0.42, weight: .semibold))
            } else {
                Image(systemName: "person.fill")
                    .font(.system(size: diameter * 0.42))
            }
        }
        .foregroundStyle(.secondary)
        .frame(width: diameter, height: diameter)
        .background(.controlFill, in: .circle)
        .accessibilityHidden(true)
    }
}

#Preview {
    HStack(spacing: 20) {
        Avatar(name: "Mara")
        Avatar(name: "")
    }
    .padding(Spacing.screen)
    .background(.screenBackground)
}
