//
//  LevelMapView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// The level map: the learner's way to the next level as a town at night.
/// Each part of learning is a place with a ring that fills (School is Grammar,
/// Café is Speaking, Market is Words, Library is Read and Write), the path
/// shows how far they've come, and the level test waits at the station.
/// Tapping a place shows what's in it; the card at the bottom opens the next stop.
/// Each level is its own town with its own places; swiping sideways walks to
/// the next or previous level's town.
struct LevelMapView: View {
    @Environment(AppState.self) private var appState
    @Query private var solved: [SolvedRule]
    @Query private var sessions: [SessionRecord]
    @Query(filter: #Predicate<MemoryItem> { $0.sourceRaw == "collection" }) private var collectionWords: [MemoryItem]
    @Query private var profiles: [UserProfile]
    @State private var openPlace: TownPlace?
    /// What to open once the place's sheet has gone.
    @State private var pendingStop: MapStop?
    /// A word collection opened from the market or the next-stop card.
    @State private var openCollection: WordCollection?
    /// The level whose town is on screen; `nil` shows the learner's own.
    /// Swiping sideways changes it, and so does the header's menu.
    @State private var shownLevel: Level?
    @Environment(\.reducesMotion) private var reducesMotion
    @Namespace private var placeZoom

    private var ownLevel: Level { profiles.first?.level ?? .a1 }
    private var currentLevel: Level { shownLevel ?? ownLevel }

    /// The towns side by side, from the village to the capital.
    private var levels: [Level] {
        Level.selectable.contains(ownLevel) ? Level.selectable : Level.selectable + [ownLevel]
    }

    var body: some View {
        let map = map(of: currentLevel)
        let isOwn = map.level == ownLevel
        GeometryReader { proxy in
            towns(insets: proxy.safeAreaInsets)
        }
        .background { Color.screenBackground.ignoresSafeArea() }
        .safeAreaInset(edge: .top, spacing: 0) {
            LevelDots(levels: levels, current: currentLevel)
                .padding(.vertical, 6)
        }
        .safeAreaInset(edge: .bottom) {
            NextStopCard(map: map, ownLevel: isOwn ? nil : ownLevel, onGo: open) { show(ownLevel) }
                .frame(maxWidth: Spacing.readableWidth)
                .padding(.horizontal, Spacing.screen)
                .padding(.bottom, 8)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Menu {
                    Picker("Level", selection: levelChoice) {
                        ForEach(Level.selectable) { level in
                            Text(verbatim: level.title).tag(level)
                        }
                    }
                } label: {
                    LevelHeader(map: map, townName: TownLayout.of(map.level).townName)
                }
                .accessibilityHint(Text("Shows the map of another level"))
            }
        }
        .navigationTitle(Text("Your level"))
        .toolbarTitleDisplayMode(.inline)
        .sheet(item: $openPlace, onDismiss: openPending) { place in
            PlaceSheet(place: place, level: map.level, progress: map.progress(of: place), nextLevel: map.nextLevel) { stop in
                pendingStop = stop
                openPlace = nil
            }
            .navigationTransition(.zoom(sourceID: PlaceZoomID(level: map.level, place: place), in: placeZoom))
        }
        .sheet(item: $openCollection) { collection in
            WordCollectionSheet(collection: collection)
        }
        .onAppear {
            if shownLevel == nil { shownLevel = ownLevel }
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: openPlace) { _, place in place != nil }
        .sensoryFeedback(.selection, trigger: shownLevel) { old, _ in old != nil }
    }

    private func map(of level: Level) -> LevelMap {
        LevelMap(level: level, solved: solved, sessions: sessions, collectionWords: collectionWords)
    }

