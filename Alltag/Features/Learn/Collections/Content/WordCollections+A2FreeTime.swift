//
//  WordCollections+A2FreeTime.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WordCollections {
    // A2, free time: hobbies, sport, going out.
    static let a2Hobbies = WordCollection(
        id: "a2-freizeit", title: "Freizeit und Hobbys", subtitle: "Free time", level: .a2,
        category: .freeTime, systemImage: "paintpalette.fill",
        words: [
            CollectionWord("das ", "Hobby", "hobby",
                           "Was sind deine Hobbys?", "What are your hobbies?"),
            CollectionWord("die ", "Freizeit", "free time",
                           "In meiner Freizeit spiele ich Gitarre.", "In my free time I play the guitar."),
            CollectionWord("das ", "Wochenende", "weekend",
                           "Was machst du am Wochenende?", "What are you doing at the weekend?"),
            CollectionWord("der ", "Verein", "club",
                           "Viele Deutsche sind in einem Verein.", "Lots of Germans belong to a club."),
            CollectionWord("der ", "Ausflug", "day trip, outing",
                           "Am Sonntag machen wir einen Ausflug an den See.", "On Sunday we’re going on a trip to the lake."),
            CollectionWord("das ", "Spiel", "game, match",
                           "Wir schauen das Spiel heute Abend in der Kneipe.", "We’re watching the match in the pub tonight."),
            CollectionWord("die ", "Ausstellung", "exhibition",
                           "Die Ausstellung im Museum läuft bis März.", "The exhibition at the museum runs until March."),
            CollectionWord("das ", "Instrument", "instrument",
                           "Spielst du ein Instrument?", "Do you play an instrument?"),
            CollectionWord("der ", "Spaziergang", "walk",
                           "Nach dem Essen machen wir einen Spaziergang.", "After the meal we go for a walk."),
            CollectionWord("", "Lust haben", "to feel like it",
                           "Hast du Lust, ins Kino zu gehen?", "Do you feel like going to the cinema?"),
            CollectionWord("", "sich interessieren für", "to be interested in",
                           "Ich interessiere mich für Fotografie.", "I’m interested in photography."),
            CollectionWord("", "basteln", "to make things, do crafts",
                           "Die Kinder basteln Laternen für Sankt Martin.", "The children are making lanterns for St Martin’s Day."),
            CollectionWord("", "zeichnen", "to draw",
                           "Sie zeichnet jeden Abend in ihr Skizzenbuch.", "She draws in her sketchbook every evening."),
            CollectionWord("", "faulenzen", "to laze about",
                           "Am Sonntag will ich nur faulenzen.", "On Sunday I just want to laze about."),
            CollectionWord("", "gemütlich", "cosy, relaxed",
                           "Wir hatten einen gemütlichen Abend zu Hause.", "We had a cosy evening at home.")
        ]
    )

    static let a2Sport = WordCollection(
        id: "a2-sport", title: "Sport und Fitness", subtitle: "Sport", level: .a2, category: .freeTime, systemImage: "dumbbell.fill",
        words: [
            CollectionWord("das ", "Fitnessstudio", "gym",
                           "Ich gehe dreimal pro Woche ins Fitnessstudio.", "I go to the gym three times a week."),
            CollectionWord("die ", "Mannschaft", "team",
                           "Unsere Mannschaft hat 2:1 gewonnen.", "Our team won 2–1."),
            CollectionWord("das ", "Training", "training, practice",
                           "Das Training ist dienstags um 18 Uhr.", "Training is on Tuesdays at 6 pm."),
            CollectionWord("der ", "Sportplatz", "sports ground",
                           "Die Kinder spielen auf dem Sportplatz.", "The children are playing on the sports ground."),
            CollectionWord("das ", "Schwimmbad", "swimming pool",
                           "Das Schwimmbad hat bis 22 Uhr geöffnet.", "The swimming pool is open until 10 pm."),
            CollectionWord("das ", "Tor", "goal",
                           "Wer hat das Tor geschossen?", "Who scored the goal?"),
            CollectionWord("der ", "Muskelkater", "aching muscles",
                           "Nach dem Training habe ich Muskelkater.", "My muscles ache after training."),
            CollectionWord("", "joggen", "to jog",
                           "Ich jogge jeden Morgen im Park.", "I go jogging in the park every morning."),
            CollectionWord("", "schwimmen", "to swim",
                           "Kannst du gut schwimmen?", "Are you a good swimmer?"),
            CollectionWord("", "Rad fahren", "to cycle",
                           "Am Wochenende fahren wir oft Rad.", "We often go cycling at the weekend."),
            CollectionWord("", "gewinnen", "to win",
                           "Wer gewinnt heute?", "Who’s going to win today?"),
            CollectionWord("", "verlieren", "to lose",
                           "Wir haben das Spiel knapp verloren.", "We narrowly lost the match."),
            CollectionWord("", "sich bewegen", "to get exercise",
                           "Du solltest dich mehr bewegen.", "You should get more exercise."),
            CollectionWord("", "trainieren", "to train, to work out",
                           "Sie trainiert für einen Marathon.", "She’s training for a marathon."),
            CollectionWord("", "fit", "fit",
                           "Seit ich Rad fahre, bin ich viel fitter.", "Since I started cycling I’m much fitter.")
        ]
    )

    static let a2GoingOut = WordCollection(
        id: "a2-ausgehen", title: "Kino und Konzert", subtitle: "Going out", level: .a2, category: .freeTime, systemImage: "ticket.fill",
        words: [
            CollectionWord("das ", "Kino", "cinema",
                           "Was läuft heute im Kino?", "What’s on at the cinema today?"),
            CollectionWord("der ", "Film", "film",
                           "Welchen Film wollen wir sehen?", "Which film shall we see?"),
            CollectionWord("das ", "Konzert", "concert",
                           "Wie war das Konzert gestern?", "How was the concert yesterday?"),
            CollectionWord("das ", "Theater", "theatre",
                           "Wir haben Karten fürs Theater.", "We’ve got tickets for the theatre."),
            CollectionWord("die ", "Eintrittskarte", "ticket",
                           "Die Eintrittskarten kosten 15 Euro.", "The tickets cost 15 euros."),
            CollectionWord("der ", "Eintritt", "admission",
                           "Der Eintritt ist für Kinder frei.", "Admission is free for children."),
            CollectionWord("die ", "Vorstellung", "performance, showing",
                           "Die Vorstellung beginnt um 20 Uhr.", "The performance starts at 8 pm."),
            CollectionWord("die ", "Reihe", "row",
                           "Wir sitzen in Reihe sieben.", "We’re sitting in row seven."),
            CollectionWord("der ", "Untertitel", "subtitle",
                           "Gibt es den Film auch mit Untertiteln?", "Is the film also showing with subtitles?"),
            CollectionWord("die ", "Band", "band",
                           "Die Band spielt heute in einem kleinen Club.", "The band is playing in a small club tonight."),
            CollectionWord("die ", "Veranstaltung", "event",
                           "Welche Veranstaltungen gibt es am Wochenende?", "What events are on at the weekend?"),
            CollectionWord("", "ausverkauft", "sold out",
                           "Tut mir leid, wir sind ausverkauft.", "Sorry, we’re sold out."),
            CollectionWord("", "ausgehen", "to go out",
                           "Am Samstag gehen wir zusammen aus.", "We’re going out together on Saturday."),
            CollectionWord("", "spannend", "exciting, gripping",
                           "Der Krimi war bis zum Ende spannend.", "The crime film was gripping right to the end."),
            CollectionWord("", "langweilig", "boring",
                           "Das Theaterstück war ziemlich langweilig.", "The play was pretty boring.")
        ]
    )
}
