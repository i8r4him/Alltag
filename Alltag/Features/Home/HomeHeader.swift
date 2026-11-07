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

/// "Good evening, Mara." and what happened today.
struct HomeGreetingView: View {
    let name: String
    let newWords: Int
    var date: Date = .now

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(HomeGreeting.title(for: HomeGreeting.PartOfDay(date: date), name: name))
                .textRole(.largeTitle)
                .accessibilityAddTraits(.isHeader)
            subtitle
                .textRole(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var subtitle: Text {
        if newWords > 0 {
            let words = Text("^[\(newWords) new word](inflect: true)").bold().foregroundStyle(.primary)
            let safari = Text("\(Image(systemName: "safari")) Safari").bold().foregroundStyle(.primary)
            return Text("Ready for your next step? You picked up \(words) while reading in \(safari) today.")
        }
        return Text("Ready for your next step?")
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 20) {
        Avatar(name: "Mara")
        HomeGreetingView(name: "Mara", newWords: 3)
        HomeGreetingView(name: "Mara", newWords: 1)
        HomeGreetingView(name: "", newWords: 0)
    }
    .padding(Spacing.screen)
    .background(.screenBackground)
}
