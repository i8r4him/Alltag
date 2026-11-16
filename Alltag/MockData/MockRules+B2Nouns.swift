//
//  MockRules+B2Nouns.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The B2 rules, part 7: nouns, articles and adjective endings.
extension MockRules {
    static let b2Gender = GrammarRule(
        id: "b2-genus", level: .b2, title: "Endings that tell der, die, das",
        place: "News headline", systemImage: "newspaper",
        german: "Die Regierung plant eine neue Lösung für die Wohnungsnot.",
        english: "The government is planning a new solution to the housing shortage.",
        tiles: [Tile(text: "Die", role: .key), Tile(text: "Regierung", role: .end), Tile(text: "plant eine neue"),
                Tile(text: "Lösung", role: .end), Tile(text: "für die Wohnungsnot.")],
        notice: "Every noun that ends in -ung is feminine: die Regierung, die Lösung, die Wohnung.",
        rule: "Some endings tell you the gender. die: -ung, -heit, -keit, -schaft, -ion, -tät. "
            + "das: -chen, -lein, -ment, -um, and verbs used as nouns (das Essen). der: -ling, -ismus, -or.",
        visual: RuleVisual(
            source: Part(systemImage: "lightbulb.fill", german: "lösen", role: "the verb"),
            verb: "+ -ung",
            target: Part(systemImage: "checkmark.seal.fill", german: "die Lösung", marked: "ung", role: "-ung: always die"),
            sentence: "Lösen becomes die Lösung.",
            columns: ["die", "das", "der"],
            rows: [
                Row(label: "endings", cells: ["-ung, -heit, -keit", "-chen, -ment, -um", "-ling, -ismus, -or"]),
                Row(label: "more", cells: ["-schaft, -ion, -tät", "-lein, das Essen", "-ant, -ist"]),
                Row(label: "for example", cells: ["die Freiheit", "das Mädchen", "der Frühling"], marked: [0, 1, 2])
            ]
        ),
        exam: [
            .gap(.easy, "Das ist ___ gute Möglichkeit.", options: ["eine", "ein", "einen"], answer: 0,
                 why: "-keit is always feminine: die Möglichkeit, eine gute Möglichkeit."),
            .gap(.medium, "___ Zentrum ist schön, aber ___ Tourismus ist ein Problem.", prompt: "Fill both gaps.",
                 options: ["Das … der", "Der … die", "Die … das"], answer: 0,
                 why: "-um is neuter: das Zentrum. -ismus is masculine: der Tourismus."),
            .build("The newspaper writes that the situation is improving.",
                   words: ["schreibt,", "die Situation", "Die Zeitung", "verbessert", "dass", "sich", "das Situation"],
                   answers: ["Die Zeitung schreibt, dass sich die Situation verbessert",
                             "Die Zeitung schreibt, dass die Situation sich verbessert"],
                   why: "-ung and -ion are feminine: die Zeitung, die Situation.")
        ]
    )

