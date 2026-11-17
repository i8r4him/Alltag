//
//  WordCollections+A1.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WordCollections {
    /// A1: the everyday basics, from greetings and the family to the station and
    /// filling in a form. Each collection has fifteen words with an everyday sentence.
    static let a1: [WordCollection] = [
        a1Greetings, a1AboutMe, a1Family, a1Time, a1Day, a1Calendar, a1Food, a1Cafe, a1Supermarket, a1Clothes, a1Home,
        a1Body, a1Town, a1Station, a1Jobs, a1FreeTime, a1Forms
    ]

    static let a1Greetings = WordCollection(
        id: "a1-hallo", title: "Hallo und Tschüss", subtitle: "Greetings", level: .a1,
        category: .people, systemImage: "hand.wave.fill",
        words: [
            CollectionWord("", "Hallo", "hello, hi",
                           "Hallo, ich bin Lena.", "Hi, I’m Lena."),
            CollectionWord("", "Guten Morgen", "good morning",
                           "Guten Morgen, Frau Schmidt!", "Good morning, Mrs Schmidt!"),
            CollectionWord("", "Guten Tag", "hello (polite)",
                           "Guten Tag, wie kann ich Ihnen helfen?", "Hello, how can I help you?"),
            CollectionWord("", "Guten Abend", "good evening",
                           "Guten Abend, haben Sie reserviert?", "Good evening, have you booked a table?"),
            CollectionWord("", "Gute Nacht", "good night",
                           "Gute Nacht, schlaf gut!", "Good night, sleep well!"),
            CollectionWord("", "Tschüss", "bye",
                           "Tschüss, bis morgen!", "Bye, see you tomorrow!"),
            CollectionWord("", "Auf Wiedersehen", "goodbye (polite)",
                           "Vielen Dank und auf Wiedersehen!", "Thank you very much, and goodbye!"),
            CollectionWord("", "bis später", "see you later",
                           "Ich muss los, bis später!", "I have to go, see you later!"),
            CollectionWord("", "Wie geht es dir?", "how are you?",
                           "Hallo Tom, wie geht es dir?", "Hi Tom, how are you?"),
            CollectionWord("", "danke", "thank you, thanks",
                           "Danke für deine Hilfe!", "Thanks for your help!"),
            CollectionWord("", "bitte", "please; you’re welcome",
                           "Einen Kaffee, bitte.", "A coffee, please."),
            CollectionWord("", "Entschuldigung", "excuse me, sorry",
                           "Entschuldigung, wo ist der Bahnhof?", "Excuse me, where’s the station?"),
            CollectionWord("", "herzlich willkommen", "welcome",
                           "Herzlich willkommen in Berlin!", "Welcome to Berlin!"),
            CollectionWord("", "Freut mich", "nice to meet you",
                           "Ich bin Ali. — Freut mich!", "I’m Ali. — Nice to meet you!"),
            CollectionWord("", "Schönes Wochenende", "have a nice weekend",
                           "Schönes Wochenende, bis Montag!", "Have a nice weekend, see you on Monday!")
        ]
    )

    static let a1AboutMe = WordCollection(
        id: "a1-ich", title: "Über mich", subtitle: "About me", level: .a1,
        category: .people, systemImage: "person.text.rectangle.fill",
        words: [
            CollectionWord("", "heißen", "to be called",
                           "Ich heiße Sara. Wie heißen Sie?", "I’m Sara. What’s your name?"),
            CollectionWord("der ", "Name", "name",
                           "Mein Name ist Peter Braun.", "My name is Peter Braun."),
            CollectionWord("", "kommen", "to come (from)",
                           "Woher kommen Sie? — Aus Syrien.", "Where are you from? — From Syria."),
            CollectionWord("", "wohnen", "to live (somewhere)",
                           "Wo wohnen Sie? — In Köln.", "Where do you live? — In Cologne."),
            CollectionWord("das ", "Land", "country",
                           "Aus welchem Land kommst du?", "Which country are you from?"),
            CollectionWord("die ", "Sprache", "language",
                           "Deutsch ist eine schwere Sprache.", "German is a hard language."),
            CollectionWord("", "sprechen", "to speak",
                           "Sprechen Sie Englisch?", "Do you speak English?"),
            CollectionWord("", "Deutsch", "German (the language)",
                           "Ich spreche ein bisschen Deutsch.", "I speak a little German."),
            CollectionWord("", "alt", "old",
                           "Wie alt bist du? — Ich bin 25.", "How old are you? — I’m 25."),
            CollectionWord("das ", "Jahr", "year",
                           "Ich wohne seit einem Jahr in Deutschland.", "I’ve lived in Germany for a year."),
            CollectionWord("", "lernen", "to learn",
                           "Wir lernen zusammen Deutsch.", "We’re learning German together."),
            CollectionWord("das ", "Hobby", "hobby",
                           "Mein Hobby ist Kochen.", "My hobby is cooking."),
            CollectionWord("der ", "Geburtstag", "birthday",
                           "Wann hast du Geburtstag? — Im Mai.", "When’s your birthday? — In May."),
            CollectionWord("", "verstehen", "to understand",
                           "Kannst du mich verstehen?", "Can you understand me?"),
            CollectionWord("", "buchstabieren", "to spell",
                           "Können Sie das bitte buchstabieren?", "Could you spell that, please?")
        ]
    )

    static let a1Family = WordCollection(
        id: "a1-familie", title: "Die Familie", subtitle: "Family", level: .a1,
        category: .people, systemImage: "figure.2.and.child.holdinghands",
        words: [
            CollectionWord("die ", "Familie", "family",
                           "Meine Familie ist groß.", "I’ve got a big family."),
            CollectionWord("die ", "Mutter", "mother",
                           "Meine Mutter wohnt in Hamburg.", "My mother lives in Hamburg."),
            CollectionWord("der ", "Vater", "father",
                           "Mein Vater ist Lehrer.", "My father is a teacher."),
            CollectionWord("die ", "Eltern", "parents",
                           "Meine Eltern kommen am Sonntag.", "My parents are coming on Sunday."),
            CollectionWord("der ", "Bruder", "brother",
                           "Mein Bruder ist 20 Jahre alt.", "My brother is 20."),
            CollectionWord("die ", "Schwester", "sister",
                           "Hast du eine Schwester?", "Have you got a sister?"),
            CollectionWord("die ", "Geschwister", "brothers and sisters",
                           "Ich habe zwei Geschwister.", "I’ve got a brother and a sister."),
            CollectionWord("der ", "Sohn", "son",
                           "Unser Sohn geht in die erste Klasse.", "Our son is in Year 1."),
            CollectionWord("die ", "Tochter", "daughter",
                           "Ihre Tochter heißt Mia.", "Her daughter is called Mia."),
            CollectionWord("das ", "Kind", "child",
                           "Das Kind spielt im Garten.", "The child is playing in the garden."),
            CollectionWord("die ", "Oma", "grandma",
                           "Am Wochenende besuchen wir die Oma.", "At the weekend we’re visiting Grandma."),
            CollectionWord("der ", "Opa", "grandpa",
                           "Mein Opa ist 80 Jahre alt.", "My grandpa is 80."),
            CollectionWord("der ", "Mann", "husband; man",
                           "Das ist mein Mann, Karim.", "This is my husband, Karim."),
            CollectionWord("die ", "Frau", "wife; woman",
                           "Meine Frau arbeitet im Krankenhaus.", "My wife works at the hospital."),
            CollectionWord("", "verheiratet", "married",
                           "Sind Sie verheiratet?", "Are you married?")
        ]
    )

    static let a1Time = WordCollection(
        id: "a1-uhrzeit", title: "Zahlen und Uhrzeit", subtitle: "Numbers and time", level: .a1,
        category: .everyday, systemImage: "clock.fill",
        words: [
            CollectionWord("", "Wie spät ist es?", "what time is it?",
                           "Entschuldigung, wie spät ist es?", "Excuse me, what time is it?"),
            CollectionWord("die ", "Uhr", "clock; o’clock",
                           "Es ist acht Uhr.", "It’s eight o’clock."),
            CollectionWord("", "halb", "half (to the next hour)",
                           "Es ist halb drei.", "It’s half past two."),
            CollectionWord("das ", "Viertel", "quarter",
                           "Es ist Viertel nach fünf.", "It’s quarter past five."),
            CollectionWord("", "vor", "to (before the hour)",
                           "Es ist zehn vor neun.", "It’s ten to nine."),
            CollectionWord("", "um", "at (a time)",
                           "Der Film beginnt um 20 Uhr.", "The film starts at 8 pm."),
            CollectionWord("die ", "Minute", "minute",
                           "Warte bitte eine Minute!", "Wait a minute, please!"),
            CollectionWord("die ", "Stunde", "hour",
                           "Der Kurs dauert eine Stunde.", "The class lasts an hour."),
            CollectionWord("", "früh", "early",
                           "Ich stehe um sechs Uhr auf. Das ist früh!", "I get up at six. That’s early!"),
            CollectionWord("", "pünktlich", "on time",
                           "Der Zug ist heute pünktlich.", "The train is on time today."),
            CollectionWord("die ", "Zahl", "number",
                           "Schreiben Sie die Zahl bitte auf.", "Please write the number down."),
            CollectionWord("", "zwölf", "twelve",
                           "Wir essen um zwölf Uhr zu Mittag.", "We have lunch at twelve."),
            CollectionWord("", "zwanzig", "twenty",
                           "Das kostet zwanzig Euro.", "That’s twenty euros."),
            CollectionWord("", "einundzwanzig", "twenty-one (one and twenty)",
                           "Meine Tochter wird einundzwanzig.", "My daughter is turning twenty-one."),
            CollectionWord("", "hundert", "a hundred",
                           "Die Jacke kostet hundert Euro.", "The jacket costs a hundred euros.")
        ]
    )

    static let a1Day = WordCollection(
        id: "a1-tag", title: "Mein Tag", subtitle: "My day", level: .a1,
        category: .everyday, systemImage: "sun.horizon.fill",
        words: [
            CollectionWord("", "aufstehen", "to get up",
                           "Ich muss morgen früh aufstehen.", "I have to get up early tomorrow."),
            CollectionWord("", "frühstücken", "to have breakfast",
                           "Wir frühstücken um sieben.", "We have breakfast at seven."),
            CollectionWord("", "duschen", "to have a shower",
                           "Ich möchte schnell duschen.", "I’d like a quick shower."),
            CollectionWord("", "arbeiten", "to work",
                           "Heute muss ich bis 17 Uhr arbeiten.", "Today I have to work until 5 pm."),
            CollectionWord("", "einkaufen", "to do the shopping",
                           "Nach der Arbeit gehe ich einkaufen.", "After work I go shopping."),
            CollectionWord("", "kochen", "to cook",
                           "Wer kann heute kochen?", "Who can cook today?"),
            CollectionWord("", "fernsehen", "to watch TV",
                           "Wollen wir heute Abend fernsehen?", "Shall we watch TV this evening?"),
            CollectionWord("", "schlafen", "to sleep",
                           "Das Baby muss jetzt schlafen.", "The baby needs to sleep now."),
            CollectionWord("der ", "Morgen", "morning",
                           "Am Morgen trinke ich Kaffee.", "In the morning I drink coffee."),
            CollectionWord("der ", "Mittag", "midday, lunchtime",
                           "Zu Mittag esse ich in der Kantine.", "At lunchtime I eat in the canteen."),
            CollectionWord("der ", "Abend", "evening",
                           "Am Abend lese ich ein Buch.", "In the evening I read a book."),
            CollectionWord("", "müde", "tired",
                           "Ich bin so müde!", "I’m so tired!"),
            CollectionWord("", "jeden Tag", "every day",
                           "Ich fahre jeden Tag mit dem Fahrrad.", "I cycle every day."),
            CollectionWord("", "nach Hause", "home (going there)",
                           "Um sechs gehe ich nach Hause.", "At six I go home."),
            CollectionWord("", "zu Hause", "at home",
                           "Heute bleibe ich zu Hause.", "Today I’m staying at home.")
        ]
    )

    static let a1Calendar = WordCollection(
        id: "a1-kalender", title: "Tage und Monate", subtitle: "Days and months", level: .a1,
        category: .everyday, systemImage: "calendar",
        words: [
            CollectionWord("", "heute", "today",
                           "Heute ist Dienstag.", "Today is Tuesday."),
            CollectionWord("", "morgen", "tomorrow",
                           "Morgen habe ich frei.", "I’m off tomorrow."),
            CollectionWord("", "übermorgen", "the day after tomorrow",
                           "Übermorgen fliege ich nach Hause.", "The day after tomorrow I’m flying home."),
            CollectionWord("", "gestern", "yesterday",
                           "Gestern war ich beim Arzt.", "Yesterday I was at the doctor’s."),
            CollectionWord("der ", "Montag", "Monday",
                           "Am Montag habe ich einen Deutschkurs.", "On Monday I have a German class."),
            CollectionWord("der ", "Freitag", "Friday",
                           "Am Freitag gehen wir ins Kino.", "On Friday we’re going to the cinema."),
            CollectionWord("der ", "Sonntag", "Sunday",
                           "Sonntags sind die Geschäfte zu.", "On Sundays the shops are shut."),
            CollectionWord("die ", "Woche", "week",
                           "Nächste Woche habe ich Urlaub.", "Next week I’m on holiday."),
            CollectionWord("das ", "Wochenende", "weekend",
                           "Was machst du am Wochenende?", "What are you doing at the weekend?"),
            CollectionWord("der ", "Monat", "month",
                           "Ich bin seit einem Monat in Berlin.", "I’ve been in Berlin for a month."),
            CollectionWord("der ", "Januar", "January",
                           "Im Januar ist es sehr kalt.", "It’s very cold in January."),
            CollectionWord("der ", "Sommer", "summer",
                           "Im Sommer fahren wir ans Meer.", "In summer we go to the seaside."),
            CollectionWord("der ", "Winter", "winter",
                           "Im Winter wird es früh dunkel.", "In winter it gets dark early."),
            CollectionWord("das ", "Datum", "date",
                           "Welches Datum ist heute?", "What’s the date today?"),
            CollectionWord("der ", "Feiertag", "public holiday",
                           "Am 3. Oktober ist ein Feiertag.", "The 3rd of October is a public holiday.")
        ]
    )
}
