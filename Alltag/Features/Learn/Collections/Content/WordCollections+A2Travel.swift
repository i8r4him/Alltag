//
//  WordCollections+A2Travel.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WordCollections {
    // A2, getting around: the town, a hotel, car and bike.
    static let a2Town = WordCollection(
        id: "a2-stadt", title: "In der Stadt", subtitle: "Finding your way", level: .a2, category: .travel, systemImage: "map.fill",
        words: [
            CollectionWord("der ", "Weg", "way",
                           "Können Sie mir den Weg zum Bahnhof zeigen?", "Can you show me the way to the station?"),
            CollectionWord("die ", "Kreuzung", "crossroads",
                           "An der Kreuzung gehen Sie links.", "Turn left at the crossroads."),
            CollectionWord("die ", "Ampel", "traffic lights",
                           "Gehen Sie bis zur Ampel und dann rechts.", "Go as far as the traffic lights and then right."),
            CollectionWord("die ", "Ecke", "corner",
                           "Die Bäckerei ist gleich um die Ecke.", "The bakery is just round the corner."),
            CollectionWord("die ", "Straße", "street, road",
                           "In welcher Straße wohnst du?", "Which street do you live on?"),
            CollectionWord("die ", "Fußgängerzone", "pedestrian zone",
                           "In der Fußgängerzone sind viele Geschäfte.", "There are lots of shops in the pedestrian zone."),
            CollectionWord("der ", "Platz", "square",
                           "Der Weihnachtsmarkt ist auf dem großen Platz.", "The Christmas market is on the big square."),
            CollectionWord("das ", "Rathaus", "town hall",
                           "Die Hochzeit ist um elf im Rathaus.", "The wedding is at eleven at the town hall."),
            CollectionWord("die ", "Brücke", "bridge",
                           "Fahren Sie über die Brücke und dann geradeaus.", "Go over the bridge and then straight on."),
            CollectionWord("der ", "Stadtplan", "town map",
                           "Auf dem Stadtplan sieht es ganz nah aus.", "On the map it looks really close."),
            CollectionWord("", "geradeaus", "straight on",
                           "Gehen Sie immer geradeaus.", "Keep going straight on."),
            CollectionWord("", "abbiegen", "to turn",
                           "Biegen Sie an der zweiten Straße rechts ab.", "Take the second road on the right."),
            CollectionWord("", "gegenüber", "opposite",
                           "Die Apotheke ist gegenüber der Post.", "The chemist’s is opposite the post office."),
            CollectionWord("", "in der Nähe", "nearby",
                           "Gibt es hier in der Nähe einen Geldautomaten?", "Is there a cash machine near here?"),
            CollectionWord("", "sich verlaufen", "to get lost",
                           "Ich habe mich in der Altstadt verlaufen.", "I got lost in the old town.")
        ]
    )

    static let a2Hotel = WordCollection(
        id: "a2-hotel", title: "Im Hotel", subtitle: "At a hotel", level: .a2, category: .travel, systemImage: "bed.double.fill",
        words: [
            CollectionWord("die ", "Rezeption", "reception",
                           "Den Schlüssel bekommen Sie an der Rezeption.", "You’ll get the key at reception."),
            CollectionWord("das ", "Einzelzimmer", "single room",
                           "Ich hätte gern ein Einzelzimmer für zwei Nächte.", "I’d like a single room for two nights."),
            CollectionWord("das ", "Doppelzimmer", "double room",
                           "Das Doppelzimmer kostet 95 Euro pro Nacht.", "The double room costs 95 euros a night."),
            CollectionWord("die ", "Übernachtung", "night, overnight stay",
                           "Wie viel kostet eine Übernachtung?", "How much is it for one night?"),
            CollectionWord("das ", "Frühstück", "breakfast",
                           "Frühstück gibt es von sieben bis zehn Uhr.", "Breakfast is from seven to ten."),
            CollectionWord("die ", "Reservierung", "booking, reservation",
                           "Ich habe eine Reservierung auf den Namen Haddad.", "I have a booking under the name Haddad."),
            CollectionWord("der ", "Aufzug", "lift",
                           "Der Aufzug ist leider kaputt.", "Unfortunately the lift is out of order."),
            CollectionWord("das ", "Handtuch", "towel",
                           "Könnte ich noch ein Handtuch bekommen?", "Could I have another towel?"),
            CollectionWord("die ", "Klimaanlage", "air conditioning",
                           "Die Klimaanlage in meinem Zimmer funktioniert nicht.", "The air conditioning in my room isn’t working."),
            CollectionWord("das ", "WLAN", "Wi-Fi",
                           "Wie ist das Passwort für das WLAN?", "What’s the Wi-Fi password?"),
            CollectionWord("der ", "Koffer", "suitcase",
                           "Kann ich meinen Koffer hier lassen?", "Can I leave my suitcase here?"),
            CollectionWord("", "einchecken", "to check in",
                           "Ab 15 Uhr können Sie einchecken.", "You can check in from 3 pm."),
            CollectionWord("", "auschecken", "to check out",
                           "Bis wann muss ich auschecken?", "What time do I have to check out?"),
            CollectionWord("", "buchen", "to book",
                           "Ich habe das Hotel online gebucht.", "I booked the hotel online."),
            CollectionWord("", "ruhig", "quiet",
                           "Haben Sie ein ruhiges Zimmer zum Hof?", "Have you got a quiet room facing the courtyard?")
        ]
    )

    static let a2CarAndBike = WordCollection(
        id: "a2-auto", title: "Auto und Fahrrad", subtitle: "Car and bike", level: .a2, category: .travel, systemImage: "bicycle",
        words: [
            CollectionWord("das ", "Auto", "car",
                           "Wir fahren mit dem Auto in den Urlaub.", "We’re going on holiday by car."),
            CollectionWord("das ", "Fahrrad", "bike",
                           "Ich fahre jeden Tag mit dem Fahrrad zur Arbeit.", "I cycle to work every day."),
            CollectionWord("der ", "Führerschein", "driving licence",
                           "Seit wann hast du den Führerschein?", "How long have you had your driving licence?"),
            CollectionWord("die ", "Tankstelle", "petrol station",
                           "Wir müssen noch zur Tankstelle.", "We still need to go to the petrol station."),
            CollectionWord("der ", "Parkplatz", "parking space",
                           "Hier findet man nie einen Parkplatz.", "You can never find a parking space here."),
            CollectionWord("der ", "Stau", "traffic jam",
                           "Auf der A3 gibt es zehn Kilometer Stau.", "There’s a ten-kilometre traffic jam on the A3."),
            CollectionWord("die ", "Autobahn", "motorway",
                           "Auf der Autobahn gibt es oft kein Tempolimit.", "There’s often no speed limit on the motorway."),
            CollectionWord("der ", "Radweg", "cycle path",
                           "Fahr bitte auf dem Radweg!", "Please ride on the cycle path!"),
            CollectionWord("der ", "Helm", "helmet",
                           "Mit Helm fährst du sicherer.", "You’re safer with a helmet."),
            CollectionWord("die ", "Werkstatt", "garage (for repairs)",
                           "Mein Auto ist seit Montag in der Werkstatt.", "My car has been in the garage since Monday."),
            CollectionWord("die ", "Panne", "breakdown",
                           "Wir hatten auf der Autobahn eine Panne.", "We broke down on the motorway."),
            CollectionWord("", "tanken", "to fill up",
                           "Ich tanke lieber abends, da ist es billiger.", "I’d rather fill up in the evening, it’s cheaper then."),
            CollectionWord("", "parken", "to park",
                           "Hier dürfen Sie nicht parken.", "You can’t park here."),
            CollectionWord("", "abschließen", "to lock",
                           "Schließ dein Fahrrad immer gut ab!", "Always lock your bike properly!"),
            CollectionWord("", "einen Platten haben", "to have a flat tyre",
                           "Mein Fahrrad hat einen Platten.", "My bike has a flat tyre.")
        ]
    )
}
