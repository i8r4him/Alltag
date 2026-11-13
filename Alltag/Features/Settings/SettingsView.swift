//
//  SettingsView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// Settings in Today's look: a native list on the sky, in rounded type, with
/// every symbol in the theme colour. Only what works is shown: learning,
/// appearance, privacy, accessibility and more. Alltag Pro, "Learn from my
/// day" and Reminders come back when they are real.
struct SettingsView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]
    @State private var model: SettingsModel
    @State private var toast: ToastMessage?
    private let aiStatus: OnDeviceAIStatus

    init(services: AppServices = .mock(), aiStatus: OnDeviceAIStatus = .current) {
        _model = State(initialValue: SettingsModel(services: services))
        self.aiStatus = aiStatus
    }

    var body: some View {
        // A List rather than a Form: Form drops the inset groups at regular width.
        List {
            Group {
                if let profile = profiles.first {
                    LearningSection(profile: profile)
                }
                DeviceSections(aiStatus: aiStatus)
                moreSection
                replaySection
                #if DEBUG
                Section(header: Text(verbatim: "Developer")) {
                    NavigationLink { CompanionEditor() } label: { Text(verbatim: "Companion") }
                    // Quick data for the streak and the minutes, without talking.
                    Button { addSession(daysAgo: 0) } label: { Text(verbatim: "Add practice today (2 min)") }
                    Button { addSession(daysAgo: 1) } label: { Text(verbatim: "Add practice yesterday (2 min)") }
                    Button(role: .destructive) {
                        try? modelContext.delete(model: PracticeSession.self)
                    } label: { Text(verbatim: "Delete all practice") }
                }
                #endif
            }
            .listRowBackground(Rectangle().fill(.thinMaterial))
        }
        // The system's inset-grouped margins already adapt to wide screens.
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .scrollEdgeEffectStyle(.soft, for: .all)
        .fontDesign(.rounded)
        .skyBackground()
        .navigationTitle("Settings")
        .toolbarTitleDisplayMode(.inlineLarge)
        .toast($toast)
        .onChange(of: model.message) { _, message in
            guard let message else { return }
            toast = ToastMessage(text: message, systemImage: "exclamationmark.circle.fill")
            model.message = nil
        }
    }

    #if DEBUG
    private func addSession(daysAgo: Int) {
        let date = Calendar.current.date(byAdding: .day, value: -daysAgo, to: .now) ?? .now
        modelContext.insert(PracticeSession(kind: .conversation, secondsSpoken: 120, date: date))
    }
    #endif

    private var moreSection: some View {
        Section("More") {
            NavigationLink(value: Route.beyond) {
                Label { Text("Learning beyond the app") } icon: { ThemeSymbol(systemImage: "apps.iphone") }
            }
            ShareLink(item: DataExportFile(container: modelContext.container),
                      preview: SharePreview("Alltag export", image: Image(systemName: "doc.text"))) {
                Label { Text("Export my data") } icon: { ThemeSymbol(systemImage: "square.and.arrow.down") }
            }
            .tint(.primary)
        }
    }

    private var replaySection: some View {
        Section {
            Button("Replay onboarding") { appState.present(.onboarding) }
                .frame(maxWidth: .infinity)
        } footer: {
            Text(verbatim: "Alltag \(Self.version)")
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
        }
    }

    private static var version: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    }
}

/// A row's symbol on a square tinted in the theme colour.
private struct ThemeSymbol: View {
    let systemImage: String

    var body: some View {
        SymbolSquare(systemImage: systemImage, tint: .accent.opacity(AccentTint.selected * 1.6), foreground: .accent)
    }
}

/// What the learner is learning and how: saved in their profile.
private struct LearningSection: View {
    @Bindable var profile: UserProfile

    var body: some View {
        Section("Learning") {
            LabeledContent {
                Text("German")
            } label: {
                Label { Text("Language") } icon: { ThemeSymbol(systemImage: "character.bubble") }
            }
            Picker(selection: $profile.level) {
                ForEach(Level.selectable) { level in
                    Text(verbatim: level.title).tag(level)
                }
            } label: {
                Label { Text("Level") } icon: { ThemeSymbol(systemImage: "chart.bar.fill") }
            }
            // A few short options: a menu in the row, not a page of its own.
            .pickerStyle(.menu)
            .tint(.secondary)
            Picker(selection: $profile.goal) {
                ForEach(Goal.allCases) { goal in
                    Text(goal.title).tag(goal)
                }
            } label: {
                Label { Text("Why I'm learning") } icon: { ThemeSymbol(systemImage: "flag.fill") }
            }
            Picker(selection: $profile.dailyTime) {
                ForEach(DailyTime.allCases) { time in
                    Text(time.title).tag(time)
                }
            } label: {
                Label { Text("Daily time") } icon: { ThemeSymbol(systemImage: "timer") }
            }
        }
        .pickerStyle(.navigationLink)
    }
}

/// Appearance, privacy and accessibility: saved on this iPhone.
private struct DeviceSections: View {
    let aiStatus: OnDeviceAIStatus
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var settings = appState.settings

        Section {
            ThemePicker()
        } header: {
            Text("Appearance")
        } footer: {
            Text("Colours your companion and the app.")
        }

        Section {
            Label {
                VStack(alignment: .leading, spacing: 3) {
                    Text("On-device intelligence")
                    Text(aiStatus.detail).textRole(.meta).foregroundStyle(.secondary)
                }
            } icon: {
                ThemeSymbol(systemImage: aiStatus.isAvailable ? "cpu.fill" : "cpu")
            }
            ToggleRow(title: "Talk and get corrections online",
                      subtitle: """
                          Your voice goes to OpenAI while you talk with the companion; \
                          your sentences go there as text to be checked.
                          """,
                      systemImage: "cloud.fill", symbolTint: .accent.opacity(AccentTint.selected * 1.6), symbolForeground: .accent,
                      isOn: $settings.usesCloudForPro)
        } header: {
            Text("Privacy & AI")
        } footer: {
            Text("""
                When this is off, the companion can't talk, and 60 seconds is checked on your iPhone. \
                Recordings never leave your iPhone.
                """)
        }

        Section("Accessibility") {
            ToggleRow(title: "Reduce motion", subtitle: "Also follows your device setting",
                      systemImage: "circle.dotted.and.circle", symbolTint: .accent.opacity(AccentTint.selected * 1.6),
                      symbolForeground: .accent, isOn: $settings.reduceMotion)
            ToggleRow(title: "Slower speech by default",
                      systemImage: "gauge.with.dots.needle.33percent", symbolTint: .accent.opacity(AccentTint.selected * 1.6),
                      symbolForeground: .accent, isOn: $settings.slowerSpeech)
        }
    }
}

#Preview {
    NavigationStack { SettingsView() }
        .environment(AppState())
        .modelContainer(AlltagStore.preview)
}

#Preview("AI not enabled") {
    NavigationStack { SettingsView(aiStatus: .notEnabled) }
        .environment(AppState())
        .modelContainer(AlltagStore.preview)
}
