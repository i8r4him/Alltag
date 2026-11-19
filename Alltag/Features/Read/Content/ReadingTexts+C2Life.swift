//
//  ReadingTexts+C2Life.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension ReadingTexts {
    static let c2Care = ReadingText(
        id: "c2-care", level: .c2, kind: .chat,
        title: "The family group chat", detail: "What to do about Grandma?",
        systemImage: "bubble.left.and.bubble.right.fill",
        german: """
        Anke: War gestern bei Mama. Ehrlich gesagt mache ich mir langsam ernsthaft Sorgen. \
        Sie hatte schon wieder vergessen, den Herd auszumachen.
        Bernd: Das war doch bestimmt ein einmaliger Ausrutscher. Du siehst immer gleich schwarz.
        Anke: Es ist das dritte Mal seit Oktober, Bernd. Von einem Ausrutscher kann da wirklich keine Rede mehr sein.
        Lea: Ich will mich nicht einmischen, aber als Enkelin sag ich mal: \
        Oma hat mir neulich am Telefon zweimal hintereinander dieselbe Geschichte erzählt.
        Bernd: Und was schlagt ihr vor? Sie ins Heim abschieben? Das würde ihr das Herz brechen.
        Anke: Davon redet doch keiner. Ich würde zuerst einen Pflegegrad beantragen. \
        Dann könnte ein ambulanter Dienst morgens und abends nach ihr sehen, und die Pflegekasse übernimmt einen Teil.
        Lea: Und so ein Herdwächter kostet nicht die Welt. Der schaltet von selbst ab, wenn sie mal wieder was vergisst.
        Bernd: Na gut, ich lass mich überzeugen. \
        Aber wir fahren am Wochenende zu dritt hin und reden mit ihr, statt über ihren Kopf hinweg zu entscheiden.
        Anke: Einverstanden. Das ist das Mindeste.
        """,
        questions: [
            ReadingQuestion(prompt: "How does Bernd first react to Anke's worry?",
                            options: ["He agrees at once", "He plays it down as a one-off", "He blames Lea"],
                            answer: 1,
                            evidence: "Das war doch bestimmt ein einmaliger Ausrutscher."),
            ReadingQuestion(prompt: "What does Anke suggest first?",
                            options: ["A care home", "Moving in with her mother",
                                      "Applying for a care level, so a home care service can come"],
                            answer: 2,
                            evidence: "Ich würde zuerst einen Pflegegrad beantragen. "
                                + "Dann könnte ein ambulanter Dienst morgens und abends nach ihr sehen"),
            ReadingQuestion(prompt: "What does Bernd insist on?",
                            options: ["Talking to her together instead of deciding over her head",
                                      "Paying for everything himself", "Waiting until the spring"],
                            answer: 0,
                            evidence: "Aber wir fahren am Wochenende zu dritt hin und reden mit ihr, "
                                + "statt über ihren Kopf hinweg zu entscheiden.")
        ])

    static let c2VoiceMessage = ReadingText(
        id: "c2-voice-message", level: .c2, kind: .message,
        title: "A voice message from a friend", detail: "Typed out by the phone",
        systemImage: "waveform",
        german: """
        Hey Tarek, ich bin's, Flo. Sorry, dass ich mich erst jetzt melde, bei mir ist heute echt der Wurm drin.
        Erst hat die S-Bahn mal wieder ewig auf freier Strecke rumgestanden, \
        und dann hab ich mir am Bahnhof den Wolf gesucht, weil die Stadt alle Räder vorm Eingang weggeräumt hatte.
        Langer Rede kurzer Sinn: Ich pack's heute Abend nicht pünktlich ins Kino. \
        Fangt ruhig ohne mich an, ich will euch nicht den Abend vermiesen.
        Ach ja, und wegen Samstag: Mach dir mal keinen Kopf. \
        Ich hab den Transporter schon klargemacht, der steht ab acht vor deiner Tür.
        Pizza und Bier gehen danach natürlich auf dich, das ist ja wohl Ehrensache. Bis später, ich meld mich!
        """,
        questions: [
            ReadingQuestion(prompt: "What does Flo mean by “bei mir ist heute echt der Wurm drin”?",
                            options: ["He's feeling ill", "He's hungry", "Everything keeps going wrong today"],
                            answer: 2,
                            evidence: "bei mir ist heute echt der Wurm drin."),
            ReadingQuestion(prompt: "What does Flo want the others to do tonight?",
                            options: ["Start the film without him", "Wait for him outside", "Call off the cinema"],
                            answer: 0,
                            evidence: "Fangt ruhig ohne mich an, ich will euch nicht den Abend vermiesen."),
            ReadingQuestion(prompt: "What has Flo already sorted out for Saturday?",
                            options: ["The pizza and the beer", "A van for the move", "A new bike"],
                            answer: 1,
                            evidence: "Ich hab den Transporter schon klargemacht, der steht ab acht vor deiner Tür.")
        ])

    static let c2Tasting = ReadingText(
        id: "c2-tasting", level: .c2, kind: .menu,
        title: "A tasting menu", detail: "Dinner for an anniversary",
        systemImage: "fork.knife",
        german: """
        Restaurant Elbufer · Degustationsmenü im Herbst
        Fünf Gänge – 98 Euro
        Sieben Gänge – 124 Euro
        Weinbegleitung, fünf oder sieben Gläser – 58 / 76 Euro
        Alkoholfreie Begleitung aus hausgemachten Säften und Fermenten – 39 Euro

        Gebeizter Saibling aus der Sächsischen Schweiz, Gurke, Dill und Buttermilch
        Klare Ochsenschwanzsuppe mit Markklößchen
        Kalbsbries, kross gebraten, mit Topinambur und Trüffeljus (nur im Sieben-Gänge-Menü)
        Kürbis in Texturen mit geröstetem Kernöl und Salbei
        Sorbet von der Holunderblüte (nur im Sieben-Gänge-Menü)
        Rücken vom Reh aus heimischer Jagd, Rotkohl, Quitte und Wacholder
        Schmand, Zwetschge und Haselnuss
        Käse von der Hofkäserei Lehmann mit Feigensenf – Aufpreis 14 Euro

        Das Menü wird nur tischweise serviert.
        Ein vegetarisches Menü bieten wir gern nach Voranmeldung an.
        Bitte nennen Sie uns Allergien und Unverträglichkeiten bereits bei der Reservierung; \
        kurzfristige Änderungen sind leider nicht immer möglich.
        """,
        questions: [
            ReadingQuestion(prompt: "You choose five courses. Which dish won't you get?",
                            options: ["The venison", "The sweetbreads", "The pumpkin"],
                            answer: 1,
                            evidence: "Kalbsbries, kross gebraten, mit Topinambur und Trüffeljus (nur im Sieben-Gänge-Menü)"),
            ReadingQuestion(prompt: "One of you is vegetarian. What should you do?",
                            options: ["Nothing: it isn't offered", "Ask the waiter on the night", "Book it in advance"],
                            answer: 2,
                            evidence: "Ein vegetarisches Menü bieten wir gern nach Voranmeldung an."),
            ReadingQuestion(prompt: "What does “nur tischweise serviert” mean for your table?",
                            options: ["Everyone at the table has to order the menu", "Only one table a night gets it",
                                      "It's only served at the bar"],
                            answer: 0,
                            evidence: "Das Menü wird nur tischweise serviert.")
        ])

    static let c2FlatAd = ReadingText(
        id: "c2-flat-ad", level: .c2, kind: .advert,
        title: "An estate agent's advert", detail: "Read the flat, not the words",
        systemImage: "key.fill",
        german: """
        Charmante Altbauperle mit Potenzial – 3 Zi., 84 m², Leipzig-Plagwitz

        Liebhaber aufgepasst! Die lichtdurchflutete Wohnung im 4. OG eines Gründerzeithauses (kein Aufzug) \
        besticht durch Stuck, Dielen und hohe Decken.
        Die Küche ist bewusst schlicht gehalten und bietet viel Raum für eigene Ideen; eine Einbauküche ist nicht vorhanden.
        Das Wannenbad versprüht den unverwechselbaren Charme der 70er-Jahre.
        Lebendige Lage direkt an der Karl-Heine-Straße, die Straßenbahn hält praktisch vor der Haustür.
        Kaltmiete 1.050 €, Nebenkosten ca. 230 €, Kaution drei Nettokaltmieten. Provisionsfrei für Mieter.
        Besichtigung nur mit vollständiger Mieterselbstauskunft, SCHUFA-Auskunft und den letzten drei Gehaltsnachweisen. \
        Anfragen ohne diese Unterlagen können leider nicht berücksichtigt werden.
        """,
        questions: [
            ReadingQuestion(prompt: "What does “viel Raum für eigene Ideen” really tell you about the kitchen?",
                            options: ["It has just been fitted", "There are no kitchen units at all", "It is unusually large"],
                            answer: 1,
                            evidence: "eine Einbauküche ist nicht vorhanden."),
            ReadingQuestion(prompt: "Why might the flat be noisy?",
                            options: ["It's right on a busy street with the tram outside", "There's a bar downstairs",
                                      "It's next to a school"],
                            answer: 0,
                            evidence: "Lebendige Lage direkt an der Karl-Heine-Straße, die Straßenbahn hält praktisch vor der Haustür."),
            ReadingQuestion(prompt: "What must you have before you can see the flat?",
                            options: ["The deposit", "Nothing: just turn up",
                                      "A tenant's self-disclosure, a credit report and three payslips"],
                            answer: 2,
                            evidence: "Besichtigung nur mit vollständiger Mieterselbstauskunft, "
                                + "SCHUFA-Auskunft und den letzten drei Gehaltsnachweisen.")
        ])
}