    static let b2NoArticle = GrammarRule(
        id: "b2-artikel", level: .b2, title: "When there is no article",
        place: "Small talk", systemImage: "bubble.left.and.bubble.right",
        german: "Ich bin Ingenieurin und komme aus Polen.",
        english: "I'm an engineer and I come from Poland.",
        tiles: [Tile(text: "Ich bin"), Tile(text: "Ingenieurin", role: .key), Tile(text: "und komme aus"),
                Tile(text: "Polen.", role: .key)],
        notice: "No article for a job after „sein“, and none for most countries.",
        rule: "No article for jobs and nationalities after sein or werden, most countries and towns, and materials and amounts "
            + "(aus Holz, mit Zucker). With an adjective, the job takes ein: Sie ist eine gute Ärztin.",
        visual: RuleVisual(
            source: Part(systemImage: "person.fill", german: "Sie ist Ärztin.", role: "no article"),
            target: Part(systemImage: "stethoscope", german: "Sie ist eine gute Ärztin.", marked: "eine", role: "with an adjective: ein"),
            sentence: "Sie ist Ärztin. Sie ist eine gute Ärztin.",
            columns: ["article", "example"],
            rows: [
                Row(label: "a job", cells: ["none", "Er ist Koch."]),
                Row(label: "with an adjective", cells: ["ein", "Er ist ein guter Koch."], marked: [0]),
                Row(label: "a material", cells: ["none", "ein Tisch aus Holz"]),
                Row(label: "most countries", cells: ["none", "aus Polen"]),
                Row(label: "some countries", cells: ["die", "aus der Türkei"], marked: [0])
            ]
        ),
        exam: [
            .gap(.easy, "Mein Bruder ist ___ Lehrer.", options: ["–", "ein", "der"], answer: 0,
                 why: "A job after sein takes no article: Er ist Lehrer."),
            .gap(.medium, "___ Schweiz ist schön, aber ich wohne in ___ Österreich.", prompt: "Fill both gaps.",
                 options: ["Die … –", "– … dem", "Die … der"], answer: 0,
                 why: "Most countries have no article, like Österreich. A few have one: die Schweiz, die Türkei."),
            .build("She's a famous singer from Italy.",
                   words: ["aus Italien", "berühmte Sängerin", "Sie ist", "eine", "aus dem Italien"],
                   answers: ["Sie ist eine berühmte Sängerin aus Italien"],
                   why: "With an adjective the job takes ein: eine berühmte Sängerin. Italien has no article.")
        ]
    )

    static let b2Genitive = GrammarRule(
        id: "b2-genitiv", level: .b2, title: "The genitive: des Mannes, der Frau",
        place: "Form from an office", systemImage: "doc.text",
        german: "Bitte geben Sie die Adresse des Arbeitgebers an.",
        english: "Please give your employer's address.",
        tiles: [Tile(text: "Bitte geben Sie die Adresse"), Tile(text: "des", role: .key), Tile(text: "Arbeitgebers", role: .end),
                Tile(text: "an.")],
        notice: "Whose address? „des Arbeitgebers“: a masculine noun takes „des“ and an -s.",
        rule: "The genitive says whose. Masculine and neuter: des and -s or -es on the noun (des Mannes). Feminine and plural: der. "
            + "Names take -s: Annas Auto. In speech, von + dative often replaces it.",
        visual: RuleVisual(
            source: Part(systemImage: "car.fill", german: "das Auto", role: "What?"),
            target: Part(systemImage: "person.fill", german: "des Lehrers", marked: "des", role: "Whose?", name: "Genitive"),
            sentence: "Das Auto des Lehrers.",
            columns: ["masc.", "fem.", "neut.", "plural"],
            rows: [
                Row(label: "der", cells: ["des Mannes", "der Frau", "des Kindes", "der Kinder"], marked: [0, 2]),
                Row(label: "ein", cells: ["eines Mannes", "einer Frau", "eines Kindes", "–"], marked: [0, 2]),
                Row(label: "mein", cells: ["meines", "meiner", "meines", "meiner"])
            ]
        ),
        exam: [
            .gap(.easy, "Das ist das Büro ___ Chefin.", hint: "die Chefin", options: ["der", "des", "die"], answer: 0,
                 why: "A feminine noun takes der in the genitive: das Büro der Chefin."),
            .gap(.medium, "Am Ende ___ ___ gibt es ein Fest.", prompt: "Fill both gaps.", hint: "der Monat",
                 options: ["des … Monats", "dem … Monat", "der … Monate"], answer: 0,
                 why: "der Monat is masculine: des and an -s on the noun, des Monats."),
            .build("The end of the film was sad.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["des Films", "traurig", "Das Ende", "des Film", "war", "der Film"],
                   answers: ["Das Ende des Films war traurig"],
                   why: "der Film is masculine: des, and an -s on the noun as well: des Films.")
        ]
    )

