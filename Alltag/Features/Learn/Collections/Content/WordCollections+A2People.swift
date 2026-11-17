//
//  WordCollections+A2People.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WordCollections {
    // A2, people: friends, celebrations, feelings.
    static let a2Friends = WordCollection(
        id: "a2-freunde", title: "Freunde treffen", subtitle: "Meeting friends", level: .a2,
        category: .people, systemImage: "person.2.fill",
        words: [
            CollectionWord("die ", "Verabredung", "plans to meet, date",
                           "Ich habe heute Abend eine Verabredung.", "I’ve got plans to meet someone tonight."),
            CollectionWord("der ", "Treffpunkt", "meeting point",
                           "Unser Treffpunkt ist vor dem Kino.", "Our meeting point is in front of the cinema."),
            CollectionWord("der ", "Freundeskreis", "circle of friends",
                           "In meinem Freundeskreis sprechen alle Deutsch.", "Everyone in my circle of friends speaks German."),
            CollectionWord("der ", "Bekannte", "acquaintance",
                           "Er ist kein Freund, nur ein Bekannter.", "He isn’t a friend, just an acquaintance."),
            CollectionWord("die ", "Kneipe", "pub",
                           "Wir gehen nach der Arbeit noch in die Kneipe.", "We’re going to the pub after work."),
            CollectionWord("der ", "Vorschlag", "suggestion",
                           "Hast du einen besseren Vorschlag?", "Have you got a better suggestion?"),
            CollectionWord("", "Zeit haben", "to be free",
                           "Hast du am Freitag Zeit?", "Are you free on Friday?"),
            CollectionWord("", "sich verabreden", "to arrange to meet",
                           "Wir haben uns für Samstag verabredet.", "We’ve arranged to meet on Saturday."),
            CollectionWord("", "vorbeikommen", "to drop by",
                           "Komm doch morgen vorbei!", "Why don’t you drop by tomorrow?"),
            CollectionWord("", "absagen", "to cancel",
                           "Tut mir leid, ich muss leider absagen.", "Sorry, I’m afraid I have to cancel."),
            CollectionWord("", "sich verspäten", "to be late",
                           "Ich verspäte mich zehn Minuten.", "I’m running ten minutes late."),
            CollectionWord("", "abholen", "to pick up",
                           "Soll ich dich vom Bahnhof abholen?", "Shall I pick you up from the station?"),
            CollectionWord("", "Bescheid sagen", "to let someone know",
                           "Sag mir Bescheid, wenn du da bist.", "Let me know when you’re there."),
            CollectionWord("", "sich freuen auf", "to look forward to",
                           "Ich freue mich auf das Wochenende mit euch.", "I’m looking forward to the weekend with you."),
            CollectionWord("", "spontan", "on the spur of the moment",
                           "Wollen wir spontan essen gehen?", "Shall we go out to eat on the spur of the moment?")
        ]
    )

    static let a2Celebrations = WordCollection(
        id: "a2-feste", title: "Feste und Feiern", subtitle: "Celebrations", level: .a2, category: .people, systemImage: "gift.fill",
        words: [
            CollectionWord("der ", "Glückwunsch", "congratulations",
                           "Herzlichen Glückwunsch zum Geburtstag!", "Happy birthday!"),
            CollectionWord("die ", "Einladung", "invitation",
                           "Danke für die Einladung, ich komme gern.", "Thanks for the invitation, I’d love to come."),
            CollectionWord("das ", "Geschenk", "present",
                           "Wir haben ein kleines Geschenk für dich.", "We’ve got a little present for you."),
            CollectionWord("die ", "Party", "party",
                           "Die Party fängt um acht an.", "The party starts at eight."),
            CollectionWord("die ", "Feier", "celebration",
                           "Die Feier war wirklich schön.", "The celebration was really lovely."),
            CollectionWord("die ", "Hochzeit", "wedding",
                           "Meine Schwester feiert im Juni Hochzeit.", "My sister is getting married in June."),
            CollectionWord("", "Weihnachten", "Christmas",
                           "Weihnachten fahren wir zu meinen Eltern.", "At Christmas we’re going to my parents’."),
            CollectionWord("", "Silvester", "New Year’s Eve",
                           "An Silvester gibt es um Mitternacht ein Feuerwerk.", "On New Year’s Eve there are fireworks at midnight."),
            CollectionWord("", "Ostern", "Easter",
                           "An Ostern suchen die Kinder Eier im Garten.", "At Easter the children look for eggs in the garden."),
            CollectionWord("die ", "Kerze", "candle",
                           "Puste die Kerzen aus!", "Blow out the candles!"),
            CollectionWord("die ", "Torte", "gateau, cake",
                           "Die Torte hat meine Oma gebacken.", "My grandma baked the cake."),
            CollectionWord("", "feiern", "to celebrate",
                           "Wir feiern am Samstag meinen Dreißigsten.", "We’re celebrating my thirtieth on Saturday."),
            CollectionWord("", "einladen", "to invite",
                           "Ich lade dich zu meiner Party ein.", "I’m inviting you to my party."),
            CollectionWord("", "gratulieren", "to congratulate",
                           "Wir gratulieren euch zur Hochzeit!", "Congratulations on your wedding!"),
            CollectionWord("", "anstoßen", "to drink a toast",
                           "Lasst uns auf das Brautpaar anstoßen!", "Let’s drink a toast to the bride and groom!")
        ]
    )

    static let a2Feelings = WordCollection(
        id: "a2-gefuehle", title: "Gefühle", subtitle: "Feelings", level: .a2, category: .people, systemImage: "heart.fill",
        words: [
            CollectionWord("das ", "Gefühl", "feeling",
                           "Ich habe ein gutes Gefühl bei der Prüfung.", "I’ve got a good feeling about the exam."),
            CollectionWord("die ", "Angst", "fear",
                           "Mein Sohn hat Angst vor Hunden.", "My son is scared of dogs."),
            CollectionWord("die ", "Laune", "mood",
                           "Du hast heute aber gute Laune!", "You’re in a good mood today!"),
            CollectionWord("der ", "Stress", "stress",
                           "Bei der Arbeit habe ich gerade viel Stress.", "I’m under a lot of stress at work right now."),
            CollectionWord("die ", "Sorge", "worry",
                           "Mach dir keine Sorgen!", "Don’t worry!"),
            CollectionWord("das ", "Heimweh", "homesickness",
                           "Im ersten Winter hatte ich oft Heimweh.", "In my first winter I was often homesick."),
            CollectionWord("", "glücklich", "happy",
                           "Sie ist in ihrer neuen Stadt sehr glücklich.", "She’s very happy in her new city."),
            CollectionWord("", "traurig", "sad",
                           "Warum bist du so traurig?", "Why are you so sad?"),
            CollectionWord("", "erschöpft", "exhausted",
                           "Nach der Nachtschicht bin ich total erschöpft.", "After the night shift I’m completely exhausted."),
            CollectionWord("", "nervös", "nervous",
                           "Vor dem Vorstellungsgespräch war ich sehr nervös.", "I was very nervous before the interview."),
            CollectionWord("", "sauer", "cross, annoyed",
                           "Bist du sauer auf mich?", "Are you cross with me?"),
            CollectionWord("", "stolz", "proud",
                           "Wir sind sehr stolz auf dich.", "We’re very proud of you."),
            CollectionWord("", "enttäuscht", "disappointed",
                           "Ich bin ein bisschen enttäuscht von dem Film.", "I’m a bit disappointed with the film."),
            CollectionWord("", "sich ärgern", "to be annoyed",
                           "Ich ärgere mich über den Lärm von nebenan.", "I’m annoyed about the noise next door."),
            CollectionWord("", "sich freuen über", "to be pleased about",
                           "Sie hat sich sehr über die Blumen gefreut.", "She was really pleased with the flowers.")
        ]
    )
}
