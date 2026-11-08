//
//  LitCard.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 08.11.26.
//

import SwiftUI

/// A dark card lit softly from above, with a rim that catches the light.
struct LitCardBackground: View {
    var cornerRadius: CGFloat = Radius.hero

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        shape
            // 1. Dark base.
            .fill(.surface)
            // 2. Soft light from the top.
            .overlay {
                RadialGradient(colors: [.white.opacity(0.13), .clear],
                               center: UnitPoint(x: 0.35, y: 0),
                               startRadius: 0, endRadius: 220)
                    .clipShape(shape)
            }
            // 3. Rim: bright at the top, fading towards the bottom.
            .overlay {
                shape.strokeBorder(
                    LinearGradient(colors: [.white.opacity(0.22), .white.opacity(0.04)],
                                   startPoint: .top, endPoint: .bottom),
                    lineWidth: 1)
            }
    }
}

extension View {
    /// Puts the lit card background behind the view.
    func litCard(cornerRadius: CGFloat = Radius.hero) -> some View {
        background(LitCardBackground(cornerRadius: cornerRadius))
    }
}

#Preview {
    VStack(alignment: .leading) {
        Image(systemName: "calendar").font(.largeTitle)
        Spacer()
        Text(verbatim: "Dentist").font(.title2.bold())
    }
    .padding(20)
    .frame(width: 196, height: 196, alignment: .leading)
    .litCard()
    .padding()
    .background(.screenBackground)
}