    /// Every level's town, one page each; swiping left goes up a level.
    /// The towns reach under the bars and the card; their places stay clear of them.
    private func towns(insets: EdgeInsets) -> some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(levels) { level in
                    town(map(of: level), isOwn: level == ownLevel, isShown: level == currentLevel, insets: insets)
                        .containerRelativeFrame([.horizontal, .vertical])
                        .id(level)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $shownLevel)
        .scrollIndicators(.hidden)
        .scrollEdgeEffectStyle(.soft, for: .all)
        .ignoresSafeArea()
    }

    /// One level's town: its streets, its route and its places.
    private func town(_ map: LevelMap, isOwn: Bool, isShown: Bool, insets: EdgeInsets) -> some View {
        let layout = TownLayout.of(map.level)
        return GeometryReader { proxy in
            ZStack {
                TownRoute(layout: layout, walkedTo: isOwn ? TownPlace.route.firstIndex(of: map.here) ?? 0 : 0)
                ForEach(Array(TownPlace.route.enumerated()), id: \.element) { index, place in
                    let spot = layout.spot(of: place)
                    pin(place, in: map, isOwn: isOwn, isShown: isShown, order: TownPlace.route.count - 1 - index)
                        .position(x: spot.x * proxy.size.width, y: spot.y * proxy.size.height)
                }
            }
        }
        .dynamicTypeSize(...DynamicTypeSize.xxLarge)
        .padding(.top, insets.top + 16)
        .padding(.bottom, insets.bottom + 8)
        .frame(maxWidth: Spacing.readableWidth)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background { TownGround(layout: layout) }
    }

    /// The level picked in the header; the town slides over to it.
    private var levelChoice: Binding<Level> {
        Binding { currentLevel } set: { level in show(level) }
    }

    private func show(_ level: Level) {
        withAnimation(reducesMotion ? nil : .smooth(duration: 0.5)) {
            shownLevel = level
        }
    }

    private func pin(_ place: TownPlace, in map: LevelMap, isOwn: Bool, isShown: Bool, order: Int) -> some View {
        let progress = map.progress(of: place)
        return Button {
            openPlace = place
        } label: {
            PlacePin(place: place, level: map.level, progress: progress, isHere: isOwn && map.here == place,
                     nextLevel: map.nextLevel, isShown: isShown, order: order)
        }
        .buttonStyle(.plain)
        .matchedTransitionSource(id: PlaceZoomID(level: map.level, place: place), in: placeZoom)
        .accessibilityLabel(Text(place.name))
        .accessibilityValue(accessibilityValue(of: progress, in: map))
        .accessibilityHint(Text("Shows what's in this place"))
    }

    private func accessibilityValue(of progress: PlaceProgress?, in map: LevelMap) -> Text {
        guard let progress else { return Text("Level test, locked") }
        guard progress.isOpen else { return Text("\(Text(progress.place.subject)), coming soon") }
        return Text("\(Text(progress.place.subject)), \(progress.doneCount) of \(progress.totalCount) done")
    }

    private func openPending() {
        guard let stop = pendingStop else { return }
        pendingStop = nil
        open(stop)
    }

    private func open(_ stop: MapStop) {
        switch stop.destination {
        case .rule(let id): appState.open(.rule(id: id))
        case .situation(let id): appState.present(.situation(id))
        case .collection(let id): openCollection = WordCollections.collection(id: id)
        }
    }
}

/// A place in one level's town, so a sheet zooms out of the sign it was opened from.
private struct PlaceZoomID: Hashable {
    let level: Level
    let place: TownPlace
}

/// Which town is on screen, as dots under the title: a wider one for the current level.
private struct LevelDots: View {
    let levels: [Level]
    let current: Level

    var body: some View {
        HStack(spacing: 6) {
            ForEach(levels) { level in
                Capsule()
                    .fill(level == current ? AnyShapeStyle(.primary) : AnyShapeStyle(.tertiary))
                    .frame(width: level == current ? 18 : 7, height: 7)
            }
        }
        .animation(.smooth(duration: 0.3), value: current)
        .accessibilityHidden(true)
    }
}

/// "A2 · 45% to B1" with its ring, in the middle of the toolbar.
private struct LevelHeader: View {
    let map: LevelMap
    let townName: String

    var body: some View {
        HStack(spacing: 8) {
            LevelRing(fraction: map.fraction, lineWidth: 3.5)
                .frame(width: 22, height: 22)
            VStack(spacing: 0) {
                Group {
                    if let next = map.nextLevel {
                        Text("\(map.level.title) · \(map.percent)% to \(next.title)")
                    } else {
                        Text("\(map.level.title) · the top level")
                    }
                }
                .font(.headline)
                .monospacedDigit()
                Text(verbatim: townName)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            .fontDesign(.rounded)
            .contentTransition(.numericText())
        }
        .accessibilityElement(children: .combine)
    }
}

/// The card at the bottom: the next stop and a button to go there.
private struct NextStopCard: View {
    let map: LevelMap
    /// The learner's own level while they look at another one, else `nil`.
    let ownLevel: Level?
    let onGo: (MapStop) -> Void
    let onBack: () -> Void
    @State private var taps = 0

    var body: some View {
        HStack(spacing: 14) {
            if let ownLevel {
                VStack(alignment: .leading, spacing: 3) {
                    Text("What \(map.level.title) holds")
                        .font(.headline)
                    Text("Tap a place to see what's in it. You're at \(ownLevel.title).")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
                Button("Back to \(ownLevel.title)", action: onBack)
                    .buttonStyle(.primaryCompact)
            } else if let place = map.nextPlace, let stop = place.nextStop {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Next stop · \(place.place.germanName(at: map.level))")
                        .font(.caption.weight(.heavy))
                        .textCase(.uppercase)
                        .foregroundStyle(.accent)
                    Text(stop.title)
                        .font(.headline)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
                Button("Go") {
                    taps += 1
                    onGo(stop)
                }
                .buttonStyle(.primaryCompact)
            } else {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Every open place is full")
                        .font(.headline)
                    Text("More places open soon, then the level test at the station.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .fontDesign(.rounded)
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        .sensoryFeedback(.impact(weight: .medium), trigger: taps)
    }
}

#Preview {
    NavigationStack { LevelMapView() }
        .environment(AppState())
        .modelContainer(AlltagStore.preview)
}