    static let b2NDeclension = GrammarRule(
        id: "b2-n-deklination", level: .b2, title: "The n-declination: den Kunden, dem Kollegen",
        place: "Call to customer service", systemImage: "phone",
        german: "Können Sie bitte den Kunden zurückrufen?",
        english: "Could you call the customer back, please?",
        tiles: [Tile(text: "Können Sie bitte"), Tile(text: "den", role: .key), Tile(text: "Kunden", role: .end),
                Tile(text: "zurückrufen?")],
        notice: "„der Kunde“ takes an -n in every case except the nominative: „den Kunden“.",
        rule: "Some masculine nouns add -n or -en in every case except the nominative: der Kunde, den Kunden, dem Kunden. "
            + "Most end in -e (der Kollege) or are people in -ent, -ist or -and (der Student); also der Herr, der Mensch, der Nachbar.",
        visual: RuleVisual(
            source: Part(systemImage: "person.fill", german: "der Kollege", role: "Who?", name: "Nominative"),
            verb: "+ n",
            target: Part(systemImage: "hand.wave.fill", german: "den Kollegen", marked: "n", role: "every other case"),
            sentence: "Der Kollege. Den Kollegen.",
            columns: ["nom.", "acc.", "dat.", "gen."],
            rows: [
                Row(label: "Kollege", cells: ["Kollege", "Kollegen", "Kollegen", "Kollegen"], marked: [1, 2, 3]),
                Row(label: "Student", cells: ["Student", "Studenten", "Studenten", "Studenten"], marked: [1, 2, 3]),
                Row(label: "Herr", cells: ["Herr", "Herrn", "Herrn", "Herrn"], marked: [1, 2, 3])
            ]
        ),
        exam: [
            .gap(.easy, "Ich habe gestern meinen ___ getroffen.", hint: "der Nachbar", options: ["Nachbar", "Nachbarn", "Nachbars"],
                 answer: 1,
                 why: "der Nachbar takes -n outside the nominative: meinen Nachbarn."),
            .gap(.medium, "Ich gebe ___ ___ das Formular.", prompt: "Fill both gaps.", hint: "der Student",
                 options: ["dem … Studenten", "dem … Student", "den … Student"], answer: 0,
                 why: "He gets the form: dative, dem. And der Student takes -en: dem Studenten."),
            .build("We are waiting for Mr Weber.",
                   words: ["warten", "Herrn Weber", "Wir", "auf", "Herr Weber"],
                   answers: ["Wir warten auf Herrn Weber"],
                   why: "Herr takes -n in every case except the nominative: auf Herrn Weber.")
        ]
    )

    static let b2AdjectiveEndings = GrammarRule(
        id: "b2-adjektivendungen", level: .b2, title: "Adjective endings after der, ein or nothing",
        place: "At the market", systemImage: "cart",
        german: "Ich nehme den frischen Fisch und ein kleines Brot.",
        english: "I'll take the fresh fish and a small loaf.",
        tiles: [Tile(text: "Ich nehme den"), Tile(text: "frischen", role: .end), Tile(text: "Fisch und ein"),
                Tile(text: "kleines", role: .end), Tile(text: "Brot.")],
        notice: "„den“ already shows the case, so the adjective takes -en. „ein“ shows nothing, so the adjective has to: „kleines“.",
        rule: "The case has to show once. After der, die, das the adjective takes -e or -en. After ein, kein or mein it takes "
            + "der's ending where ein has none: ein kleiner Hund, ein kleines Brot. With no article it takes der's ending itself.",
        visual: RuleVisual(
            source: Part(systemImage: "fish.fill", german: "der frische Fisch", marked: "e", role: "after der"),
            target: Part(systemImage: "fish", german: "frischer Fisch", marked: "er", role: "no article"),
            sentence: "Der frische Fisch. Frischer Fisch.",
            columns: ["masc.", "fem.", "neut."],
            rows: [
                Row(label: "der", cells: ["der gute Wein", "die gute Milch", "das gute Brot"]),
                Row(label: "ein", cells: ["ein guter Wein", "eine gute Milch", "ein gutes Brot"], marked: [0, 2]),
                Row(label: "no article", cells: ["guter Wein", "gute Milch", "gutes Brot"], marked: [0, 2])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Ich suche eine ___ Wohnung.", hint: "günstig", options: ["günstige", "günstigen", "günstiger"], answer: 0,
                 why: "„eine“ is feminine accusative, and the adjective takes -e: eine günstige Wohnung."),
            .gap(.medium, "Bei ___ Wetter macht ein ___ Ausflug keinen Spaß.", prompt: "Fill both gaps.", hint: "schlecht · lang",
                 options: ["schlechtem … langer", "schlechten … langen", "schlechtem … langen"], answer: 0,
                 why: "No article, dative: schlechtem, like dem. After ein in the nominative: langer, like der."),
            .build("We have a big garden with old trees.",
                   words: ["alten", "Garten", "Wir haben", "mit", "einen großen", "Bäumen", "alte"],
                   answers: ["Wir haben einen großen Garten mit alten Bäumen"],
                   why: "After einen the adjective takes -en. After mit with no article, the dative plural: alten Bäumen.")
        ]
    )

