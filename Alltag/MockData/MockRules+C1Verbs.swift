//
//  MockRules+C1Verbs.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The C1 rules, part 1: the tenses, modal verbs that guess or report, verbs
/// with a prefix that can split or not, and verbs with the genitive.
extension MockRules {
    static let c1Tenses = GrammarRule(
        id: "c1-zeitformen", level: .c1, title: "All six tenses on one timeline",
        place: "Email from work", systemImage: "at",
        german: "Bis Freitag werden wir das Projekt abgeschlossen haben.",
        english: "By Friday we will have finished the project.",
        tiles: [Tile(text: "Bis Freitag"), Tile(text: "werden", role: .verb), Tile(text: "wir das Projekt"),
                Tile(text: "abgeschlossen haben", role: .end)],
        notice: "This is Futur II: it looks back from a point in the future. By Friday, the work will be done.",
        rule: "Plusquamperfekt is the past before the past (hatte gemacht). Futur II is what will be done by a point "
            + "in the future, or a guess about the past (wird gemacht haben).",
        visual: RuleVisual(
            source: Part(systemImage: "clock.arrow.circlepath", german: "Er hatte gegessen.", marked: "hatte gegessen",
                         role: "before the past", name: "Plusquamperfekt"),
            target: Part(systemImage: "calendar.badge.clock", german: "Er wird gegessen haben.", marked: "gegessen haben",
                         role: "done by then", name: "Futur II"),
            sentence: "Er hatte gegessen. Er wird gegessen haben.",
            columns: ["machen", "kommen"],
            rows: [
                Row(label: "Präsens", cells: ["mache", "komme"]),
                Row(label: "Präteritum", cells: ["machte", "kam"]),
                Row(label: "Perfekt", cells: ["habe gemacht", "bin gekommen"]),
                Row(label: "Plusquamperfekt", cells: ["hatte gemacht", "war gekommen"], marked: [0, 1]),
                Row(label: "Futur I", cells: ["werde machen", "werde kommen"]),
                Row(label: "Futur II", cells: ["werde gemacht\nhaben", "werde gekommen\nsein"], marked: [0, 1])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Nachdem wir gegessen ___, gingen wir spazieren.", options: ["haben", "hatten", "hätten"], answer: 1,
                 why: "The meal came before the walk, and the walk is told in the Präteritum. "
                    + "What happened before a past event takes the Plusquamperfekt: hatten gegessen."),
            .gap(.medium, "Bis morgen ___ der Brief sicher ___.", prompt: "Fill both gaps.",
                 options: ["wird … angekommen haben", "wird … angekommen sein", "ist … angekommen werden"], answer: 1,
                 why: "Futur II is werden + participle + haben or sein. ankommen is movement, so it takes sein."),
            .build("When I got to the station, the train had already left.",
                   words: ["Als ich", "war", "am Bahnhof ankam,", "der Zug", "hatte", "schon", "abgefahren"],
                   answers: ["Als ich am Bahnhof ankam, war der Zug schon abgefahren"],
                   why: "The train left before you arrived: Plusquamperfekt. abfahren is movement, so it takes war, not hatte. "
                    + "The als-clause fills position 1, so the verb comes next: war der Zug.")
        ]
    )

    static let c1PastGuess = GrammarRule(
        id: "c1-vermutung", level: .c1, title: "Guessing about the past: muss gewesen sein",
        place: "Coming home", systemImage: "house",
        german: "Die Tür ist offen. Jemand muss hier gewesen sein.",
        english: "The door is open. Someone must have been here.",
        tiles: [Tile(text: "Jemand"), Tile(text: "muss", role: .verb), Tile(text: "hier"),
                Tile(text: "gewesen sein", role: .end)],
        notice: "Nobody had to do anything. „muss … gewesen sein“ is a guess, nearly sure, about what happened.",
        rule: "A modal verb with participle + haben or sein guesses about the past: muss is nearly sure, dürfte likely, "
            + "könnte possible, and kann nicht impossible.",
        visual: RuleVisual(
            source: Part(systemImage: "eye", german: "Die Straße ist nass.", role: "What you see"),
            verb: "so",
            target: Part(systemImage: "cloud.rain", german: "Es muss geregnet haben.", marked: "muss",
                         role: "Your guess", name: "nearly sure"),
            sentence: "Die Straße ist nass. Es muss geregnet haben.",
            columns: ["how sure", "example"],
            rows: [
                Row(label: "muss", cells: ["nearly sure", "muss geregnet\nhaben"], marked: [1]),
                Row(label: "dürfte", cells: ["likely", "dürfte geregnet\nhaben"], marked: [1]),
                Row(label: "könnte", cells: ["possible", "könnte geregnet\nhaben"], marked: [1]),
                Row(label: "kann nicht", cells: ["impossible", "kann nicht\ngeregnet haben"], marked: [1])
            ]
        ),
        exam: [
            .gap(.easy, "Das Licht ist aus. Sie ___ schon ins Bett gegangen sein.", options: ["muss", "hat", "ist"], answer: 0,
                 why: "„gegangen sein“ at the end needs a modal verb in position 2. „muss“ makes it a guess: "
                    + "she has almost certainly gone to bed."),
            .gap(.medium, prompt: "Which sentence is a guess, not a duty?",
                 options: ["Er hat das Fenster offen lassen müssen.", "Er musste das Fenster offen lassen.",
                           "Er muss das Fenster offen gelassen haben."], answer: 2,
                 why: "Modal verb + participle + haben is the guess: he has probably left it open. "
                    + "„hat … lassen müssen“ and „musste … lassen“ say he was told to."),
            .build("She can't have read the letter.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["Sie", "muss", "den Brief", "kann", "nicht", "hat", "gelesen", "haben"],
                   answers: ["Sie kann den Brief nicht gelesen haben"],
                   why: "„kann nicht“ + participle + haben says it is impossible. "
                    + "„muss nicht“ would only say she didn't have to have read it.")
        ]
    )

