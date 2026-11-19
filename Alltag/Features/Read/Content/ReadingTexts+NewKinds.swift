//
//  ReadingTexts+NewKinds.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// One sample of each new kind of text, from A1 to B2, for the maintainer to
/// try on Read before the kinds are written for every level. Temporary.
extension ReadingTexts {
    static let newKinds: [ReadingText] = [
        a1Appointment, a1Recipe, a2School, a2Sofa, a2HolidayFlat,
        a2Story, b1Ticket, b1Leaflet, b1Courses, b2JobAd
    ]

    static let a1Appointment = ReadingText(
        id: "a1-appointment", level: .a1, kind: .message,
        title: "A text from the doctor's", detail: "Your appointment on Monday",
        systemImage: "message.fill",
        german: """
        Praxis Dr. Weber: Guten Tag! Sie haben am Montag, 24.11., um 9:30 Uhr einen Termin bei Dr. Weber.
        Bitte kommen Sie zehn Minuten früher.
        Bitte bringen Sie Ihre Versichertenkarte mit.
        Sie können nicht kommen? Dann antworten Sie bitte bis Freitag mit NEIN.
        Vielen Dank! Ihr Praxisteam
        """,
        questions: [
            ReadingQuestion(prompt: "When is the appointment?",
                            options: ["On Monday at 9:30", "On Friday at 9:30", "On Monday at 10"],
                            answer: 0,
                            evidence: "Praxis Dr. Weber: Guten Tag! Sie haben am Montag, 24.11., um 9:30 Uhr einen Termin bei Dr. Weber."),
            ReadingQuestion(prompt: "What should you bring?",
                            options: ["A letter from the doctor", "Your health insurance card", "Nothing"],
                            answer: 1, evidence: "Bitte bringen Sie Ihre Versichertenkarte mit."),
            ReadingQuestion(prompt: "How do you cancel?",
                            options: ["Call the practice", "Answer NEIN by Friday", "Come ten minutes early"],
                            answer: 1, evidence: "Sie können nicht kommen? Dann antworten Sie bitte bis Freitag mit NEIN.")
        ])

    static let a1Recipe = ReadingText(
        id: "a1-recipe", level: .a1, kind: .recipe,
        title: "A recipe for pancakes", detail: "Easy and quick",
        systemImage: "frying.pan.fill",
        german: """
        Pfannkuchen – für 2 Personen

        Du brauchst: 2 Eier, 250 ml Milch, 125 g Mehl, eine Prise Salz und etwas Öl.

        Gib die Eier, die Milch, das Mehl und das Salz in eine Schüssel.
        Rühre alles gut. Der Teig ruht dann zehn Minuten.
        Mach etwas Öl in die Pfanne. Gib eine Kelle Teig hinein.
        Nach zwei Minuten drehst du den Pfannkuchen um.
        Pfannkuchen schmecken mit Zucker, Apfelmus oder Marmelade.
        """,
        questions: [
            ReadingQuestion(prompt: "How many eggs do you need?",
                            options: ["One", "Two", "Four"],
                            answer: 1, evidence: "Du brauchst: 2 Eier, 250 ml Milch, 125 g Mehl, eine Prise Salz und etwas Öl."),
            ReadingQuestion(prompt: "What happens after you stir everything?",
                            options: ["The batter rests for ten minutes", "You add sugar", "You cook it at once"],
                            answer: 0, evidence: "Der Teig ruht dann zehn Minuten."),
            ReadingQuestion(prompt: "When do you turn the pancake over?",
                            options: ["After ten minutes", "At once", "After two minutes"],
                            answer: 2, evidence: "Nach zwei Minuten drehst du den Pfannkuchen um.")
        ])

    static let a2School = ReadingText(
        id: "a2-school", level: .a2, kind: .letter,
        title: "A letter from school", detail: "A trip to the museum",
        systemImage: "backpack.fill",
        german: """
        Liebe Eltern der Klasse 2b,

        am Donnerstag, dem 27. November, fahren wir mit der Klasse ins Naturkundemuseum.
        Wir treffen uns um 8 Uhr an der Schule und sind um 13 Uhr wieder zurück.
        Der Eintritt und die Fahrt kosten zusammen 4 Euro.
        Bitte geben Sie Ihrem Kind das Geld bis Montag in einem Umschlag mit.
        Ihr Kind braucht ein Frühstück, etwas zu trinken und warme Kleidung.
        Kinder, die nicht mitfahren, gehen an diesem Tag in die Klasse 2a.

        Viele Grüße
        Frau Schneider
        """,
        questions: [
            ReadingQuestion(prompt: "Where is the class going?",
                            options: ["To the zoo", "To the natural history museum", "To another school"],
                            answer: 1,
                            evidence: "am Donnerstag, dem 27. November, fahren wir mit der Klasse ins Naturkundemuseum."),
            ReadingQuestion(prompt: "How should parents pay?",
                            options: ["Cash in an envelope by Monday", "By bank transfer", "At the museum"],
                            answer: 0, evidence: "Bitte geben Sie Ihrem Kind das Geld bis Montag in einem Umschlag mit."),
            ReadingQuestion(prompt: "What about children who don't go?",
                            options: ["They stay at home", "They go to class 2a", "They have a day off"],
                            answer: 1, evidence: "Kinder, die nicht mitfahren, gehen an diesem Tag in die Klasse 2a.")
        ])

