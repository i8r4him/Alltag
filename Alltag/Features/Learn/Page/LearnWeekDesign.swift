//
//  LearnWeekDesign.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// Page design 4, "Woche": the learner's week first (a tick for every day
/// they practised, and the streak), then today's lesson as cards to swipe
/// through, and the parts of Learn as rings like the Apple Watch's.
struct LearnWeekDesign: View {
    let content: LearnPageContent

    @Query private var practice: [PracticeSession]
    @Query private var solved: [SolvedRule]
    @Query(filter: #Predicate<SessionRecord> { $0.kindRaw == "reading" || $0.kindRaw == "writing" })
    private var sessions: [SessionRecord]

    var body: some View {
        let activity = practice.map(\.date) + solved.map(\.solvedAt) + sessions.map(\.date)
        let streak = Streak.days(activity: activity)
        VStack(alignment: .leading, spacing: Spacing.section) {
            VStack(alignment: .leading, spacing: 12) {
                LearnSectionTitle(title: Text(verbatim: "Diese Woche"),
                                  note: streak > 0 ? Text("🔥 ^[\(streak) day](inflect: true)") : nil)
                WeekStrip(days: Streak.week(activity: activity))
            }
            if !content.steps.isEmpty {
                LessonCardStack(content: content)
            }
            VStack(alignment: .leading, spacing: 12) {
                LearnSectionTitle(title: Text("Your rings"))
                GlassEffectContainer(spacing: 0) {
                    HStack(alignment: .top, spacing: 0) {
                        ForEach(content.overview.doors) { part in
                            PartRingButton(part: part) { content.openPart(part.kind) }
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
        }
    }
}

/// The last seven days on a glass strip, today on the right, a tick on each day practised.
private struct WeekStrip: View {
    let days: [StreakDay]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(days) { day in
                let isToday = Calendar.current.isDateInToday(day.date)
                VStack(spacing: 6) {
                    Text(verbatim: day.date.german(.dateTime.weekday(.short)))
                        .font(.footnote.weight(.bold))
                        .foregroundStyle(isToday ? HierarchicalShapeStyle.primary : HierarchicalShapeStyle.secondary)
                    ZStack {
                        Circle()
                            .fill(day.practised ? AnyShapeStyle(.accentFill) : AnyShapeStyle(Color.clear))
                        Circle()
                            .strokeBorder(isToday ? AnyShapeStyle(.accentFill) : AnyShapeStyle(.controlFill),
                                          lineWidth: 2)
                        if day.practised {
                            Image(systemName: "checkmark")
                                .font(.footnote.weight(.black))
                                .foregroundStyle(.onAccent)
                        } else if isToday {
                            Text(verbatim: day.date.formatted(.dateTime.day()))
                                .font(.footnote.weight(.bold))
                        }
                    }
                    .frame(width: 34, height: 34)
                    .shadow(color: isToday ? Color.accentFill.opacity(0.6) : .clear, radius: 8)
                }
                .frame(maxWidth: .infinity)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text(day.date, format: .dateTime.weekday(.wide)))
                .accessibilityValue(day.practised ? Text("Practised") : Text(verbatim: ""))
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .glassEffect(.regular, in: .rect(cornerRadius: 26, style: .continuous))
    }
}

/// Today's lesson as a row of cards, one per step, swiped like a stack: the
/// cards to the side sit smaller and dimmer, and the row opens on the next step.
private struct LessonCardStack: View {
    let content: LearnPageContent

    @State private var position: LessonPart?

    var body: some View {
        let steps = content.steps
        let current = DailyLesson.current(in: steps)
        VStack(spacing: 14) {
            ScrollView(.horizontal) {
                HStack(alignment: .top, spacing: Spacing.grid) {
                    ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                        StackCard(step: step, number: index + 1, count: steps.count) { content.open(step.target) }
                            .containerRelativeFrame(.horizontal) { width, _ in width * 0.86 }
                            .matchedTransitionSource(id: step.target, in: content.zoom)
                            .scrollTransition(axis: .horizontal) { card, phase in
                                card
                                    .scaleEffect(phase.isIdentity ? 1 : 0.9)
                                    .opacity(phase.isIdentity ? 1 : 0.55)
                            }
                            .id(step.id)
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                .scrollTargetLayout()
            }
            .scrollPosition(id: $position, anchor: .center)
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            .scrollEdgeEffectStyle(.soft, for: .all)
            .scrollClipDisabled()
            .contentMargins(.horizontal, Spacing.screen, for: .scrollContent)
            .padding(.horizontal, -Spacing.screen)
            ProgressSegments(total: steps.count, completed: steps.filter(\.isDone).count, height: 4)
                .padding(.horizontal, 40)
        }
        .onAppear { position = current?.id ?? steps.last?.id }
        .onChange(of: current?.id) { _, next in
            withAnimation(.smooth) { position = next ?? steps.last?.id }
        }
    }
}

/// One step as a card: "Today · 2 of 4 · Grammar", the title with a taste of
/// it, the artwork, and Start (or Do it again once done).
private struct StackCard: View {
    let step: LessonStep
    let number: Int
    let count: Int
    let onOpen: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline) {
                Text("Today · \(number) of \(count) · \(Text(step.part.name))")
                    .textCase(.uppercase)
                    .foregroundStyle(.accent)
                Spacer(minLength: 8)
                if step.isDone {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.accent)
                        .accessibilityLabel(Text("Done"))
                } else {
                    Text("\(step.minutes) min")
                        .foregroundStyle(.secondary)
                }
            }
            .font(.caption.weight(.heavy))
            HStack(alignment: .center, spacing: 14) {
                VStack(alignment: .leading, spacing: 4) {
                    step.title.text
                        .font(.title2.weight(.heavy))
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    if let preview = step.preview {
                        Text(verbatim: preview)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                ScenarioArtwork(systemImage: step.systemImage, symbolSize: 34, cornerRadius: 20)
                    .frame(width: 72, height: 72)
            }
            Spacer(minLength: 0)
            Button(action: onOpen) {
                Label {
                    step.isDone ? Text("Do it again") : Text("Start")
                } icon: {
                    Image(systemName: step.isDone ? "arrow.counterclockwise" : "play.fill")
                }
            }
            .buttonStyle(.primaryCompact)
        }
        .padding(Spacing.cardLarge)
        .frame(maxHeight: .infinity, alignment: .top)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

/// A part as an activity ring with its symbol inside and its name under it.
private struct PartRingButton: View {
    let part: LearnOverview.Part
    let onOpen: () -> Void

    @ScaledMetric(relativeTo: .title) private var size: CGFloat = 72

    var body: some View {
        Button(action: onOpen) {
            VStack(spacing: 8) {
                ZStack {
                    LevelRing(fraction: part.shownFraction, lineWidth: 7)
                    Image(systemName: part.kind.systemImage)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.accent)
                }
                .frame(width: size, height: size)
                .padding(4)
                .glassEffect(.regular.interactive(), in: .circle)
                Text(part.kind.title)
                    .font(.footnote.weight(.bold))
            }
            .contentShape(.rect)
        }
        .buttonStyle(.tile)
        .accessibilityElement(children: .combine)
        .accessibilityValue(Text(verbatim: part.count))
    }
}
