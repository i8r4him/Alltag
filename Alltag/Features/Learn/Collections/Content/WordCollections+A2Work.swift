//
//  WordCollections+A2Work.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WordCollections {
    // A2, work, the language course, post and money.
    static let a2WorkingDay = WordCollection(
        id: "a2-arbeitstag", title: "Der Arbeitstag", subtitle: "A working day", level: .a2, category: .work, systemImage: "laptopcomputer",
        words: [
            CollectionWord("das ", "Team", "team",
                           "Unser Team hat acht Leute.", "There are eight people in our team."),
            CollectionWord("der ", "Chef", "boss",
                           "Der Chef möchte dich kurz sprechen.", "The boss would like a quick word with you."),
            CollectionWord("die ", "Abteilung", "department",
                           "In welcher Abteilung arbeiten Sie?", "Which department do you work in?"),
            CollectionWord("der ", "Arbeitsplatz", "job, workplace",
                           "Mein Arbeitsplatz ist mit dem Fahrrad gut zu erreichen.", "My workplace is easy to get to by bike."),
            CollectionWord("die ", "Pause", "break",
                           "In der Pause trinken wir zusammen Kaffee.", "We have coffee together in the break."),
            CollectionWord("die ", "Kantine", "canteen",
                           "Mittags essen wir in der Kantine.", "At lunchtime we eat in the canteen."),
            CollectionWord("die ", "Aufgabe", "task",
                           "Das ist heute meine wichtigste Aufgabe.", "That’s my most important task today."),
            CollectionWord("der ", "Drucker", "printer",
                           "Der Drucker hat schon wieder kein Papier.", "The printer is out of paper again."),
            CollectionWord("die ", "E-Mail", "email",
                           "Ich habe heute schon fünfzig E-Mails bekommen.", "I’ve already had fifty emails today."),
            CollectionWord("der ", "Kunde", "customer, client",
                           "Um zehn kommt ein wichtiger Kunde.", "An important client is coming at ten."),
            CollectionWord("die ", "Teilzeit", "part-time",
                           "Sie arbeitet in Teilzeit, nur vormittags.", "She works part-time, mornings only."),
            CollectionWord("", "anfangen", "to start",
                           "Wann fängst du morgens an?", "What time do you start in the morning?"),
            CollectionWord("", "erledigen", "to get done",
                           "Ich muss noch ein paar Sachen erledigen.", "I still have to get a few things done."),
            CollectionWord("", "sich krankmelden", "to call in sick",
                           "Ich muss mich heute krankmelden.", "I have to call in sick today."),
            CollectionWord("der ", "Urlaubstag", "day of holiday",
                           "Ich habe dieses Jahr noch fünf Urlaubstage.", "I’ve still got five days’ holiday this year.")
        ]
    )

    static let a2LanguageCourse = WordCollection(
        id: "a2-sprachkurs", title: "Im Sprachkurs", subtitle: "At a language course", level: .a2,
        category: .work, systemImage: "book.fill",
        words: [
            CollectionWord("der ", "Kurs", "course, class",
                           "Der Kurs findet dreimal pro Woche statt.", "The class is three times a week."),
            CollectionWord("die ", "Kursleiterin", "course teacher",
                           "Unsere Kursleiterin erklärt die Grammatik sehr gut.", "Our teacher explains the grammar really well."),
            CollectionWord("die ", "Hausaufgabe", "homework",
                           "Hast du die Hausaufgaben schon gemacht?", "Have you done the homework yet?"),
            CollectionWord("die ", "Prüfung", "exam",
                           "Die Prüfung ist am 12. Dezember.", "The exam is on 12 December."),
            CollectionWord("das ", "Wörterbuch", "dictionary",
                           "Ich schlage neue Wörter im Wörterbuch nach.", "I look up new words in the dictionary."),
            CollectionWord("die ", "Aussprache", "pronunciation",
                           "Die Aussprache von „ü“ ist schwer für mich.", "Pronouncing “ü” is hard for me."),
            CollectionWord("der ", "Fehler", "mistake",
                           "Jeder macht Fehler, das ist normal.", "Everyone makes mistakes, that’s normal."),
            CollectionWord("die ", "Bedeutung", "meaning",
                           "Was ist die Bedeutung von „Feierabend“?", "What does “Feierabend” mean?"),
            CollectionWord("das ", "Zertifikat", "certificate",
                           "Für das B1-Zertifikat lerne ich jeden Tag.", "I study every day for the B1 certificate."),
            CollectionWord("", "wiederholen", "to repeat",
                           "Können Sie das bitte wiederholen?", "Could you repeat that, please?"),
            CollectionWord("", "erklären", "to explain",
                           "Kannst du mir das Wort erklären?", "Can you explain the word to me?"),
            CollectionWord("die ", "Übung", "exercise",
                           "Macht bitte Übung drei auf Seite zwölf.", "Please do exercise three on page twelve."),
            CollectionWord("", "üben", "to practise",
                           "Wir üben die Dialoge zu zweit.", "We practise the dialogues in pairs."),
            CollectionWord("", "sich anmelden", "to sign up",
                           "Ich habe mich für den Abendkurs angemeldet.", "I’ve signed up for the evening class."),
            CollectionWord("", "bestehen", "to pass",
                           "Er hat die Prüfung beim ersten Mal bestanden.", "He passed the exam first time.")
        ]
    )

    static let a2Post = WordCollection(
        id: "a2-post", title: "Post und Pakete", subtitle: "Post and parcels", level: .a2,
        category: .paperwork, systemImage: "shippingbox.fill",
        words: [
            CollectionWord("der ", "Brief", "letter",
                           "Für Sie ist ein Brief gekommen.", "A letter has come for you."),
            CollectionWord("das ", "Paket", "parcel",
                           "Das Paket kommt morgen zwischen 10 und 14 Uhr.", "The parcel is coming tomorrow between 10 am and 2 pm."),
            CollectionWord("die ", "Briefmarke", "stamp",
                           "Eine Briefmarke für Spanien, bitte.", "A stamp for Spain, please."),
            CollectionWord("der ", "Briefkasten", "letterbox, postbox",
                           "Der Briefkasten wird um 17 Uhr geleert.", "The postbox is emptied at 5 pm."),
            CollectionWord("der ", "Absender", "sender",
                           "Vergessen Sie den Absender nicht.", "Don’t forget the sender’s address."),
            CollectionWord("der ", "Empfänger", "recipient",
                           "Der Empfänger war nicht zu Hause.", "The recipient wasn’t at home."),
            CollectionWord("das ", "Porto", "postage",
                           "Wie viel kostet das Porto nach Syrien?", "How much is the postage to Syria?"),
            CollectionWord("die ", "Benachrichtigung", "delivery card",
                           "Im Briefkasten lag eine Benachrichtigung.", "There was a delivery card in the letterbox."),
            CollectionWord("die ", "Packstation", "parcel locker",
                           "Ich lasse mir Pakete an die Packstation schicken.", "I have parcels sent to a parcel locker."),
            CollectionWord("die ", "Sendungsnummer", "tracking number",
                           "Mit der Sendungsnummer kannst du das Paket verfolgen.", "You can track the parcel with the tracking number."),
            CollectionWord("das ", "Einschreiben", "registered letter",
                           "Die Kündigung schicke ich per Einschreiben.", "I’m sending the cancellation by registered post."),
            CollectionWord("die ", "Filiale", "branch",
                           "Das Paket liegt in der Filiale in der Hauptstraße.", "The parcel is waiting at the branch on the high street."),
            CollectionWord("", "schicken", "to send",
                           "Ich schicke dir die Fotos per Post.", "I’ll send you the photos by post."),
            CollectionWord("", "zustellen", "to deliver",
                           "Das Paket konnte nicht zugestellt werden.", "The parcel couldn’t be delivered."),
            CollectionWord("", "zurückschicken", "to send back",
                           "Die Schuhe schicke ich zurück, sie sind zu klein.", "I’m sending the shoes back, they’re too small.")
        ]
    )

    static let a2Money = WordCollection(
        id: "a2-geld", title: "Geld im Alltag", subtitle: "Money", level: .a2, category: .paperwork, systemImage: "eurosign.circle.fill",
        words: [
            CollectionWord("das ", "Konto", "bank account",
                           "Für die Arbeit brauchen Sie ein Konto in Deutschland.", "For the job you need a bank account in Germany."),
            CollectionWord("der ", "Geldautomat", "cash machine",
                           "Der Geldautomat hat meine Karte behalten.", "The cash machine kept my card."),
            CollectionWord("das ", "Bargeld", "cash",
                           "Auf dem Flohmarkt braucht man Bargeld.", "You need cash at the flea market."),
            CollectionWord("der ", "Schein", "note",
                           "Ich habe nur einen Fünfzig-Euro-Schein.", "I’ve only got a fifty-euro note."),
            CollectionWord("die ", "Münze", "coin",
                           "Für das Schließfach braucht man eine Münze.", "You need a coin for the locker."),
            CollectionWord("die ", "Geheimzahl", "PIN",
                           "Geben Sie bitte Ihre Geheimzahl ein.", "Please enter your PIN."),
            CollectionWord("der ", "Kontoauszug", "bank statement",
                           "Den Kontoauszug kannst du in der App sehen.", "You can see the bank statement in the app."),
            CollectionWord("die ", "Gebühr", "fee",
                           "Für das Konto zahle ich keine Gebühr.", "I don’t pay a fee for the account."),
            CollectionWord("die ", "Quittung", "receipt",
                           "Können Sie mir bitte eine Quittung geben?", "Could you give me a receipt, please?"),
            CollectionWord("die ", "Rate", "instalment",
                           "Ich zahle das Handy in zwölf Raten.", "I’m paying for the phone in twelve instalments."),
            CollectionWord("", "Geld abheben", "to withdraw money",
                           "Ich muss noch schnell Geld abheben.", "I just need to get some money out."),
            CollectionWord("", "sparen", "to save",
                           "Wir sparen für den Urlaub.", "We’re saving for our holiday."),
            CollectionWord("", "ausgeben", "to spend",
                           "Für Essen geben wir zu viel aus.", "We spend too much on food."),
            CollectionWord("", "leihen", "to lend, to borrow",
                           "Kannst du mir zehn Euro leihen?", "Can you lend me ten euros?"),
            CollectionWord("", "überweisen", "to transfer",
                           "Ich überweise dir das Geld heute noch.", "I’ll transfer the money to you today.")
        ]
    )
}
