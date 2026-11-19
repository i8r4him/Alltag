//
//  WebArticleView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// Learn › Read › an article from the web: loads it, keeps it in Your
/// sessions, asks for three questions at the learner's level, and opens it in
/// the reader, where every word can be tapped. Without the questions (no
/// cloud use, no connection) the article can still be read.
struct WebArticleView: View {
    let source: WebSource
    let level: Level

    @Environment(\.services) private var services
    @Environment(\.modelContext) private var context
    @State private var phase = Phase.loadingArticle

    enum Phase: Equatable {
        case loadingArticle
        case writingQuestions
        case ready(ReadingText)
        case failed(WebReadingError)
    }

    var body: some View {
        Group {
            switch phase {
            case .ready(let text):
                ReaderView(text: text)
            case .loadingArticle, .writingQuestions:
                progress
            case .failed(let error):
                failure(error)
            }
        }
        .task(id: source) { await load() }
    }

    private var progress: some View {
        VStack(spacing: 18) {
            ProgressView()
                .controlSize(.large)
            Text(progressTitle)
                .font(.headline)
                .multilineTextAlignment(.center)
                .contentTransition(.opacity)
        }
        .padding(Spacing.screen)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .fontDesign(.rounded)
        .skyBackground()
        .animation(.easeOut(duration: 0.25), value: phase)
    }

    private var progressTitle: LocalizedStringKey {
        phase == .loadingArticle ? "Getting the article…" : "Writing three questions for your level…"
    }

    private func failure(_ error: WebReadingError) -> some View {
        ContentUnavailableView {
            Label { Text(title(of: error)) } icon: { Image(systemName: "doc.questionmark.fill") }
        } description: {
            Text(message(of: error))
        } actions: {
            Button { Task { await load() } } label: { Text("Try again") }
                .buttonStyle(.primaryCompact)
        }
        .fontDesign(.rounded)
        .skyBackground()
    }

    private func title(of error: WebReadingError) -> LocalizedStringResource {
        switch error {
        case .unreachable: "The page didn’t load"
        case .noArticle: "No article found"
        case .notGerman: "This isn’t in German"
        }
    }

    private func message(of error: WebReadingError) -> LocalizedStringResource {
        switch error {
        case .unreachable: "Check your connection, then try again."
        case .noArticle: "Alltag reads articles. Open one on the site and share it, rather than the start page."
        case .notGerman: "Share an article in German to read it here."
        }
    }

    private func load() async {
        phase = .loadingArticle
        let article: WebArticle
        switch source {
        case .saved(let saved):
            article = saved
        case .link(let url):
            do {
                article = try await services.webReading.article(at: url)
                ReadingInbox.remove(url)
            } catch let error as WebReadingError {
                phase = .failed(error)
                return
            } catch {
                phase = .failed(.unreachable)
                return
            }
        }
        try? WebArticles.keep(article, in: context)
        phase = .writingQuestions
        // The article can be read without its questions.
        let quiz = try? await services.webReading.questions(about: article, level: level)
        guard !Task.isCancelled else { return }
        phase = .ready(WebArticles.text(for: article, quiz: quiz, level: level))
    }
}

#Preview {
    NavigationStack {
        WebArticleView(source: .link(URL(string: "https://www.nachrichtenleicht.de")!), level: .a2)
    }
    .modelContainer(AlltagStore.preview)
}
