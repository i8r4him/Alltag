//
//  FieldFocusEffect.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// What happens when the learner taps a field at the top of a page ("How do
/// I say …?" on Learn, "Look up a word" in Articles): the field comes
/// forward and the rest of the page steps back, so the keyboard doesn't just
/// pop up on its own. Tapping the page behind puts the keyboard away.
///
/// The field calls `.fieldFocusEffect(isActive:)` and the rest of the page
/// `.fieldFocusBackdrop(isActive:onTapOutside:)`.
///
/// TEMPORARY (#397): the effects to choose from, behind the ‹ n / N ›
/// switcher. Once the maintainer has picked one, the others, the switcher
/// and the stored choice go.
enum FieldFocusEffect: Int, CaseIterable {
    /// The page behind goes soft and pale; the field grows a little.
    case frost
    /// The page behind darkens; the field glows in the theme colour.
    case spotlight
    /// The field rises with a soft shadow; the page behind only fades a bit.
    case lift
    /// A frosted glass pane rises over the page behind.
    case veil
    /// The page behind sinks back and blurs a little, like a card behind a sheet.
    case depth

    /// Where the choice is kept, so both fields show the same effect.
    static let storageKey = "fieldFocusEffect"

    /// The name on the switcher. Temporary, so not in the String Catalog.
    var name: String {
        switch self {
        case .frost: "Frost"
        case .spotlight: "Spotlight"
        case .lift: "Lift"
        case .veil: "Veil"
        case .depth: "Depth"
        }
    }

    /// The animation for the field and the page behind.
    static func animation(reduceMotion: Bool) -> Animation {
        reduceMotion ? .easeInOut(duration: 0.2) : Motion.easeOut(duration: 0.35)
    }
}

extension View {
    /// The field that the learner is typing in: it comes forward while active.
    func fieldFocusEffect(isActive: Bool) -> some View {
        modifier(FieldFocusField(isActive: isActive))
    }

    /// Everything on the page except the field: it steps back while the field
    /// is active, and a tap on it calls `onTapOutside` (put the keyboard away)
    /// instead of reaching what is under it. Scrolling still works.
    func fieldFocusBackdrop(isActive: Bool, onTapOutside: @escaping () -> Void) -> some View {
        modifier(FieldFocusBackdrop(isActive: isActive, onTapOutside: onTapOutside))
    }
}

private struct FieldFocusField: ViewModifier {
    let isActive: Bool
    @AppStorage(FieldFocusEffect.storageKey) private var effectRaw = 0
    @Environment(\.reducesMotion) private var reduceMotion

    private var effect: FieldFocusEffect { FieldFocusEffect(rawValue: effectRaw) ?? .frost }
    private var moves: Bool { isActive && !reduceMotion }

    func body(content: Content) -> some View {
        content
            .scaleEffect(moves ? scale : 1)
            .offset(y: moves && effect == .lift ? -4 : 0)
            .shadow(color: isActive ? shadowColour : .clear, radius: shadowRadius, y: effect == .lift ? 10 : 0)
            .animation(FieldFocusEffect.animation(reduceMotion: reduceMotion), value: isActive)
            .animation(FieldFocusEffect.animation(reduceMotion: reduceMotion), value: effectRaw)
    }

    private var scale: CGFloat {
        switch effect {
        case .frost, .depth: 1.02
        case .lift: 1.04
        case .spotlight, .veil: 1
        }
    }

    private var shadowColour: Color {
        switch effect {
        case .spotlight: .accentFill.opacity(0.45)
        case .veil: .accentFill.opacity(0.25)
        case .lift: .black.opacity(0.35)
        case .frost, .depth: .clear
        }
    }

    private var shadowRadius: CGFloat {
        switch effect {
        case .spotlight: 22
        case .lift: 18
        default: 14
        }
    }
}

private struct FieldFocusBackdrop: ViewModifier {
    let isActive: Bool
    let onTapOutside: () -> Void
    @AppStorage(FieldFocusEffect.storageKey) private var effectRaw = 0
    @Environment(\.reducesMotion) private var reduceMotion

    private var effect: FieldFocusEffect { FieldFocusEffect(rawValue: effectRaw) ?? .frost }

    func body(content: Content) -> some View {
        content
            .blur(radius: isActive ? blur : 0)
            .opacity(isActive ? opacity : 1)
            .scaleEffect(isActive && effect == .depth && !reduceMotion ? 0.94 : 1, anchor: .top)
            .overlay(alignment: .top) {
                if isActive && effect == .veil {
                    UnevenRoundedRectangle(topLeadingRadius: Radius.hero, topTrailingRadius: Radius.hero, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .padding(.horizontal, -8)
                        .transition(reduceMotion ? .opacity : .offset(y: 40).combined(with: .opacity))
                }
            }
            .allowsHitTesting(!isActive)
            .overlay {
                if isActive {
                    Color.clear
                        .contentShape(.rect)
                        .onTapGesture(perform: onTapOutside)
                        .accessibilityHidden(true)
                }
            }
            .animation(FieldFocusEffect.animation(reduceMotion: reduceMotion), value: isActive)
    }

    private var blur: CGFloat {
        switch effect {
        case .frost: 12
        case .depth: 4
        case .spotlight, .lift, .veil: 0
        }
    }

    private var opacity: Double {
        switch effect {
        case .frost: 0.55
        case .spotlight: 0.2
        case .lift: 0.75
        case .veil: 1
        case .depth: 0.6
        }
    }
}

/// TEMPORARY (#397): the ‹ n / N › glass switcher between the effects. Goes
/// once the maintainer has picked one.
struct FieldFocusEffectSwitcher: View {
    @AppStorage(FieldFocusEffect.storageKey) private var effectRaw = 0

    private var count: Int { FieldFocusEffect.allCases.count }
    private var effect: FieldFocusEffect { FieldFocusEffect(rawValue: effectRaw) ?? .frost }

    var body: some View {
        GlassEffectContainer(spacing: 8) {
            HStack(spacing: 8) {
                step(by: -1, systemImage: "chevron.left", label: "Previous effect")
                Text(verbatim: "\(effect.name) · \(effect.rawValue + 1) / \(count)")
                    .font(.subheadline.weight(.semibold))
                    .monospacedDigit()
                    .contentTransition(.numericText())
                    .padding(.horizontal, 16)
                    .frame(height: 44)
                    .glassEffect(.regular, in: .capsule)
                step(by: 1, systemImage: "chevron.right", label: "Next effect")
            }
        }
        .fontDesign(.rounded)
        .sensoryFeedback(.selection, trigger: effectRaw)
        .animation(.snappy, value: effectRaw)
    }

    private func step(by delta: Int, systemImage: String, label: String) -> some View {
        Button {
            effectRaw = (effect.rawValue + delta + count) % count
        } label: {
            Image(systemName: systemImage)
                .font(.subheadline.weight(.bold))
                .frame(width: 44, height: 44)
        }
        .buttonStyle(.plain)
        .glassEffect(.regular.interactive(), in: .circle)
        .accessibilityLabel(Text(verbatim: label))
    }
}
