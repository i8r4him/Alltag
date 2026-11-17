//
//  WordCollections+B1Health.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WordCollections {
    // B1 health: the hospital and living well.

    static let b1Hospital = WordCollection(
        id: "b1-krankenhaus", title: "Im Krankenhaus", subtitle: "At the hospital", level: .b1,
        category: .health, systemImage: "cross.case.fill",
        words: [
            CollectionWord("die ", "Einweisung", "referral to hospital",
                           "Der Hausarzt hat mir eine Einweisung ins Krankenhaus gegeben.", "My GP has referred me to hospital."),
            CollectionWord("die ", "Aufnahme", "admissions",
                           "Melden Sie sich bitte zuerst an der Aufnahme.", "Please go to admissions first."),
            CollectionWord("die ", "Visite", "ward round",
                           "Bei der Visite können Sie dem Arzt Ihre Fragen stellen.",
                           "On the ward round you can ask the doctor your questions."),
            CollectionWord("", "röntgen", "to X-ray",
                           "Das Knie muss geröntgt werden.", "The knee needs an X-ray."),
            CollectionWord("die ", "Infusion", "drip",
                           "Sie bekommt eine Infusion gegen die Schmerzen.", "She’s on a drip for the pain."),
            CollectionWord("", "brechen", "to break",
                           "Ich habe mir das Bein gebrochen.", "I’ve broken my leg."),
            CollectionWord("der ", "Gips", "plaster cast",
                           "Den Gips muss ich sechs Wochen tragen.", "I have to wear the cast for six weeks."),
            CollectionWord("die ", "Wunde", "wound",
                           "Die Wunde muss genäht werden.", "The wound needs stitches."),
            CollectionWord("der ", "Eingriff", "(medical) procedure",
                           "Es ist nur ein kleiner Eingriff.", "It’s only a minor procedure."),
            CollectionWord("die ", "Untersuchung", "examination",
                           "Vor der Untersuchung dürfen Sie nichts essen.", "You mustn’t eat anything before the examination."),
            CollectionWord("der ", "Blutdruck", "blood pressure",
                           "Ihr Blutdruck ist etwas zu hoch.", "Your blood pressure is a bit high."),
            CollectionWord("die ", "Spritze", "injection",
                           "Keine Angst, die Spritze tut kaum weh.", "Don’t worry, the injection hardly hurts."),
            CollectionWord("die ", "Operation", "operation",
                           "Die Operation ist gut gelaufen.", "The operation went well."),
            CollectionWord("die ", "Narkose", "anaesthetic",
                           "Nach der Narkose war ich noch lange müde.", "After the anaesthetic I was tired for a long time."),
            CollectionWord("die ", "Station", "ward",
                           "Sie liegt auf Station 4.", "She’s on ward 4."),
            CollectionWord("die ", "Krankenschwester", "nurse",
                           "Die Krankenschwester bringt Ihnen gleich eine Tablette.", "The nurse will bring you a tablet in a moment."),
            CollectionWord("die ", "Besuchszeit", "visiting hours",
                           "Die Besuchszeit endet um 19 Uhr.", "Visiting hours end at 7 pm."),
            CollectionWord("die ", "Schmerztablette", "painkiller",
                           "Nehmen Sie bei Bedarf eine Schmerztablette.", "Take a painkiller if you need one."),
            CollectionWord("die ", "Nebenwirkung", "side effect",
                           "Das Medikament hat kaum Nebenwirkungen.", "The medicine has hardly any side effects."),
            CollectionWord("", "entlassen", "to discharge",
                           "Morgen werde ich entlassen.", "I’m being discharged tomorrow.")
        ]
    )

    static let b1HealthyLiving = WordCollection(
        id: "b1-gesund", title: "Gesund leben", subtitle: "Healthy living", level: .b1,
        category: .health, systemImage: "figure.mind.and.body",
        words: [
            CollectionWord("die ", "Belastung", "strain, burden",
                           "Die Pflege meiner Mutter ist eine große Belastung.", "Looking after my mother is a big strain."),
            CollectionWord("", "sich entspannen", "to relax",
                           "Beim Yoga kann ich mich gut entspannen.", "I can really relax doing yoga."),
            CollectionWord("der ", "Schlaf", "sleep",
                           "Ich brauche mindestens sieben Stunden Schlaf.", "I need at least seven hours’ sleep."),
            CollectionWord("", "ausgeschlafen", "well rested",
                           "Heute bin ich endlich mal ausgeschlafen.", "Today I’m finally well rested."),
            CollectionWord("", "erschöpft", "exhausted",
                           "Nach der Nachtschicht bin ich völlig erschöpft.", "After the night shift I’m completely exhausted."),
            CollectionWord("das ", "Übergewicht", "being overweight",
                           "Übergewicht kann zu Rückenschmerzen führen.", "Being overweight can lead to back pain."),
            CollectionWord("der ", "Burn-out", "burnout",
                           "Nach dem Burn-out war er drei Monate krankgeschrieben.",
                           "After his burnout he was signed off sick for three months."),
            CollectionWord("", "regelmäßig", "regularly",
                           "Ich gehe regelmäßig schwimmen.", "I go swimming regularly."),
            CollectionWord("das ", "Gewicht", "weight",
                           "Er möchte sein Gewicht halten.", "He wants to keep his weight steady."),
            CollectionWord("", "abnehmen", "to lose weight",
                           "Ich habe fünf Kilo abgenommen.", "I’ve lost five kilos."),
            CollectionWord("", "zunehmen", "to put on weight",
                           "Über die Feiertage habe ich zugenommen.", "I put on weight over the holidays."),
            CollectionWord("die ", "Vitamine", "vitamins (plural)",
                           "Obst und Gemüse haben viele Vitamine.", "Fruit and veg have lots of vitamins."),
            CollectionWord("das ", "Rauchen", "smoking",
                           "Ich habe letztes Jahr mit dem Rauchen aufgehört.", "I gave up smoking last year."),
            CollectionWord("die ", "Gewohnheit", "habit",
                           "Früh aufzustehen ist eine gute Gewohnheit.", "Getting up early is a good habit."),
            CollectionWord("die ", "Haltung", "posture",
                           "Achte beim Sitzen auf deine Haltung.", "Watch your posture when you sit."),
            CollectionWord("die ", "Sucht", "addiction",
                           "Rauchen ist eine Sucht.", "Smoking is an addiction."),
            CollectionWord("der ", "Ausgleich", "balance, way to unwind",
                           "Sport ist für mich ein guter Ausgleich zur Arbeit.", "Sport is a good way for me to balance out work."),
            CollectionWord("", "psychisch", "mental (health)",
                           "Psychische Gesundheit ist genauso wichtig wie körperliche.",
                           "Mental health is just as important as physical health."),
            CollectionWord("die ", "Vorsorgeuntersuchung", "check-up",
                           "Die Vorsorgeuntersuchung zahlt die Krankenkasse.", "Your health insurance pays for the check-up."),
            CollectionWord("die ", "Impfung", "vaccination, jab",
                           "Hast du schon die Impfung gegen Grippe bekommen?", "Have you had your flu jab yet?")
        ]
    )
}
