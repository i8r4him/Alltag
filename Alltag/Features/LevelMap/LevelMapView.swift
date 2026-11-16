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
    @Namespace private var placeZoom

    var body: some View {
        let map = LevelMap(level: profiles.first?.level ?? .a1, solved: solved, sessions: sessions)
        GeometryReader { proxy in
            ZStack {
                TownRoute(walkedTo: TownPlace.route.firstIndex(of: map.here) ?? 0)
                GlassEffectContainer {
                    ZStack {
                        ForEach(TownPlace.route) { place in
                            pin(place, in: map)
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
        .background { TownGround().ignoresSafeArea() }
        .safeAreaInset(edge: .bottom) {
            NextStopCard(map: map, onGo: open)
                .frame(maxWidth: Spacing.readableWidth)
                .padding(.horizontal, Spacing.screen)
                .padding(.bottom, 8)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                LevelHeader(map: map)
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

    private func pin(_ place: TownPlace, in map: LevelMap) -> some View {
        let progress = map.progress(of: place)
        return Button {
            openPlace = place
        } label: {
            PlacePin(place: place, progress: progress, isHere: map.here == place, nextLevel: map.nextLevel)
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
    let onGo: (MapStop) -> Void
    @State private var taps = 0

    var body: some View {
        HStack(spacing: 14) {
            if let place = map.nextPlace, let stop = place.nextStop {
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

#Preview {
    NavigationStack { LevelMapView() }
        .environment(AppState())
        .modelContainer(AlltagStore.preview)
}
