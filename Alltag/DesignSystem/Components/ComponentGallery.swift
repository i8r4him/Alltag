//
//  ComponentGallery.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Shows every design-system component and its states, for checking them
/// in light and dark mode and at large text sizes.
struct ComponentGallery: View {
    @State private var level = "B1"
    @State private var filter = "All"
    @State private var reduceMotion = true
    @State private var toast: ToastMessage?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.section) {
                header
                buttons
                options
                pillsAndChips
                rows
                indicators
            }
            .padding(Spacing.screen)
        }
        .scrollIndicators(.hidden)
        .scrollEdgeEffectStyle(.soft, for: .all)
        .background(.screenBackground)
        .toast($toast)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                GlassButton(systemImage: "chevron.left", accessibilityLabel: "Back") {}
                Spacer()
                GlassButton(systemImage: "gearshape", accessibilityLabel: "Settings") {}
            }
            Eyebrow(title: "Today's focus")
            Text("Components").textRole(.largeTitle)
            SectionHeader(title: "Coming up") {
                Label("Rehearse from your Calendar", systemImage: "calendar")
            }
        }
    }

    private var buttons: some View {
        VStack(spacing: 12) {
            Button("Continue") { toast = ToastMessage(text: "Saved to Memory") }
                .buttonStyle(.primary)
            Button("Continue") {}
                .buttonStyle(.primary)
                .disabled(true)
            HStack {
                Button("Start review") {}.buttonStyle(.primaryCompact)
                Spacer()
            }
            Button("Not sure? Find out in one question", systemImage: "bubble.left.and.text.bubble.right") {}
                .buttonStyle(.outline)
        }
    }

    private var options: some View {
        VStack(spacing: 10) {
            ForEach([("A2", "Simple everyday conversations"), ("B1", "I get by in most situations")], id: \.0) { item in
                OptionCard(title: Text(verbatim: item.0), subtitle: Text(verbatim: item.1), isSelected: level == item.0) {
                    level = item.0
                }
            }
            OptionCard(title: "Living here", subtitle: "Everyday life in Germany", systemImage: "house", isSelected: false) {}
        }
    }

    private var pillsAndChips: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Pill(title: "5 min")
                Pill(title: "New", tone: .accent)
                Pill(title: "Solved", systemImage: "checkmark", tone: .success)
                Pill(title: "Mistake", tone: .mistake)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(["All", "From your day", "Saved", "Mistakes", "Due"], id: \.self) { name in
                        Button(LocalizedStringKey(name)) { filter = name }
                            .buttonStyle(.chip(isSelected: filter == name))
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }

    private var rows: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader("Learning", style: .grouped)
            VStack(spacing: 0) {
                CardRow(title: "Language", systemImage: "character.book.closed", value: "German")
                Divider().padding(.leading, 42)
                CardRow(title: "60-second briefing", subtitle: "Your words in today's news", systemImage: "headphones",
                        symbolTint: .accentFill.opacity(AccentTint.glow), symbolForeground: .accent)
                Divider().padding(.leading, 42)
                ToggleRow(title: "Reduce motion", subtitle: "Calmer transitions", systemImage: "figure.walk.motion",
                          isOn: $reduceMotion)
            }
            .padding(.horizontal, Spacing.card)
            .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))
        }
    }

    private var indicators: some View {
        VStack(alignment: .leading, spacing: 16) {
            ProgressSegments(total: 6, completed: 3)
            HStack(spacing: 24) {
                ForEach(0...4, id: \.self) { StrengthDots(strength: $0) }
            }
            ToastView(message: ToastMessage(text: "Saved to Memory"))
        }
    }
}

#Preview("Light") {
    ComponentGallery().preferredColorScheme(.light)
}

#Preview("Dark") {
    ComponentGallery().preferredColorScheme(.dark)
}

#Preview("Largest text") {
    ComponentGallery().dynamicTypeSize(.accessibility3)
}
