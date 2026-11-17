//
//  WordCollections+B1Travel.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WordCollections {
    // B1 on the move: bus and train, holidays, driving.

    static let transport = WordCollection(
        id: "b1-unterwegs", title: "Mit Bus und Bahn", subtitle: "Getting around", level: .b1, category: .travel, systemImage: "tram.fill",
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
                           "Bei der Kontrolle hatte ich mein Ticket nicht dabei.", "I didn’t have my ticket on me at the inspection."),
            CollectionWord("die ", "Sitzplatzreservierung", "seat reservation",
                           "Mit einer Sitzplatzreservierung hast du einen festen Platz.", "With a seat reservation you have a fixed seat."),
            CollectionWord("das ", "Deutschlandticket", "Germany-wide monthly pass",
                           "Mit dem Deutschlandticket fahre ich mit Bus und Bahn durch ganz Deutschland.",
                           "With the Deutschlandticket I can take local buses and trains all over Germany."),
            CollectionWord("", "umsteigen", "to change trains",
                           "In Hannover müssen Sie umsteigen.", "You have to change in Hanover."),
            CollectionWord("", "entwerten", "to validate a ticket",
                           "Vergiss nicht, die Fahrkarte zu entwerten.", "Don’t forget to validate your ticket."),
            CollectionWord("", "ausfallen", "to be cancelled",
                           "Die S-Bahn fällt heute wegen eines Streiks aus.", "The S-Bahn is cancelled today because of a strike."),
            CollectionWord("die ", "Auskunft", "information desk",
                           "Fragen Sie am besten an der Auskunft.", "Best ask at the information desk."),
            CollectionWord("der ", "Fahrgast", "passenger",
                           "Alle Fahrgäste müssen hier aussteigen.", "All passengers have to get off here."),
            CollectionWord("die ", "Ermäßigung", "reduced fare, discount",
                           "Studierende bekommen eine Ermäßigung.", "Students get a discount."),
            CollectionWord("die ", "Endstation", "last stop",
                           "Ich bin eingeschlafen und erst an der Endstation aufgewacht.",
                           "I fell asleep and only woke up at the last stop."),
            CollectionWord("der ", "Fahrkartenautomat", "ticket machine",
                           "Der Fahrkartenautomat nimmt nur Karten.", "The ticket machine only takes cards.")
        ]
    )

    static let b1Holidays = WordCollection(
        id: "b1-urlaub", title: "Urlaub und Reisen", subtitle: "Holidays", level: .b1, category: .travel, systemImage: "airplane",
        words: [
            CollectionWord("die ", "Unterkunft", "accommodation",
                           "Die Unterkunft war sauber und günstig.", "The accommodation was clean and cheap."),
            CollectionWord("die ", "Buchung", "booking",
                           "Die Buchung wurde per E-Mail bestätigt.", "The booking was confirmed by email."),
            CollectionWord("", "stornieren", "to cancel (a booking)",
                           "Kann ich das Zimmer kostenlos stornieren?", "Can I cancel the room for free?"),
            CollectionWord("die ", "Pauschalreise", "package holiday",
                           "Eine Pauschalreise ist oft billiger.", "A package holiday is often cheaper."),
            CollectionWord("der ", "Flug", "flight",
                           "Unser Flug wurde gestrichen.", "Our flight was cancelled."),
            CollectionWord("das ", "Gepäck", "luggage",
                           "Mein Gepäck ist nicht angekommen.", "My luggage didn’t arrive."),
            CollectionWord("das ", "Handgepäck", "hand luggage",
                           "Ich reise nur mit Handgepäck.", "I only travel with hand luggage."),
            CollectionWord("der ", "Koffer", "suitcase",
                           "Ich packe meinen Koffer immer erst am letzten Abend.", "I always pack my suitcase on the last evening."),
            CollectionWord("der ", "Reisepass", "passport",
                           "Ist dein Reisepass noch gültig?", "Is your passport still valid?"),
            CollectionWord("der ", "Zoll", "customs",
                           "Am Zoll mussten wir unsere Taschen öffnen.", "At customs we had to open our bags."),
            CollectionWord("die ", "Grenze", "border",
                           "An der Grenze gab es lange Kontrollen.", "There were long checks at the border."),
            CollectionWord("die ", "Rezeption", "reception",
                           "Den Schlüssel gibt es an der Rezeption.", "You get the key at reception."),
            CollectionWord("die ", "Halbpension", "half board",
                           "Wir haben ein Hotel mit Halbpension gebucht.", "We’ve booked a hotel with half board."),
            CollectionWord("die ", "Ferienwohnung", "holiday flat",
                           "Die Ferienwohnung liegt direkt am Meer.", "The holiday flat is right by the sea."),
            CollectionWord("die ", "Sehenswürdigkeit", "sight",
                           "Wir haben alle Sehenswürdigkeiten der Stadt besucht.", "We visited all the sights in the city."),
            CollectionWord("der ", "Ausflug", "trip, outing",
                           "Morgen machen wir einen Ausflug in die Berge.", "Tomorrow we’re going on a trip to the mountains."),
            CollectionWord("der ", "Strand", "beach",
                           "Wir lagen den ganzen Tag am Strand.", "We lay on the beach all day."),
            CollectionWord("das ", "Reiseziel", "destination",
                           "Was ist dein Lieblingsreiseziel?", "What’s your favourite destination?"),
            CollectionWord("", "sich erholen", "to rest, recover",
                           "Im Urlaub will ich mich einfach nur erholen.", "On holiday I just want to rest."),
            CollectionWord("die ", "Abreise", "departure",
                           "Am Tag der Abreise hat es geregnet.", "It rained on the day we left.")
        ]
    )

    static let b1Driving = WordCollection(
        id: "b1-auto", title: "Auto und Verkehr", subtitle: "Driving", level: .b1, category: .travel, systemImage: "car.fill",
        words: [
            CollectionWord("der ", "Führerschein", "driving licence",
                           "Ich mache gerade den Führerschein.", "I’m learning to drive at the moment."),
            CollectionWord("die ", "Fahrschule", "driving school",
                           "Die Fahrschule ist ganz schön teuer.", "Driving school is pretty expensive."),
            CollectionWord("der ", "Stau", "traffic jam",
                           "Auf der A7 ist ein langer Stau.", "There’s a long traffic jam on the A7."),
            CollectionWord("die ", "Autobahn", "motorway",
                           "Auf der Autobahn gibt es nicht überall ein Tempolimit.",
                           "There isn’t a speed limit everywhere on the motorway."),
            CollectionWord("die ", "Umleitung", "diversion",
                           "Wegen der Baustelle gibt es eine Umleitung.", "There’s a diversion because of the roadworks."),
            CollectionWord("", "tanken", "to fill up (with fuel)",
                           "Ich muss noch tanken.", "I still need to get petrol."),
            CollectionWord("der ", "Parkplatz", "parking space",
                           "In der Innenstadt findet man kaum einen Parkplatz.", "You can hardly find a parking space in the city centre."),
            CollectionWord("der ", "Strafzettel", "parking ticket, fine",
                           "Ich habe schon wieder einen Strafzettel bekommen.", "I’ve got another parking ticket."),
            CollectionWord("", "blitzen", "to catch with a speed camera",
                           "Ich bin auf dem Heimweg geblitzt worden.", "I got caught by a speed camera on the way home."),
            CollectionWord("die ", "Geschwindigkeit", "speed",
                           "Hier ist die Geschwindigkeit auf 30 begrenzt.", "The speed limit here is 30."),
            CollectionWord("die ", "Vorfahrt", "right of way",
                           "Wer hat hier Vorfahrt?", "Who has right of way here?"),
            CollectionWord("die ", "Ampel", "traffic lights",
                           "Fahr an der nächsten Ampel links.", "Turn left at the next lights."),
            CollectionWord("die ", "Kreuzung", "junction",
                           "An der Kreuzung ist ein Unfall passiert.", "There’s been an accident at the junction."),
            CollectionWord("der ", "Fußgänger", "pedestrian",
                           "Achte auf die Fußgänger am Zebrastreifen.", "Watch out for pedestrians at the zebra crossing."),
            CollectionWord("die ", "Panne", "breakdown",
                           "Wir hatten eine Panne kurz vor Berlin.", "We broke down just outside Berlin."),
            CollectionWord("der ", "Reifen", "tyre",
                           "Ich habe einen platten Reifen.", "I’ve got a flat tyre."),
            CollectionWord("die ", "Werkstatt", "garage (for repairs)",
                           "Das Auto ist seit Montag in der Werkstatt.", "The car’s been at the garage since Monday."),
            CollectionWord("der ", "TÜV", "MOT, vehicle inspection",
                           "Mein Auto muss im März zum TÜV.", "My car needs its MOT in March."),
            CollectionWord("die ", "Fahrgemeinschaft", "car share",
                           "Zur Arbeit fahren wir in einer Fahrgemeinschaft.", "We share a car to work."),
            CollectionWord("die ", "Ladesäule", "charging point",
                           "Die nächste Ladesäule ist zwei Kilometer entfernt.", "The nearest charging point is two kilometres away.")
        ]
    )
}
