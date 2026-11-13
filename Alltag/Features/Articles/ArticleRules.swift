//
//  ArticleRules.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import SwiftUI

/// Stable grammar guidance; practice vocabulary comes from the server.
struct ArticleRules: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("A few useful clues")
                .font(.title2.bold())
            Text("Learn a noun with its article and plural. Some patterns help; a word’s meaning can matter too.")
                .foregroundStyle(.secondary)
            rule("Three genders", example: "der Tisch · die Tür · das Fenster") {
                Text("""
                    Der is masculine, die is feminine and das is neuter. These are grammatical genders: they \
                    don’t reliably describe a person or object.
                    """)
            }
            rule("Feminine endings", example: "die Wohnung · die Freiheit · die Möglichkeit · die Freundschaft") {
                Text("""
                    Nouns formed with the suffixes -ung, -heit, -keit and -schaft are feminine. Recognise the \
                    suffix, rather than guessing from a word’s final letters.
                    """)
            }
            rule("Small things: -chen and -lein", example: "das Mädchen · das Häuschen · das Büchlein") {
                Text("Diminutives formed with -chen or -lein are neuter—even when they describe a person.")
            }
            rule("The last noun decides", example: "die Tür → die Haustür · das Haus → das Krankenhaus") {
                Text("In a compound noun, the final noun determines the grammatical gender.")
            }
            rule("Plural uses die", example: "der Tisch → die Tische · das Kind → die Kinder") {
                Text("""
                    In the nominative, all plural nouns use die. That does not tell you their singular article. \
                    Articles also change with case in sentences.
                    """)
            }
            rule("Some words have more than one article", example: "der See: lake · die See: sea") {
                Text("The article can change with the meaning. Look up the word to see the meanings separately.")
            }
        }
    }

    private func rule(_ title: LocalizedStringKey, example: String, @ViewBuilder explanation: @escaping () -> some View) -> some View {
        DisclosureGroup {
            VStack(alignment: .leading, spacing: 12) {
                explanation().foregroundStyle(.secondary)
                Text(verbatim: example).font(.headline).foregroundStyle(.accent)
            }.padding(.top, 12)
        } label: { Text(title).font(.headline) }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero))
    }
}
