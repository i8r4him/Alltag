//
//  MockRules+B2Passive.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The B2 rules, part 3: the passive in every tense, with modal verbs, and
/// what to say instead.
extension MockRules {
    static let b2PassiveTenses = GrammarRule(
        id: "b2-passiv", level: .b2, title: "The passive in every tense",
        place: "Letter from your landlord", systemImage: "envelope",
        german: "Die Heizung ist gestern repariert worden.",
        english: "The heating was repaired yesterday.",
        tiles: [Tile(text: "Die Heizung"), Tile(text: "ist", role: .verb), Tile(text: "gestern"), Tile(text: "repariert", role: .end),
                Tile(text: "worden.", role: .key)],
        notice: "In the Perfekt passive, „werden“ becomes „worden“, not „geworden“, and it takes „ist“.",
        rule: "The passive is werden + participle in every tense: wird gemacht, wurde gemacht, ist gemacht worden, "
            + "war gemacht worden. Add the doer only if it matters, with von + dative.",
        visual: RuleVisual(
            source: Part(systemImage: "wrench.and.screwdriver.fill", german: "Er repariert sie.", role: "active: who does it"),
            target: Part(systemImage: "checkmark.circle.fill", german: "Sie wird repariert.", marked: "wird",
                         role: "passive: what happens"),
            sentence: "Er repariert sie. Sie wird repariert.",
            columns: ["die Heizung …"],
            rows: [
                Row(label: "Präsens", cells: ["wird repariert"]),
                Row(label: "Präteritum", cells: ["wurde repariert"]),
                Row(label: "Perfekt", cells: ["ist repariert worden"], marked: [0]),
                Row(label: "Plusquamperfekt", cells: ["war repariert worden"], marked: [0]),
                Row(label: "Futur", cells: ["wird repariert werden"])
            ]
        ),
        exam: [
            .gap(.easy, "Das Paket ___ gestern geliefert.", options: ["wird", "wurde", "worden"], answer: 1,
                 why: "„gestern“ is the past, and the simple past of werden is wurde."),
            .gap(.medium, "Der Vertrag ist schon ___ ___.", prompt: "Fill both gaps.", hint: "unterschreiben",
                 options: ["unterschrieben … worden", "unterschrieben … geworden", "unterschreiben … worden"], answer: 0,
                 why: "Perfekt passive: ist + participle + worden. „geworden“ is only for werden meaning „become“."),
            .build("The new hospital will be opened in May.", prompt: "Build it in the future tense. One tile is left over.",
                   words: ["werden", "Das neue Krankenhaus", "eröffnet", "im Mai", "wird", "worden"],
                   answers: ["Das neue Krankenhaus wird im Mai eröffnet werden"],
                   why: "Future passive: wird in position 2, then participle + werden at the end. "
                    + "„worden“ belongs to the Perfekt.")
        ]
    )

