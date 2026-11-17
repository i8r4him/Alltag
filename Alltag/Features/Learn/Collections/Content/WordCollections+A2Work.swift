//
//  WordCollections+A2Work.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WordCollections {
    // A2, work, the language course, post and forms.
    static let a2WorkingDay = WordCollection(
        id: "a2-arbeitstag", title: "Der Arbeitstag", subtitle: "A working day", level: .a2, category: .work, systemImage: "laptopcomputer",
        words: [
            CollectionWord("der ", "Kollege", "colleague",
                           "Mein Kollege hilft mir mit dem neuen Programm.", "My colleague is helping me with the new program."),
            CollectionWord("der ", "Chef", "boss",
                           "Der Chef möchte dich kurz sprechen.", "The boss would like a quick word with you."),
            CollectionWord("das ", "Büro", "office",
                           "Ich bin von neun bis fünf im Büro.", "I’m in the office from nine to five."),
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
            CollectionWord("", "pünktlich", "on time",
                           "Bitte seien Sie morgen pünktlich um acht da.", "Please be here at eight sharp tomorrow.")
        ]
    )

    static let a2LanguageCourse = WordCollection(
        id: "a2-sprachkurs", title: "Im Sprachkurs", subtitle: "At a language course", level: .a2,
        category: .work, systemImage: "book.fill",
        words: [
            CollectionWord("der ", "Kurs", "course, class",
                           "Der Kurs findet dreimal pro Woche statt.", "The class is three times a week."),
            CollectionWord("die ", "Lehrerin", "teacher",
                           "Unsere Lehrerin erklärt die Grammatik sehr gut.", "Our teacher explains the grammar really well."),
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
            CollectionWord("", "buchstabieren", "to spell",
                           "Können Sie Ihren Namen bitte buchstabieren?", "Could you spell your name, please?"),
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
            CollectionWord("die ", "Adresse", "address",
                           "Bitte schreiben Sie die Adresse deutlich.", "Please write the address clearly."),
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

    static let a2Forms = WordCollection(
        id: "a2-formulare", title: "Formulare", subtitle: "Filling in forms", level: .a2,
        category: .paperwork, systemImage: "list.clipboard.fill",
        words: [
            CollectionWord("der ", "Vorname", "first name",
                           "Schreiben Sie Ihren Vornamen in Druckbuchstaben.", "Write your first name in capitals."),
            CollectionWord("der ", "Nachname", "surname",
                           "Mein Nachname ist Al-Khatib.", "My surname is Al-Khatib."),
            CollectionWord("das ", "Geburtsdatum", "date of birth",
                           "Ihr Geburtsdatum, bitte?", "Your date of birth, please?"),
            CollectionWord("der ", "Geburtsort", "place of birth",
                           "Im Pass steht Damaskus als Geburtsort.", "The passport gives Damascus as the place of birth."),
            CollectionWord("die ", "Staatsangehörigkeit", "nationality",
                           "Welche Staatsangehörigkeit haben Sie?", "What nationality are you?"),
            CollectionWord("der ", "Familienstand", "marital status",
                           "Familienstand: ledig, verheiratet oder geschieden.", "Marital status: single, married or divorced."),
            CollectionWord("die ", "Anschrift", "address",
                           "Bitte geben Sie Ihre aktuelle Anschrift an.", "Please give your current address."),
            CollectionWord("die ", "Postleitzahl", "postcode",
                           "Die Postleitzahl hat in Deutschland fünf Ziffern.", "In Germany a postcode has five digits."),
            CollectionWord("das ", "Datum", "date",
                           "Bitte Datum und Unterschrift nicht vergessen.", "Please don’t forget the date and your signature."),
            CollectionWord("der ", "Reisepass", "passport",
                           "Bitte bringen Sie Ihren Reisepass mit.", "Please bring your passport with you."),
            CollectionWord("das ", "Pflichtfeld", "required field",
                           "Felder mit Sternchen sind Pflichtfelder.", "Fields with an asterisk are required."),
            CollectionWord("", "ledig", "single",
                           "Ich bin ledig und habe keine Kinder.", "I’m single and have no children."),
            CollectionWord("", "ausfüllen", "to fill in",
                           "Ich fülle das Formular zu Hause aus.", "I’ll fill in the form at home."),
            CollectionWord("", "unterschreiben", "to sign",
                           "Unterschreiben Sie bitte unten rechts.", "Please sign at the bottom right."),
            CollectionWord("", "ankreuzen", "to tick",
                           "Kreuzen Sie bitte Zutreffendes an.", "Please tick where applicable.")
        ]
    )
}