    static let c1Claims = GrammarRule(
        id: "c1-sollen-wollen", level: .c1, title: "sollen and wollen: what others say, what you claim",
        place: "News headline", systemImage: "newspaper",
        german: "Der Zeuge will nichts gesehen haben.",
        english: "The witness claims to have seen nothing.",
        tiles: [Tile(text: "Der Zeuge"), Tile(text: "will", role: .verb), Tile(text: "nichts"),
                Tile(text: "gesehen haben", role: .end)],
        notice: "„will“ isn't a wish here. The witness says it about himself, and the paper doesn't vouch for it.",
        rule: "sollen passes on what others say: a rumour or a demand. wollen passes on what someone claims about "
            + "themselves. For the past, add participle + haben or sein.",
        visual: RuleVisual(
            source: Part(systemImage: "person.2.fill", german: "Er soll es gewusst haben.", marked: "soll",
                         role: "others say so"),
            target: Part(systemImage: "person.fill", german: "Er will es gewusst haben.", marked: "will",
                         role: "he says so himself"),
            sentence: "Er soll es gewusst haben. Er will es gewusst haben.",
            columns: ["who says it", "example"],
            rows: [
                Row(label: "sollen", cells: ["others: a rumour", "Sie soll reich\nsein."], marked: [1]),
                Row(label: "wollen", cells: ["the person", "Er will nichts\ngehört haben."], marked: [1]),
                Row(label: "„Ich soll …“", cells: ["others: a demand", "Ich soll dich\nanrufen."], marked: [1])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Man sagt, das Restaurant ist gut. → Das Restaurant ___ gut sein.",
                 options: ["will", "soll", "muss"], answer: 1,
                 why: "Other people say so, so it's sollen. wollen would mean the restaurant claims it itself."),
            .gap(.medium, "Er behauptet, er habe das Geld gefunden. → Er ___ das Geld ___.", prompt: "Fill both gaps.",
                 options: ["soll … gefunden haben", "will … finden haben", "will … gefunden haben"], answer: 2,
                 why: "He says it about himself: wollen. The finding is in the past: participle + haben."),
            .build("The film is said to have cost 200 million.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["Der Film", "will", "soll", "200 Millionen", "hat", "gekostet", "haben"],
                   answers: ["Der Film soll 200 Millionen gekostet haben"],
                   why: "Others say so: soll. The cost is in the past, so participle + haben go to the end.")
        ]
    )

