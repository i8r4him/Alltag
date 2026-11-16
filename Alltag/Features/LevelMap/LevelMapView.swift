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
struct LevelMapView: View {
    @Environment(AppState.self) private var appState
    @Query private var solved: [SolvedRule]
    @Query private var sessions: [SessionRecord]
    @Query private var profiles: [UserProfile]
    @State private var openPlace: TownPlace?
    /// What to open once the place's sheet has gone.
    @State private var pendingStop: MapStop?
    /// Another level's map the learner is looking at; `nil` shows their own.
    @State private var shownLevel: Level?
    @AppStorage(PlaceLook.storageKey) private var placeLook = 0
    @Namespace private var placeZoom

    private var ownLevel: Level { profiles.first?.level ?? .a1 }

    var body: some View {
        let map = LevelMap(level: shownLevel ?? ownLevel, solved: solved, sessions: sessions)
        let isOwn = map.level == ownLevel
        GeometryReader { proxy in
            ZStack {
                TownRoute(walkedTo: isOwn ? TownPlace.route.firstIndex(of: map.here) ?? 0 : 0)
                GlassEffectContainer {
                    ZStack {
                        ForEach(TownPlace.route) { place in
                            pin(place, in: map, isOwn: isOwn)
                                .position(x: place.spot.x * proxy.size.width, y: place.spot.y * proxy.size.height)
                        }
                    }
                }
            }
        }
        .dynamicTypeSize(...DynamicTypeSize.xxLarge)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .frame(maxWidth: Spacing.readableWidth)
        .frame(maxWidth: .infinity)
        .id(placeLook)
        .background { TownGround().ignoresSafeArea() }
        .safeAreaInset(edge: .bottom) {
            NextStopCard(map: map, ownLevel: isOwn ? nil : ownLevel, onGo: open) { shownLevel = nil }
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
                    LevelHeader(map: map)
                }
                .accessibilityHint(Text("Shows the map of another level"))
            }
            ToolbarItem(placement: .topBarTrailing) {
                PlaceLookSwitcher(look: $placeLook)
            }
        }
        .navigationTitle(Text("Your level"))
        .toolbarTitleDisplayMode(.inline)
        .sheet(item: $openPlace, onDismiss: openPending) { place in
            PlaceSheet(place: place, progress: map.progress(of: place), nextLevel: map.nextLevel) { stop in
                pendingStop = stop
                openPlace = nil
            }
            .navigationTransition(.zoom(sourceID: place, in: placeZoom))
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: openPlace) { _, place in place != nil }
    }

    /// The level picked in the header; picking their own level goes back to it.
    private var levelChoice: Binding<Level> {
        Binding { shownLevel ?? ownLevel } set: { level in
            shownLevel = level == ownLevel ? nil : level
        }
    }

    private func pin(_ place: TownPlace, in map: LevelMap, isOwn: Bool) -> some View {
        let progress = map.progress(of: place)
        return Button {
            openPlace = place
        } label: {
            PlacePin(place: place, progress: progress, isHere: isOwn && map.here == place, nextLevel: map.nextLevel)
        }
        .buttonStyle(.plain)
        .matchedTransitionSource(id: place, in: placeZoom)
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
        }
    }
}

/// "A2 · 45% to B1" with its ring, in the middle of the toolbar.
private struct LevelHeader: View {
    let map: LevelMap

    var body: some View {
        HStack(spacing: 8) {
            LevelRing(fraction: map.fraction, lineWidth: 3.5)
                .frame(width: 22, height: 22)
            Group {
                if let next = map.nextLevel {
                    Text("\(map.level.title) · \(map.percent)% to \(next.title)")
                } else {
                    Text("\(map.level.title) · the top level")
                }
            }
            .font(.headline)
            .fontDesign(.rounded)
            .monospacedDigit()
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
                    Text("Next stop · \(Text(place.place.name))")
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

/// The temporary ‹ n / 4 › switcher for the café's and the library's looks.
private struct PlaceLookSwitcher: View {
    @Binding var look: Int

    var body: some View {
        let count = PlaceLook.allCases.count
        HStack(spacing: 10) {
            Button("Previous design", systemImage: "chevron.left") {
                look = (look + count - 1) % count
            }
            Text(verbatim: "\(look + 1) / \(count)")
                .font(.subheadline.weight(.semibold).monospacedDigit())
            Button("Next design", systemImage: "chevron.right") {
                look = (look + 1) % count
            }
        }
        .labelStyle(.iconOnly)
        .padding(.horizontal, 6)
        .sensoryFeedback(.selection, trigger: look)
    }
}

#Preview {
    NavigationStack { LevelMapView() }
        .environment(AppState())
        .modelContainer(AlltagStore.preview)
}
