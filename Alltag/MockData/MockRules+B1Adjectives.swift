//
//  MockRules+B1Adjectives.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The B1 rules, part 7: adjectives without an article, as nouns, at their
/// most, and made from verbs.
extension MockRules {
    static let b1AdjectiveNoArticle = GrammarRule(
        id: "b1-adjektiv-ohne-artikel", level: .b1, title: "Adjectives without an article: frischer Kaffee",
        place: "At the café", systemImage: "cup.and.saucer",
        german: "Heute gibt es frischen Kuchen und heiße Schokolade.",
        english: "Today there's fresh cake and hot chocolate.",
        tiles: [Tile(text: "Heute"), Tile(text: "gibt", role: .verb), Tile(text: "es"), Tile(text: "frischen", role: .end),
                Tile(text: "Kuchen und"), Tile(text: "heiße", role: .end), Tile(text: "Schokolade.")],
        notice: "There's no article, so the adjective shows the case. „es gibt“ takes the accusative: „frischen Kuchen“.",
        rule: "With no article, the adjective takes the ending the article would have had: "
            + "der → -er, die → -e, das → -es, den → -en, dem → -em.",
        visual: RuleVisual(
            source: Part(systemImage: "cup.and.saucer.fill", german: "der Kaffee", marked: "der", role: "with an article"),
            target: Part(systemImage: "mug.fill", german: "frischer Kaffee", marked: "er", role: "the ending shows it"),
            sentence: "der Kaffee, frischer Kaffee",
            columns: ["masc.", "fem.", "neut.", "plural"],
            rows: [
                Row(label: "Who does it?", cells: ["-er", "-e", "-es", "-e"]),
                Row(label: "What?", cells: ["-en", "-e", "-es", "-e"], marked: [0]),
                Row(label: "To whom?", cells: ["-em", "-er", "-em", "-en"], marked: [0, 1, 2, 3])
            ]
        ),
        exam: [
            .gap(.easy, "Ich trinke gern ___ Wasser.", hint: "kalt · das Wasser", options: ["kaltes", "kalte", "kalter"], answer: 0,
                 why: "das Wasser has no article here, so the adjective shows das: kaltes Wasser."),
            .gap(.medium, "Wir suchen ___ Mitarbeiter mit ___ Deutschkenntnissen.", prompt: "Fill both gaps.",
                 hint: "freundlich · gut · both plural", options: ["freundliche … guten", "freundlichen … gute", "freundliche … gute"],
                 answer: 0, why: "A plural object with no article ends in -e, like die: freundliche. "
                     + "mit takes the dative, and the plural dative ends in -en: mit guten Deutschkenntnissen."),
            .build("We drink black tea with warm milk.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["Milch", "schwarzer", "Wir trinken", "warmer", "Tee", "warme", "mit", "schwarzen"],
                   answers: ["Wir trinken schwarzen Tee mit warmer Milch"],
                   why: "der Tee is the object, so der → den shows as -en: schwarzen Tee. "
                       + "mit takes the dative, and die → der shows as -er: warmer Milch.")
        ]
    )

    static let b1AdjectiveNouns = GrammarRule(
        id: "b1-adjektiv-nomen", level: .b1, title: "Adjectives as nouns: der Jugendliche, alles Gute",
        place: "Birthday card", systemImage: "gift",
        german: "Alles Gute zum Geburtstag! Wir wünschen dir nur das Beste.",
        english: "Happy birthday! We wish you all the best.",
        tiles: [Tile(text: "Alles"), Tile(text: "Gute", role: .key), Tile(text: "zum Geburtstag! Wir wünschen dir nur das"),
                Tile(text: "Beste.", role: .key)],
        notice: "„gut“ has become a noun, so it takes a capital letter: „Gute“. But it keeps its adjective ending.",
        rule: "An adjective can be a noun: it takes a capital letter but keeps the endings of an adjective: "
            + "der Jugendliche, ein Jugendlicher. After etwas and nichts it ends in -es: etwas Neues.",
        visual: RuleVisual(
            source: Part(systemImage: "person.fill", german: "ein kranker Mann", role: "adjective + noun"),
            target: Part(systemImage: "cross.case.fill", german: "ein Kranker", marked: "er", role: "the adjective is the noun"),
            sentence: "ein kranker Mann, ein Kranker",
            columns: ["with der", "with ein"],
            rows: [
                Row(label: "jugendlich", cells: ["der Jugendliche", "ein Jugendlicher"], marked: [1]),
                Row(label: "bekannt", cells: ["der Bekannte", "ein Bekannter"], marked: [1]),
                Row(label: "deutsch", cells: ["die Deutsche", "eine Deutsche"])
            ]
        ),
        exam: [
            .gap(.easy, "Gibt es etwas ___?", hint: "neu", options: ["Neues", "neues", "Neue"], answer: 0,
                 why: "After etwas the adjective becomes a noun: a capital letter and -es, etwas Neues."),
            .gap(.medium, "Ein ___ von mir wohnt in Wien. Der ___ arbeitet bei einer Bank.", prompt: "Fill both gaps.",
                 hint: "bekannt", options: ["Bekannter … Bekannte", "Bekannte … Bekannter", "Bekannter … Bekannter"], answer: 0,
                 why: "It keeps the endings of an adjective: after ein it is ein Bekannter, after der it is der Bekannte."),
            .build("The young people meet in the park.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["im Park", "Die Jugendliche", "treffen sich", "Die jugendlichen", "Die Jugendlichen"],
                   answers: ["Die Jugendlichen treffen sich im Park"],
                   why: "jugendlich as a noun takes a capital letter, and in the plural after die it ends in -en: die Jugendlichen.")
        ]
    )

