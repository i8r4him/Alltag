//
//  WordCollections+B1.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WordCollections {
    /// B1: work, offices and paperwork, getting around.
    static let b1: [WordCollection] = [work, offices, transport]

    static let work = WordCollection(
        id: "b1-arbeit", title: "Arbeit und Beruf", subtitle: "Work", level: .b1, systemImage: "briefcase.fill",
        words: [
            CollectionWord("die ", "Bewerbung", "job application",
                           "Ich habe meine Bewerbung gestern abgeschickt.", "I sent off my application yesterday."),
            CollectionWord("das ", "Vorstellungsgespräch", "job interview",
                           "Das Vorstellungsgespräch ist am Donnerstag um zehn.", "The interview is on Thursday at ten."),
            CollectionWord("der ", "Lebenslauf", "CV",
                           "Schicken Sie uns bitte Ihren Lebenslauf und Ihre Zeugnisse.",
                           "Please send us your CV and your certificates."),
            CollectionWord("der ", "Arbeitsvertrag", "employment contract",
                           "Lesen Sie den Arbeitsvertrag genau, bevor Sie unterschreiben.",
                           "Read the contract carefully before you sign."),
            CollectionWord("die ", "Probezeit", "probation period",
                           "Die Probezeit dauert sechs Monate.", "The probation period lasts six months."),
            CollectionWord("das ", "Gehalt", "salary",
                           "Das Gehalt kommt immer am Monatsende.", "The salary always comes at the end of the month."),
            CollectionWord("die ", "Überstunden", "overtime (plural)",
                           "Diese Woche habe ich viele Überstunden gemacht.", "I did a lot of overtime this week."),
            CollectionWord("der ", "Urlaubsantrag", "holiday request",
                           "Ich muss noch meinen Urlaubsantrag stellen.", "I still need to put in my holiday request."),
            CollectionWord("die ", "Besprechung", "meeting",
                           "Die Besprechung wurde auf morgen verschoben.", "The meeting has been moved to tomorrow."),
            CollectionWord("die ", "Schicht", "shift",
                           "Die Schicht beginnt um sechs Uhr morgens.", "The shift starts at six in the morning."),
            CollectionWord("der ", "Feierabend", "end of the working day",
                           "Nach Feierabend gehen wir manchmal etwas trinken.", "After work we sometimes go for a drink."),
            CollectionWord("das ", "Homeoffice", "working from home",
                           "Freitags arbeite ich im Homeoffice.", "On Fridays I work from home."),
            CollectionWord("die ", "Kollegin", "colleague (woman)",
                           "Meine Kollegin vertritt mich, wenn ich krank bin.", "My colleague covers for me when I’m ill."),
            CollectionWord("", "sich bewerben", "to apply",
                           "Ich bewerbe mich als Krankenpfleger in Hamburg.", "I’m applying for a nursing job in Hamburg."),
            CollectionWord("", "kündigen", "to hand in your notice",
                           "Er hat zum Ende des Monats gekündigt.", "He handed in his notice for the end of the month.")
        ]
    )

    static let offices = WordCollection(
        id: "b1-behoerden", title: "Ämter und Behörden", subtitle: "Offices and paperwork", level: .b1,
        systemImage: "building.columns.fill",
        words: [
            CollectionWord("das ", "Bürgeramt", "citizens’ office",
                           "Für die Anmeldung muss ich zum Bürgeramt.", "I have to go to the citizens’ office to register."),
            CollectionWord("die ", "Anmeldung", "registering your address",
                           "Nach dem Umzug haben Sie zwei Wochen Zeit für die Anmeldung.",
                           "After moving you have two weeks to register."),
            CollectionWord("das ", "Formular", "form",
                           "Füllen Sie das Formular bitte in Druckbuchstaben aus.", "Please fill in the form in capital letters."),
            CollectionWord("der ", "Antrag", "application",
                           "Der Antrag wird in vier bis sechs Wochen bearbeitet.",
                           "The application will be processed in four to six weeks."),
            CollectionWord("die ", "Unterlagen", "documents, papers",
                           "Bringen Sie alle Unterlagen zum Termin mit.", "Bring all your documents to the appointment."),
            CollectionWord("der ", "Ausweis", "ID card",
                           "Ihr Ausweis ist nur noch einen Monat gültig.", "Your ID is only valid for one more month."),
            CollectionWord("die ", "Aufenthaltserlaubnis", "residence permit",
                           "Ich muss meine Aufenthaltserlaubnis verlängern.", "I have to extend my residence permit."),
            CollectionWord("die ", "Frist", "deadline",
                           "Die Frist endet am 30. November.", "The deadline is 30 November."),
            CollectionWord("die ", "Unterschrift", "signature",
                           "Hier fehlt noch Ihre Unterschrift.", "Your signature is still missing here."),
            CollectionWord("der ", "Bescheid", "official decision, notice",
                           "Den Bescheid bekommen Sie per Post.", "You’ll get the decision by post."),
            CollectionWord("das ", "Finanzamt", "tax office",
                           "Das Finanzamt hat mir einen Brief geschickt.", "The tax office has sent me a letter."),
            CollectionWord("die ", "Wartenummer", "queue number",
                           "Ziehen Sie bitte eine Wartenummer.", "Please take a number."),
            CollectionWord("", "verlängern", "to extend, renew",
                           "Kann man den Reisepass online verlängern?", "Can you renew your passport online?"),
            CollectionWord("", "beglaubigen", "to certify",
                           "Die Kopie muss amtlich beglaubigt sein.", "The copy has to be officially certified."),
            CollectionWord("", "zuständig", "responsible, in charge",
                           "Welches Amt ist dafür zuständig?", "Which office is responsible for that?")
        ]
    )

    static let transport = WordCollection(
        id: "b1-unterwegs", title: "Mit Bus und Bahn", subtitle: "Getting around", level: .b1, systemImage: "tram.fill",
        words: [
            CollectionWord("die ", "Verspätung", "delay",
                           "Der Zug hat zwanzig Minuten Verspätung.", "The train is twenty minutes late."),
            CollectionWord("der ", "Anschluss", "connection",
                           "Ich habe meinen Anschluss in Köln verpasst.", "I missed my connection in Cologne."),
            CollectionWord("das ", "Gleis", "platform, track",
                           "Der ICE fährt heute von Gleis 7 ab.", "The ICE leaves from platform 7 today."),
            CollectionWord("die ", "Fahrkarte", "ticket",
                           "Die Fahrkarte können Sie auch in der App kaufen.", "You can also buy the ticket in the app."),
            CollectionWord("die ", "Durchsage", "announcement",
                           "Hast du die Durchsage verstanden?", "Did you understand the announcement?"),
            CollectionWord("der ", "Schienenersatzverkehr", "rail replacement bus",
                           "Wegen Bauarbeiten fährt ein Schienenersatzverkehr.",
                           "Because of engineering works there’s a rail replacement bus."),
            CollectionWord("die ", "Haltestelle", "stop",
                           "An der nächsten Haltestelle steigen wir aus.", "We get off at the next stop."),
            CollectionWord("die ", "Richtung", "direction",
                           "Fährt diese Bahn in Richtung Hauptbahnhof?", "Does this train go towards the main station?"),
            CollectionWord("der ", "Fahrplan", "timetable",
                           "Laut Fahrplan kommt der Bus um 8:12 Uhr.", "According to the timetable, the bus comes at 8:12."),
            CollectionWord("die ", "Kontrolle", "ticket inspection",
                           "Bei der Kontrolle hatte ich mein Ticket nicht dabei.",
                           "I didn’t have my ticket on me at the inspection."),
            CollectionWord("die ", "Sitzplatzreservierung", "seat reservation",
                           "Mit einer Sitzplatzreservierung hast du einen festen Platz.",
                           "With a seat reservation you have a fixed seat."),
            CollectionWord("das ", "Deutschlandticket", "Germany-wide monthly pass",
                           "Mit dem Deutschlandticket fahre ich mit Bus und Bahn durch ganz Deutschland.",
                           "With the Deutschlandticket I can take local buses and trains all over Germany."),
            CollectionWord("", "umsteigen", "to change trains",
                           "In Hannover müssen Sie umsteigen.", "You have to change in Hanover."),
            CollectionWord("", "entwerten", "to validate a ticket",
                           "Vergiss nicht, die Fahrkarte zu entwerten.", "Don’t forget to validate your ticket."),
            CollectionWord("", "ausfallen", "to be cancelled",
                           "Die S-Bahn fällt heute wegen eines Streiks aus.", "The S-Bahn is cancelled today because of a strike.")
        ]
    )
}
