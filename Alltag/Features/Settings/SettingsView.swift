//
//  SettingsView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// Native grouped settings: learning, Pro, privacy, sources, reminders,
/// accessibility and more.
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
            if let profile = profiles.first {
                SettingsSections(profile: profile, model: model, aiStatus: aiStatus, toast: $toast)
            }
            moreSection
            replaySection
            #if DEBUG
            Section(header: Text(verbatim: "Developer")) {
                NavigationLink { CompanionEditor() } label: { Text(verbatim: "Companion") }
            }
            #endif
        }
        // The system's inset-grouped margins already adapt to wide screens.
        .listStyle(.insetGrouped)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .toast($toast)
        .onChange(of: model.message) { _, message in
            guard let message else { return }
            toast = ToastMessage(text: message, systemImage: "exclamationmark.circle.fill")
            model.message = nil
        }
    }

    private var moreSection: some View {
        Section("More") {
            NavigationLink(value: Route.beyond) {
                Label { Text("Learning beyond the app") } icon: { SymbolSquare(systemImage: "macbook.and.iphone") }
            }
            ShareLink(item: DataExportFile(container: modelContext.container),
                      preview: SharePreview("Alltag export", image: Image(systemName: "doc.text"))) {
                Label { Text("Export my data") } icon: { SymbolSquare(systemImage: "square.and.arrow.down") }
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

/// The sections that edit the profile and device settings.
private struct SettingsSections: View {
    @Bindable var profile: UserProfile
    let model: SettingsModel
    let aiStatus: OnDeviceAIStatus
    @Binding var toast: ToastMessage?
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var settings = appState.settings

        Section { header }

        Section("Learning") {
            LabeledContent {
                Text("German")
            } label: {
                Label { Text("Language") } icon: { SymbolSquare(systemImage: "character.bubble") }
            }
            Picker(selection: $profile.level) {
                ForEach(Level.selectable) { level in
                    Text(verbatim: level.title).tag(level)
                }
            } label: {
                Label { Text("Level") } icon: { SymbolSquare(systemImage: "chart.bar.fill") }
            }
            Picker(selection: $profile.goal) {
                ForEach(Goal.allCases) { goal in
                    Text(goal.title).tag(goal)
                }
            } label: {
                Label { Text("Why I'm learning") } icon: { SymbolSquare(systemImage: "flag") }
            }
            Picker(selection: $profile.dailyTime) {
                ForEach(DailyTime.allCases) { time in
                    Text(time.title).tag(time)
                }
            } label: {
                Label { Text("Daily time") } icon: { SymbolSquare(systemImage: "timer") }
            }
        }
        .pickerStyle(.navigationLink)

        Section("Alltag Pro") {
            ProCard(isPro: settings.isPro) {
                if !settings.isPro { toast = ToastMessage(text: "Your 7-day trial has started.") }
                settings.isPro.toggle()
            }
            .listRowInsets(EdgeInsets())
        }

        Section {
            Label {
                VStack(alignment: .leading, spacing: 3) {
                    Text("On-device intelligence")
                    Text(aiStatus.detail).textRole(.meta).foregroundStyle(.secondary)
                }
            } icon: {
                Image(systemName: "cpu")
                    .foregroundStyle(aiStatus.isAvailable ? Color.success : .secondary)
            }
            ToggleRow(title: "Pro features may use the cloud",
                      subtitle: "Live voice sends audio to OpenAI. Calendar and keyboard text stay on your iPhone.",
                      systemImage: "cloud.fill", symbolTint: .blue, symbolForeground: .white,
                      isOn: $settings.usesCloudForPro)
        } header: {
            Text("Privacy & AI")
        } footer: {
            Text("Alltag never sees content from other apps unless you share it, select it, or type it in the Alltag keyboard.")
        }

        Section("Learn from my day") {
            ToggleRow(title: "Calendar", subtitle: "Suggest rehearsals before events",
                      systemImage: "calendar", symbolTint: .red, symbolForeground: .white,
                      isOn: permission(\.learnsFromCalendar, set: { await model.setLearnsFromCalendar($0, on: $1) }))
            ToggleRow(title: "Reading in Safari", subtitle: "Words from pages you share or translate",
                      systemImage: "safari", symbolTint: .blue, symbolForeground: .white,
                      isOn: $settings.learnsFromSafari)
            ToggleRow(title: "Alltag Keyboard", subtitle: "Corrections while you type",
                      systemImage: "keyboard", symbolTint: .gray, symbolForeground: .white,
                      isOn: $profile.learnsFromKeyboard)
            ToggleRow(title: "Camera & Photos", subtitle: "Scan menus, letters and signs",
                      systemImage: "camera.fill", symbolTint: .gray, symbolForeground: .white,
                      isOn: $settings.learnsFromCamera)
        }

        Section("Reminders") {
            ToggleRow(title: "Rehearsal reminders", subtitle: "The evening before a Calendar event",
                      systemImage: "bell.fill", symbolTint: .orange, symbolForeground: .white,
                      isOn: permission(\.remindersEnabled, set: { await model.setRemindersEnabled($0, on: $1) }))
            ToggleRow(title: "Morning briefing", subtitle: "Ready at 7:30",
                      systemImage: "headphones", symbolTint: .orange, symbolForeground: .white,
                      isOn: permission(\.morningBriefingEnabled, set: { await model.setMorningBriefingEnabled($0, on: $1) }))
            ToggleRow(title: "Quiet evenings", subtitle: "No reminders after 21:00",
                      systemImage: "moon.fill", symbolTint: .indigo, symbolForeground: .white,
                      isOn: $settings.quietEvenings)
        }

        Section("Accessibility") {
            ToggleRow(title: "Reduce motion", subtitle: "Also follows your device setting",
                      systemImage: "circle.dotted.and.circle", symbolTint: .gray, symbolForeground: .white,
                      isOn: $settings.reduceMotion)
            ToggleRow(title: "Slower speech by default",
                      systemImage: "gauge.with.dots.needle.33percent", symbolTint: .gray, symbolForeground: .white,
                      isOn: $settings.slowerSpeech)
        }
    }

    private var header: some View {
        HStack(spacing: 14) {
            Avatar(name: profile.name, diameter: 52)
            VStack(alignment: .leading, spacing: 2) {
                Text(verbatim: profile.name).textRole(.cardTitle)
                Text("Learning German · \(profile.level.title)")
                    .textRole(.meta)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }

    /// A toggle binding whose "on" asks for a system permission first.
    private func permission(
        _ keyPath: ReferenceWritableKeyPath<UserProfile, Bool>,
        set: @escaping (Bool, UserProfile) async -> Void
    ) -> Binding<Bool> {
        Binding {
            profile[keyPath: keyPath]
        } set: { isOn in
            let profile = profile
            Task { await set(isOn, profile) }
        }
    }
}

/// Try Alltag Pro, or the active subscription.
private struct ProCard: View {
    let isPro: Bool
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(isPro ? "Alltag Pro" : "Try Alltag Pro").textRole(.cardTitle)
                Spacer()
                Text(isPro ? "Active" : "7 days free")
                    .textRole(.eyebrow)
                    .foregroundStyle(.accent)
            }
            Text("Live voice conversations, Debrief, daily briefings and deeper explanations. Corrections, Memory and Grammar stay free.")
                .textRole(.bodySmall)
                .foregroundStyle(.secondary)
            if isPro {
                Button("Manage subscription", action: action)
                    .buttonStyle(.outline)
            } else {
                Button("Start free trial", action: action)
                    .buttonStyle(.primaryCompact)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RadialGradient(colors: [.accentFill.opacity(0.16), .clear], center: .topTrailing, startRadius: 0, endRadius: 260)
        }
    }
}

#Preview {
    NavigationStack { SettingsView() }
        .environment(AppState())
        .modelContainer(AlltagStore.preview)
}

#Preview("Pro, AI not enabled") {
    let state = AppState()
    state.settings.isPro = true
    return NavigationStack { SettingsView(aiStatus: .notEnabled) }
        .environment(state)
        .modelContainer(AlltagStore.preview)
}