    static let c1PrefixVerbs = GrammarRule(
        id: "c1-trennbar", level: .c1, title: "umfahren or umfahren: split or not",
        place: "Driving lesson", systemImage: "car.fill",
        german: "Er hat das Schild umgefahren, statt es zu umfahren.",
        english: "He knocked the sign over instead of driving around it.",
        tiles: [Tile(text: "Er hat das Schild"), Tile(text: "umgefahren,", role: .end), Tile(text: "statt es zu"),
                Tile(text: "umfahren", role: .key)],
        notice: "Stressed on „um“, the verb splits and means knock over: umgefahren. "
            + "Stressed on „fahren“, it stays together and means drive around: umfahren.",
        rule: "With durch, über, um, unter and wieder, a stressed prefix splits off and gets ge- in the middle (literal). "
            + "A stressed verb keeps its prefix and has no ge- (often figurative).",
        visual: RuleVisual(
            source: Part(systemImage: "car.fill", german: "Er fährt das Schild um.", marked: "um",
                         role: "knocks it over", name: "splits"),
            target: Part(systemImage: "arrow.triangle.turn.up.right.diamond", german: "Er umfährt das Schild.",
                         marked: "umfährt", role: "drives around it", name: "stays together"),
            sentence: "Er fährt das Schild um. Er umfährt das Schild.",
            columns: ["splits", "stays together"],
            rows: [
                Row(label: "um", cells: ["umgefahren\nknocked over", "umfahren\ndriven around"], marked: [0]),
                Row(label: "über", cells: ["übergesetzt\nferried across", "übersetzt\ntranslated"], marked: [0]),
                Row(label: "wieder", cells: ["wiedergeholt\nfetched back", "wiederholt\nrepeated"], marked: [0]),
                Row(label: "unter", cells: ["untergestellt\nsheltered", "unterstellt\nimplied"], marked: [0])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Der Dolmetscher hat die Rede ins Deutsche ___.",
                 options: ["übergesetzt", "übersetzt", "geübersetzt"], answer: 1,
                 why: "Translating is the figurative übersetzen: the prefix stays on and there is no ge-: übersetzt."),
            .gap(.medium, "Wir haben den Stau ___, aber ein Lkw hat einen Pfosten ___.", prompt: "Fill both gaps.",
                 options: ["umgefahren … umfahren", "umfahren … umgefahren", "umgefahren … umgefahren"], answer: 1,
                 why: "Driving around the jam: umfáhren, no ge-. Knocking a post over: úmfahren, ge- in the middle."),
            .build("The ferry took us across in ten minutes.",
                   words: ["Die Fähre", "übersetzte", "setzte", "uns", "in zehn Minuten", "über"],
                   answers: ["Die Fähre setzte uns in zehn Minuten über"],
                   why: "Taking across is the literal meaning, so the verb splits and über goes to the end. "
                    + "„übersetzte“ would mean translated.")
        ]
    )

    static let c1GenitiveVerbs = GrammarRule(
        id: "c1-genitivverben", level: .c1, title: "Verbs with the genitive",
        place: "Court report in the paper", systemImage: "newspaper",
        german: "Der Angeklagte wurde des Betrugs beschuldigt.",
        english: "The defendant was accused of fraud.",
        tiles: [Tile(text: "Der Angeklagte wurde"), Tile(text: "des Betrugs", role: .end),
                Tile(text: "beschuldigt", role: .key)],
        notice: "„beschuldigen“ takes the person in the accusative and the deed in the genitive: des Betrugs.",
        rule: "A few formal verbs take a genitive: bedürfen, gedenken, sich bedienen, sich enthalten. "
            + "Legal verbs add it to a person: jemanden einer Sache beschuldigen, verdächtigen, überführen.",
        visual: RuleVisual(
            source: Part(systemImage: "person.fill", german: "den Mann", role: "Whom?", name: "Accusative"),
            verb: "verdächtigt",
            target: Part(systemImage: "banknote", german: "des Diebstahls", marked: "des", role: "Of what?", name: "Genitive"),
            sentence: "Man verdächtigt den Mann des Diebstahls.",
            columns: ["+ genitive"],
            rows: [
                Row(label: "bedürfen", cells: ["einer Erklärung"], marked: [0]),
                Row(label: "gedenken", cells: ["der Opfer"], marked: [0]),
                Row(label: "sich bedienen", cells: ["eines Tricks"], marked: [0]),
                Row(label: "sich enthalten", cells: ["der Stimme"], marked: [0]),
                Row(label: "beschuldigen", cells: ["jemanden des Mordes"], marked: [0])
            ]
        ),
        exam: [
            .gap(.easy, "Die Sache bedarf ___ Prüfung.", hint: "die Prüfung",
                 options: ["eine genaue", "einer genauen", "einer genaue"], answer: 1,
                 why: "bedürfen takes the genitive. die Prüfung is feminine: einer genauen Prüfung."),
            .gap(.medium, "Am Sonntag gedenkt die Stadt ___ des Krieges.", hint: "die Opfer (plural)",
                 options: ["den Opfern", "die Opfer", "der Opfer"], answer: 2,
                 why: "gedenken takes the genitive, and the genitive plural is der: der Opfer. "
                    + "„den Opfern“ is the dative, which you'll hear but not read in the news."),
            .build("The police suspect the neighbour of theft.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["Die Polizei", "dem Nachbarn", "verdächtigt", "den Nachbarn", "des Diebstahls", "den Diebstahl"],
                   answers: ["Die Polizei verdächtigt den Nachbarn des Diebstahls"],
                   why: "verdächtigen: the person in the accusative (den Nachbarn), the deed in the genitive (des Diebstahls).")
        ]
    )
}