    static let b1Superlative = GrammarRule(
        id: "b1-superlativ", level: .b1, title: "The superlative: am schnellsten, der beste",
        place: "Railway app", systemImage: "iphone",
        german: "Mit dem ICE kommen Sie am schnellsten nach München.",
        english: "The ICE gets you to Munich fastest.",
        tiles: [Tile(text: "Mit dem ICE"), Tile(text: "kommen", role: .verb), Tile(text: "Sie"),
                Tile(text: "am schnellsten", role: .end), Tile(text: "nach München.")],
        notice: "schnell, schneller, am schnellsten. After the verb, the superlative is „am …-sten“.",
        rule: "The superlative adds -(e)st. After a verb it is am …-sten; before a noun it takes an adjective ending: "
            + "der schnellste Zug. A few are irregular: gut, besser, am besten.",
        visual: RuleVisual(
            source: Part(systemImage: "car.fill", german: "schneller", role: "comparative"),
            target: Part(systemImage: "airplane", german: "am schnellsten", marked: "sten", role: "superlative"),
            sentence: "schneller, am schnellsten",
            columns: ["more", "most", "before a noun"],
            rows: [
                Row(label: "schnell", cells: ["schneller", "am schnellsten", "der schnellste"], marked: [1, 2]),
                Row(label: "alt", cells: ["älter", "am ältesten", "der älteste"], marked: [1, 2]),
                Row(label: "gut", cells: ["besser", "am besten", "der beste"], marked: [1, 2]),
                Row(label: "viel", cells: ["mehr", "am meisten", "die meisten"], marked: [1, 2]),
                Row(label: "gern", cells: ["lieber", "am liebsten", "–"], marked: [1])
            ]
        ),
        exam: [
            .gap(.easy, "Im Sommer ist es in Spanien am ___.", hint: "warm", options: ["wärmsten", "warmsten", "wärmeren"], answer: 0,
                 why: "warm takes an umlaut: wärmer, am wärmsten."),
            .gap(.medium, "Das ist ___ Restaurant in der Stadt. Hier isst man ___.", prompt: "Fill both gaps.", hint: "gut",
                 options: ["das beste … am besten", "das guteste … am besten", "das beste … am gutesten"], answer: 0,
                 why: "gut is irregular: besser, best-. Before a noun it is das beste Restaurant, after a verb am besten."),
            .build("Best of all, I like drinking tea.",
                   words: ["Tee", "Am gernsten", "trinke", "Am liebsten", "ich"],
                   answers: ["Am liebsten trinke ich Tee"],
                   why: "gern is irregular: lieber, am liebsten. It fills position 1, so the verb comes next: trinke ich.")
        ]
    )

    static let b1PresentParticiple = GrammarRule(
        id: "b1-partizip-eins", level: .b1, title: "Verb + d as an adjective: spielende Kinder",
        place: "Sign on the street", systemImage: "exclamationmark.triangle",
        german: "Vorsicht, spielende Kinder!",
        english: "Caution, children playing!",
        tiles: [Tile(text: "Vorsicht,"), Tile(text: "spielende", role: .key), Tile(text: "Kinder!")],
        notice: "„spielende“ is „spielen“ + d, used as an adjective: children who are playing right now.",
        rule: "The infinitive + d describes something happening right now: spielend, schlafend. "
            + "Before a noun it takes an adjective ending: das schlafende Baby.",
        visual: RuleVisual(
            source: Part(systemImage: "moon.zzz.fill", german: "Das Baby schläft.", role: "it's happening"),
            target: Part(systemImage: "bed.double.fill", german: "das schlafende Baby", marked: "schlafende",
                         role: "describes the noun"),
            sentence: "Das Baby schläft. Das schlafende Baby.",
            columns: ["+ d", "before a noun"],
            rows: [
                Row(label: "spielen", cells: ["spielend", "spielende Kinder"], marked: [0]),
                Row(label: "schlafen", cells: ["schlafend", "das schlafende Baby"], marked: [0]),
                Row(label: "kommen", cells: ["kommend", "die kommende Woche"], marked: [0]),
                Row(label: "laufen", cells: ["laufend", "laufende Kosten"], marked: [0])
            ]
        ),
        exam: [
            .gap(.easy, "Vorsicht, ___ Hund!", hint: "bellen", options: ["bellender", "gebellter", "bellen"], answer: 0,
                 why: "A dog that is barking right now: bellen + d, with the ending of der and no article: bellender Hund."),
            .gap(.medium, "Die ___ Kinder spielen im Garten, und das ___ Baby liegt im Bett.", prompt: "Fill both gaps.",
                 hint: "lachen · schlafen", options: ["lachenden … schlafende", "lachende … schlafenden", "gelachten … geschlafene"],
                 answer: 0, why: "Both are happening right now: + d. After die in the plural the ending is -en, after das it is -e."),
            .build("The rising prices are a problem.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["sind", "steigende", "Preise", "ein Problem", "steigend", "Die", "steigenden"],
                   answers: ["Die steigenden Preise sind ein Problem"],
                   why: "Prices that are rising right now: steigen + d. After die in the plural it ends in -en: steigenden.")
        ]
    )
}
