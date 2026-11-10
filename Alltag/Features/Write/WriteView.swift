//
//  WriteView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 10.11.26.
//

import SwiftUI

/// Learn › Write: a task picked for you, tasks from daily life, and phrases to
/// start and end a message. UI only for now, with mock content.
struct WriteView: View {
    @State private var taps = 0
    @State private var register = WritingTask.Register.formal

    var body: some View {
        LearnScreen(title: "Write") {
            LearnHeroCard(title: Text(MockWriting.picked.title),
                          detail: Text(MockWriting.picked.detail),
                          systemImage: MockWriting.picked.systemImage,
                          buttonTitle: "Start writing · \(MockWriting.picked.minutes) min",
                          buttonImage: "pencil",
                          isProminent: true, action: tapped)

            LearnSection(title: "From daily life") {
                LearnList {
                    ForEach(MockWriting.tasks) { task in
                        LearnRow(systemImage: task.systemImage, title: Text(task.title),
                                 detail: Text("\(Text(task.detail)) · \(task.minutes) min"), action: tapped) {
                            RegisterBadge(register: task.register)
                        }
                    }
                }
            }

            LearnSection(title: "Useful phrases") {
                PhrasesCard(register: $register)
            }
        }
        .sensoryFeedback(.impact(weight: .light), trigger: taps)
    }

    /// The writing exercise comes later; for now a tap only gives feedback.
    private func tapped() {
        taps += 1
    }
}

/// "Sie" or "du": how formal the message is.
private struct RegisterBadge: View {
    let register: WritingTask.Register

    var body: some View {
        Text(verbatim: register == .formal ? "Sie" : "du")
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(register == .formal ? Color.accent : Color.secondary)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(register == .formal ? Color.accent.opacity(0.14) : Color.secondary.opacity(0.14),
                        in: .capsule)
            .accessibilityLabel(register == .formal ? Text("Formal") : Text("Informal"))
    }
}

/// Openings, requests, thanks and closings, formal or informal.
private struct PhrasesCard: View {
    @Binding var register: WritingTask.Register

    private var phrases: [WritingPhrase] {
        register == .formal ? MockWriting.formalPhrases : MockWriting.informalPhrases
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Picker("Register", selection: $register) {
                Text("Formal · Sie").tag(WritingTask.Register.formal)
                Text("Informal · du").tag(WritingTask.Register.informal)
            }
            .pickerStyle(.segmented)

            ForEach(phrases) { phrase in
                VStack(alignment: .leading, spacing: 3) {
                    Text(phrase.role)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.accent)
                    Text(verbatim: phrase.german)
                        .font(.title3.weight(.medium))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
            }
        }
        .padding(Spacing.cardLarge)
        .learnSurface()
        .animation(.snappy, value: register)
        .sensoryFeedback(.selection, trigger: register)
    }
}

#Preview {
    NavigationStack { WriteView() }
}