    static let b2PassiveModal = GrammarRule(
        id: "b2-passiv-modal", level: .b2, title: "The passive with modal verbs",
        place: "Notice in your building", systemImage: "building.2",
        german: "Die Fahrräder müssen bis Freitag aus dem Keller entfernt werden.",
        english: "The bikes must be removed from the cellar by Friday.",
        tiles: [Tile(text: "Die Fahrräder"), Tile(text: "müssen", role: .verb), Tile(text: "bis Freitag aus dem Keller"),
                Tile(text: "entfernt werden.", role: .end)],
        notice: "The modal verb is in position 2. At the end: the participle and „werden“.",
        rule: "Passive with a modal verb: the modal verb in position 2, participle + werden at the end. "
            + "In the past only the modal verb changes: musste … entfernt werden.",
        visual: RuleVisual(
            source: Part(systemImage: "2.circle.fill", german: "muss", marked: "muss", role: "Position 2: the modal verb"),
            target: Part(systemImage: "arrow.right.to.line", german: "repariert werden", marked: "werden",
                         role: "The end: participle + werden"),
            sentence: "Das Auto muss repariert werden.",
            columns: ["das Auto …"],
            rows: [
                Row(label: "now", cells: ["muss repariert werden"], marked: [0]),
                Row(label: "past", cells: ["musste repariert werden"], marked: [0]),
                Row(label: "after dass", cells: ["…, dass es repariert werden muss"])
            ]
        ),
        exam: [
            .gap(.easy, "Der Antrag muss bis Montag ___ werden.", hint: "abgeben", options: ["abgeben", "abgegeben", "abgegebt"],
                 answer: 1,
                 why: "The passive needs the participle before werden: abgegeben werden."),
            .gap(.medium, "Hier ___ nicht geraucht ___.", prompt: "Fill both gaps.",
                 options: ["darf … werden", "darf … worden", "wird … dürfen"], answer: 0,
                 why: "The modal verb takes position 2, and the participle + werden go to the end."),
            .build("The documents had to be translated.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["mussten", "Die Unterlagen", "worden", "übersetzt", "müssen", "werden"],
                   answers: ["Die Unterlagen mussten übersetzt werden"],
                   why: "In the past only the modal verb changes: mussten. The end stays „übersetzt werden“.")
        ]
    )

    static let b2PassiveAlternatives = GrammarRule(
        id: "b2-passiv-ersatz", level: .b2, title: "Instead of the passive: lässt sich, -bar, ist zu",
        place: "Instructions in the box", systemImage: "shippingbox",
        german: "Der Tisch lässt sich ohne Werkzeug aufbauen.",
        english: "The table can be put together without tools.",
        tiles: [Tile(text: "Der Tisch"), Tile(text: "lässt sich", role: .key), Tile(text: "ohne Werkzeug"),
                Tile(text: "aufbauen.", role: .end)],
        notice: "„lässt sich aufbauen“ means the same as „kann aufgebaut werden“, and it's shorter.",
        rule: "Instead of kann … werden: lässt sich + infinitive, or an adjective with -bar. "
            + "Instead of muss … werden: ist zu + infinitive.",
        visual: RuleVisual(
            source: Part(systemImage: "hammer.fill", german: "kann aufgebaut werden", role: "passive"),
            target: Part(systemImage: "checkmark.circle.fill", german: "lässt sich aufbauen", marked: "lässt sich", role: "shorter"),
            sentence: "Kann aufgebaut werden becomes lässt sich aufbauen.",
            columns: ["instead of", "say"],
            rows: [
                Row(label: "lässt sich", cells: ["kann gelesen werden", "lässt sich lesen"], marked: [1]),
                Row(label: "-bar", cells: ["kann gelesen werden", "ist lesbar"], marked: [1]),
                Row(label: "ist zu", cells: ["muss bezahlt werden", "ist zu bezahlen"], marked: [1])
            ]
        ),
        exam: [
            .gap(.easy, "Das Fenster ___ nicht öffnen.", options: ["lässt sich", "ist zu", "wird"], answer: 0,
                 why: "lässt sich + infinitive: the window can't be opened."),
            .gap(.medium, "Die Rechnung ist bis zum 30. ___. Das Wasser hier ist nicht ___.", prompt: "Fill both gaps.",
                 options: ["zu bezahlen … trinkbar", "bezahlt … trinkbar", "zu bezahlen … zu trinkbar"], answer: 0,
                 why: "ist zu + infinitive means it must be paid. -bar turns trinken into trinkbar: it can be drunk."),
            .build("This problem can be solved easily.",
                   words: ["lösen", "Dieses Problem", "leicht", "sich", "lässt", "gelöst"],
                   answers: ["Dieses Problem lässt sich leicht lösen"],
                   why: "lässt sich + infinitive: the infinitive „lösen“ goes to the end. „gelöst“ would need werden.")
        ]
    )
}