    static let a2Sofa = ReadingText(
        id: "a2-sofa", level: .a2, kind: .chat,
        title: "Buying a used sofa", detail: "A chat on a classifieds app",
        systemImage: "sofa.fill",
        german: """
        Du: Hallo, ist das Sofa noch da? Ich biete 80 Euro.
        Petra: Hallo! Ja, es ist noch da. Aber 80 Euro ist zu wenig. Das Sofa ist erst zwei Jahre alt.
        Du: Okay. Geht es für 95 Euro?
        Petra: Ja, 95 Euro ist in Ordnung.
        Petra: Sie müssen es aber selbst abholen. Ich wohne im dritten Stock, und es gibt keinen Aufzug.
        Du: Kein Problem, ich komme mit einem Freund. Passt es morgen um 18 Uhr?
        Petra: Ja, das passt. Bis morgen!
        """,
        questions: [
            ReadingQuestion(prompt: "Why does Petra say no to 80 euros?",
                            options: ["Someone else offered more", "The sofa is only two years old", "She wants to keep it"],
                            answer: 1,
                            evidence: "Petra: Hallo! Ja, es ist noch da. Aber 80 Euro ist zu wenig. Das Sofa ist erst zwei Jahre alt."),
            ReadingQuestion(prompt: "What is hard about picking it up?",
                            options: ["It is far away", "Petra is only home at night", "Third floor and no lift"],
                            answer: 2,
                            evidence: "Petra: Sie müssen es aber selbst abholen. Ich wohne im dritten Stock, und es gibt keinen Aufzug."),
            ReadingQuestion(prompt: "When will you pick it up?",
                            options: ["Tomorrow at 6 pm", "Today at 8 pm", "At the weekend"],
                            answer: 0, evidence: "Du: Kein Problem, ich komme mit einem Freund. Passt es morgen um 18 Uhr?")
        ])

    static let a2HolidayFlat = ReadingText(
        id: "a2-holiday-flat", level: .a2, kind: .notice,
        title: "Welcome to the holiday flat", detail: "Keys, wifi and quiet hours",
        systemImage: "key.fill",
        german: """
        Herzlich willkommen in der Ferienwohnung am See!

        Der Schlüssel ist im Schlüsselkasten neben der Tür. Der Code ist 4711.
        Das WLAN heißt „Seeblick“. Das Passwort steht auf dem Router im Flur.
        Handtücher und Bettwäsche finden Sie im Schrank im Schlafzimmer.
        Bitte trennen Sie den Müll. Die Tonnen stehen hinter dem Haus.
        Im Haus wohnen auch Familien mit kleinen Kindern. Deshalb ist ab 22 Uhr Nachtruhe.
        Bitte legen Sie den Schlüssel bei der Abreise wieder in den Kasten.

        Schöne Ferien!
        Familie Brandt
        """,
        questions: [
            ReadingQuestion(prompt: "Where do you find the wifi password?",
                            options: ["In the key box", "On the router in the hall", "In the bedroom"],
                            answer: 1, evidence: "Das WLAN heißt „Seeblick“. Das Passwort steht auf dem Router im Flur."),
            ReadingQuestion(prompt: "Why must it be quiet from 10 pm?",
                            options: ["Families with small children live there", "The owners sleep early", "It is the law at the lake"],
                            answer: 0,
                            evidence: "Im Haus wohnen auch Familien mit kleinen Kindern. Deshalb ist ab 22 Uhr Nachtruhe."),
            ReadingQuestion(prompt: "What do you do with the key when you leave?",
                            options: ["Leave it on the table", "Give it to the neighbours", "Put it back in the box"],
                            answer: 2, evidence: "Bitte legen Sie den Schlüssel bei der Abreise wieder in den Kasten.")
        ])

    static let a2Story = ReadingText(
        id: "a2-story", level: .a2, kind: .story,
        title: "Lena in Cologne, part 1", detail: "The first day",
        systemImage: "book.closed.fill",
        german: """
        Lena in Köln – Teil 1: Der erste Tag

        Heute ist Lenas erster Tag in Köln. Sie macht eine Ausbildung in einem Café in der Altstadt.
        Um sieben Uhr steigt sie in die Straßenbahn. Sie ist sehr nervös.
        Aber sie steigt an der falschen Haltestelle aus. Wo ist das Café?
        Ein alter Mann sieht ihr Gesicht und fragt: „Kann ich Ihnen helfen?“
        Er kennt das Café und zeigt ihr den Weg. Es ist nur fünf Minuten entfernt.
        Lena kommt zwei Minuten zu spät. Ihre Chefin Mia lacht und umarmt sie.
        „Willkommen! Zuerst trinken wir einen Kaffee, und du probierst unseren Apfelkuchen.“
        Lena denkt: Köln ist gar nicht so schlimm.
        """,
        questions: [
            ReadingQuestion(prompt: "Why is Lena in Cologne?",
                            options: ["She is on holiday", "She is starting a training at a café", "She visits her boss"],
                            answer: 1,
                            evidence: "Heute ist Lenas erster Tag in Köln. Sie macht eine Ausbildung in einem Café in der Altstadt."),
            ReadingQuestion(prompt: "What goes wrong?",
                            options: ["She misses the tram", "She forgets her keys", "She gets off at the wrong stop"],
                            answer: 2, evidence: "Aber sie steigt an der falschen Haltestelle aus. Wo ist das Café?"),
            ReadingQuestion(prompt: "How does Mia react?",
                            options: ["She laughs and hugs her", "She is angry", "She sends her home"],
                            answer: 0, evidence: "Lena kommt zwei Minuten zu spät. Ihre Chefin Mia lacht und umarmt sie.")
        ])
}
