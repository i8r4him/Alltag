//
//  WordCollections+A1Work.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WordCollections {
    static let a1Jobs = WordCollection(
        id: "a1-berufe", title: "Berufe", subtitle: "Jobs", level: .a1,
        category: .work, systemImage: "wrench.and.screwdriver.fill",
        words: [
            CollectionWord("der ", "Beruf", "job, profession",
                           "Was sind Sie von Beruf?", "What do you do for a living?"),
            CollectionWord("die ", "Arbeit", "work",
                           "Die Arbeit macht mir Spaß.", "I enjoy my work."),
            CollectionWord("die ", "Firma", "company",
                           "Ich arbeite bei einer großen Firma.", "I work for a big company."),
            CollectionWord("das ", "Büro", "office",
                           "Morgen bin ich nicht im Büro.", "I’m not in the office tomorrow."),
            CollectionWord("die ", "Chefin", "boss (woman)",
                           "Meine Chefin ist sehr nett.", "My boss is very nice."),
            CollectionWord("der ", "Kollege", "colleague (man)",
                           "Mein Kollege kommt aus Polen.", "My colleague is from Poland."),
            CollectionWord("die ", "Lehrerin", "teacher (woman)",
                           "Die Lehrerin erklärt die Grammatik.", "The teacher explains the grammar."),
            CollectionWord("die ", "Ärztin", "doctor (woman)",
                           "Meine Schwester ist Ärztin.", "My sister is a doctor."),
            CollectionWord("der ", "Koch", "cook, chef",
                           "Der Koch macht eine tolle Pizza.", "The chef makes a great pizza."),
            CollectionWord("der ", "Verkäufer", "shop assistant (man)",
                           "Der Verkäufer hilft mir gern.", "The shop assistant is happy to help me."),
            CollectionWord("der ", "Kellner", "waiter",
                           "Der Kellner bringt die Rechnung.", "The waiter brings the bill."),
            CollectionWord("der ", "Busfahrer", "bus driver (man)",
                           "Der Busfahrer wartet auf uns.", "The bus driver is waiting for us."),
            CollectionWord("die ", "Studentin", "student (woman)",
                           "Ich bin Studentin an der Uni.", "I’m a student at university."),
            CollectionWord("die ", "Ausbildung", "vocational training",
                           "Sie macht eine Ausbildung zur Friseurin.", "She’s training to be a hairdresser."),
            CollectionWord("", "arbeitslos", "unemployed",
                           "Er ist seit Mai arbeitslos.", "He’s been unemployed since May.")
        ]
    )

    static let a1FreeTime = WordCollection(
        id: "a1-freizeit", title: "Was machst du gern?", subtitle: "Things you like doing", level: .a1,
        category: .freeTime, systemImage: "soccerball",
        words: [
            CollectionWord("", "gern", "like doing (with a verb)",
                           "Ich koche gern.", "I like cooking."),
            CollectionWord("", "treffen", "to meet",
                           "Wann können wir uns treffen?", "When can we meet?"),
            CollectionWord("der ", "Sport", "sport, exercise",
                           "Ich mache dreimal pro Woche Sport.", "I exercise three times a week."),
            CollectionWord("der ", "Fußball", "football",
                           "Am Samstag schauen wir Fußball.", "On Saturday we’re watching football."),
            CollectionWord("", "spielen", "to play",
                           "Die Kinder spielen im Park.", "The children are playing in the park."),
            CollectionWord("", "schwimmen", "to swim",
                           "Im Sommer gehe ich oft schwimmen.", "In summer I often go swimming."),
            CollectionWord("", "Rad fahren", "to cycle",
                           "Am Sonntag wollen wir Rad fahren.", "On Sunday we want to go cycling."),
            CollectionWord("", "spazieren gehen", "to go for a walk",
                           "Wollen wir spazieren gehen?", "Shall we go for a walk?"),
            CollectionWord("", "lesen", "to read",
                           "Ich möchte mehr lesen.", "I want to read more."),
            CollectionWord("das ", "Buch", "book",
                           "Das Buch ist sehr spannend.", "The book is really exciting."),
            CollectionWord("die ", "Musik", "music",
                           "Welche Musik hörst du gern?", "What music do you like listening to?"),
            CollectionWord("", "tanzen", "to dance",
                           "Gehst du am Samstag mit tanzen?", "Are you coming dancing on Saturday?"),
            CollectionWord("das ", "Kino", "cinema",
                           "Was läuft heute im Kino?", "What’s on at the cinema today?"),
            CollectionWord("der ", "Film", "film",
                           "Der Film war super!", "The film was great!"),
            CollectionWord("das ", "Konzert", "concert",
                           "Das Konzert beginnt um acht.", "The concert starts at eight.")
        ]
    )

    static let a1Forms = WordCollection(
        id: "a1-formular", title: "Formulare ausfüllen", subtitle: "Filling in forms", level: .a1,
        category: .paperwork, systemImage: "list.clipboard.fill",
        words: [
            CollectionWord("", "ausfüllen", "to fill in",
                           "Können Sie mir beim Ausfüllen helfen?", "Can you help me fill it in?"),
            CollectionWord("der ", "Vorname", "first name",
                           "Mein Vorname ist Ahmad.", "My first name is Ahmad."),
            CollectionWord("der ", "Nachname", "surname",
                           "Wie ist Ihr Nachname?", "What’s your surname?"),
            CollectionWord("das ", "Geburtsdatum", "date of birth",
                           "Ihr Geburtsdatum, bitte.", "Your date of birth, please."),
            CollectionWord("der ", "Geburtsort", "place of birth",
                           "Mein Geburtsort ist Damaskus.", "I was born in Damascus."),
            CollectionWord("die ", "Staatsangehörigkeit", "nationality",
                           "Welche Staatsangehörigkeit haben Sie?", "What’s your nationality?"),
            CollectionWord("der ", "Familienstand", "marital status",
                           "Familienstand: verheiratet, zwei Kinder.", "Marital status: married, two children."),
            CollectionWord("", "ledig", "single (not married)",
                           "Ich bin ledig.", "I’m single."),
            CollectionWord("die ", "Adresse", "address",
                           "Ist das Ihre neue Adresse?", "Is this your new address?"),
            CollectionWord("die ", "Hausnummer", "house number",
                           "Die Hausnummer fehlt noch.", "The house number is still missing."),
            CollectionWord("die ", "Postleitzahl", "postcode",
                           "Die Postleitzahl steht vor dem Ort.", "The postcode goes before the town."),
            CollectionWord("der ", "Wohnort", "town where you live",
                           "Mein Wohnort ist Leipzig.", "I live in Leipzig."),
            CollectionWord("die ", "Telefonnummer", "phone number",
                           "Kann ich Ihre Telefonnummer haben?", "Can I have your phone number?"),
            CollectionWord("die ", "E-Mail-Adresse", "email address",
                           "Meine E-Mail-Adresse steht unten.", "My email address is at the bottom."),
            CollectionWord("", "unterschreiben", "to sign",
                           "Hier müssen Sie noch unterschreiben.", "You still need to sign here.")
        ]
    )
}