    static let b2AdjectiveNouns = GrammarRule(
        id: "b2-adjektiv-nomen", level: .b2, title: "Adjectives as nouns: der Bekannte, ein Bekannter",
        place: "Hospital visit", systemImage: "cross.case",
        german: "Die Angehörigen dürfen die Kranken bis 20 Uhr besuchen.",
        english: "Relatives may visit the patients until 8 pm.",
        tiles: [Tile(text: "Die"), Tile(text: "Angehörigen", role: .end), Tile(text: "dürfen die"), Tile(text: "Kranken", role: .end),
                Tile(text: "bis 20 Uhr besuchen.")],
        notice: "„die Kranken“ is the adjective „krank“ used as a noun. It keeps the adjective's ending.",
        rule: "An adjective used as a noun takes a capital letter and keeps its adjective endings: der Bekannte, ein Bekannter. "
            + "After viele, einige or wenige the endings are like no article (viele neue Leute); after alle and beide, -en.",
        visual: RuleVisual(
            source: Part(systemImage: "person.fill", german: "der Deutsche", marked: "e", role: "after der"),
            target: Part(systemImage: "person.fill", german: "ein Deutscher", marked: "er", role: "after ein"),
            sentence: "Der Deutsche. Ein Deutscher.",
            columns: ["after der", "after ein", "plural"],
            rows: [
                Row(label: "deutsch", cells: ["der Deutsche", "ein Deutscher", "Deutsche"], marked: [1]),
                Row(label: "bekannt", cells: ["der Bekannte", "ein Bekannter", "Bekannte"], marked: [1]),
                Row(label: "erwachsen", cells: ["der Erwachsene", "ein Erwachsener", "Erwachsene"], marked: [1])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Mein Mann ist ___.", hint: "deutsch, as a noun", options: ["Deutscher", "Deutsche", "Deutschen"], answer: 0,
                 why: "With no article, a man takes der's ending: Er ist Deutscher."),
            .gap(.medium, "Viele ___ Kollegen kennen alle ___ Regeln noch nicht.", prompt: "Fill both gaps.", hint: "neu · wichtig",
                 options: ["neue … wichtigen", "neuen … wichtige", "neue … wichtige"], answer: 0,
                 why: "After viele, the ending is as if there were no article: neue. After alle it is -en: wichtigen."),
            .build("I met an acquaintance in town.",
                   words: ["Bekannten", "in der Stadt", "Ich habe", "getroffen", "einen", "Bekannter"],
                   answers: ["Ich habe in der Stadt einen Bekannten getroffen", "Ich habe einen Bekannten in der Stadt getroffen"],
                   why: "A man you know, in the accusative after einen: einen Bekannten, like einen netten Mann.")
        ]
    )
}
