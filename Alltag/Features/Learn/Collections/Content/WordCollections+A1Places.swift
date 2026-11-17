//
//  WordCollections+A1Places.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WordCollections {
    static let a1Home = WordCollection(
        id: "a1-zuhause", title: "Mein Zuhause", subtitle: "At home", level: .a1,
        category: .home, systemImage: "sofa.fill",
        words: [
            CollectionWord("die ", "Wohnung", "flat",
                           "Unsere Wohnung hat drei Zimmer.", "Our flat has three rooms."),
            CollectionWord("das ", "Haus", "house",
                           "Meine Eltern haben ein Haus mit Garten.", "My parents have a house with a garden."),
            CollectionWord("der ", "Stock", "floor, storey",
                           "Ich wohne im dritten Stock.", "I live on the third floor."),
            CollectionWord("das ", "Wohnzimmer", "living room",
                           "Wir sitzen abends im Wohnzimmer.", "We sit in the living room in the evenings."),
            CollectionWord("das ", "Schlafzimmer", "bedroom",
                           "Das Schlafzimmer ist ziemlich klein.", "The bedroom is quite small."),
            CollectionWord("die ", "Toilette", "toilet",
                           "Wo ist die Toilette, bitte?", "Where’s the toilet, please?"),
            CollectionWord("der ", "Balkon", "balcony",
                           "Im Sommer frühstücken wir auf dem Balkon.", "In summer we have breakfast on the balcony."),
            CollectionWord("das ", "Bett", "bed",
                           "Das Bett ist sehr bequem.", "The bed is very comfortable."),
            CollectionWord("der ", "Tisch", "table",
                           "Das Essen steht auf dem Tisch.", "The food is on the table."),
            CollectionWord("der ", "Stuhl", "chair",
                           "Nimm dir einen Stuhl!", "Grab a chair!"),
            CollectionWord("das ", "Sofa", "sofa",
                           "Komm, setz dich aufs Sofa.", "Come and sit on the sofa."),
            CollectionWord("der ", "Schrank", "cupboard, wardrobe",
                           "Die Teller sind im Schrank.", "The plates are in the cupboard."),
            CollectionWord("das ", "Fenster", "window",
                           "Mach bitte das Fenster zu.", "Please close the window."),
            CollectionWord("die ", "Tür", "door",
                           "Die Tür ist offen.", "The door is open."),
            CollectionWord("die ", "Lampe", "lamp, light",
                           "Die Lampe ist kaputt.", "The lamp is broken.")
        ]
    )

    static let a1Body = WordCollection(
        id: "a1-koerper", title: "Der Körper", subtitle: "Your body", level: .a1,
        category: .health, systemImage: "figure.stand",
        words: [
            CollectionWord("der ", "Kopf", "head",
                           "Mein Kopf tut weh.", "My head hurts."),
            CollectionWord("das ", "Auge", "eye",
                           "Mein linkes Auge ist rot.", "My left eye is red."),
            CollectionWord("das ", "Ohr", "ear",
                           "Das Kind hat Schmerzen im Ohr.", "The child’s ear hurts."),
            CollectionWord("die ", "Nase", "nose",
                           "Meine Nase läuft.", "I’ve got a runny nose."),
            CollectionWord("der ", "Mund", "mouth",
                           "Machen Sie bitte den Mund auf.", "Open your mouth, please."),
            CollectionWord("der ", "Zahn", "tooth",
                           "Ein Zahn tut mir weh.", "One of my teeth hurts."),
            CollectionWord("der ", "Bauch", "stomach, tummy",
                           "Ich liege auf dem Bauch.", "I’m lying on my stomach."),
            CollectionWord("der ", "Rücken", "back",
                           "Er hat oft Probleme mit dem Rücken.", "He often has problems with his back."),
            CollectionWord("die ", "Hand", "hand",
                           "Gib mir deine Hand.", "Give me your hand."),
            CollectionWord("der ", "Arm", "arm",
                           "Ich habe mir den Arm gebrochen.", "I’ve broken my arm."),
            CollectionWord("das ", "Bein", "leg",
                           "Mein Bein tut nach dem Sport weh.", "My leg hurts after sport."),
            CollectionWord("der ", "Fuß", "foot",
                           "Ich gehe zu Fuß.", "I’m walking."),
            CollectionWord("", "krank", "ill",
                           "Ich bin krank und bleibe im Bett.", "I’m ill and staying in bed."),
            CollectionWord("", "gesund", "healthy, well",
                           "Bleib gesund!", "Stay well!"),
            CollectionWord("der ", "Arzt", "doctor",
                           "Ich gehe heute zum Arzt.", "I’m going to the doctor’s today.")
        ]
    )

    static let a1Town = WordCollection(
        id: "a1-stadt", title: "In der Stadt", subtitle: "In town", level: .a1,
        category: .travel, systemImage: "building.2.fill",
        words: [
            CollectionWord("die ", "Stadt", "town, city",
                           "Ich wohne in einer kleinen Stadt.", "I live in a small town."),
            CollectionWord("die ", "Straße", "street, road",
                           "In welcher Straße wohnst du?", "Which street do you live on?"),
            CollectionWord("das ", "Rathaus", "town hall",
                           "Das Rathaus ist in der Altstadt.", "The town hall is in the old town."),
            CollectionWord("die ", "Post", "post office",
                           "Ich muss noch zur Post.", "I still need to go to the post office."),
            CollectionWord("die ", "Bank", "bank",
                           "Gibt es hier in der Nähe eine Bank?", "Is there a bank near here?"),
            CollectionWord("der ", "Supermarkt", "supermarket",
                           "Gibt es hier einen Supermarkt?", "Is there a supermarket here?"),
            CollectionWord("das ", "Krankenhaus", "hospital",
                           "Das Krankenhaus ist nicht weit.", "The hospital isn’t far."),
            CollectionWord("die ", "Schule", "school",
                           "Die Kinder gehen zu Fuß zur Schule.", "The children walk to school."),
            CollectionWord("der ", "Park", "park",
                           "Am Sonntag gehen wir in den Park.", "On Sunday we’re going to the park."),
            CollectionWord("", "in der Nähe", "nearby",
                           "Wohnst du in der Nähe?", "Do you live nearby?"),
            CollectionWord("", "links", "left",
                           "Gehen Sie hier links.", "Turn left here."),
            CollectionWord("", "rechts", "right",
                           "Nach der Ampel gehen Sie rechts.", "Turn right after the traffic lights."),
            CollectionWord("", "geradeaus", "straight on",
                           "Gehen Sie immer geradeaus.", "Keep going straight on."),
            CollectionWord("die ", "Ampel", "traffic lights",
                           "Warte, die Ampel ist rot!", "Wait, the lights are red!"),
            CollectionWord("die ", "Ecke", "corner",
                           "Das Café ist an der Ecke.", "The café is on the corner.")
        ]
    )

    static let a1Station = WordCollection(
        id: "a1-bahnhof", title: "Am Bahnhof", subtitle: "At the station", level: .a1,
        category: .travel, systemImage: "train.side.front.car",
        words: [
            CollectionWord("der ", "Bahnhof", "station",
                           "Der Bahnhof ist nicht weit von hier.", "The station isn’t far from here."),
            CollectionWord("der ", "Zug", "train",
                           "Der Zug fährt um 9:15 Uhr.", "The train leaves at 9.15."),
            CollectionWord("der ", "Bus", "bus",
                           "Ich fahre mit dem Bus zur Arbeit.", "I go to work by bus."),
            CollectionWord("die ", "U-Bahn", "underground",
                           "Die U-Bahn ist schneller.", "The underground is quicker."),
            CollectionWord("die ", "S-Bahn", "local train (S-Bahn)",
                           "Die S-Bahn kommt alle zehn Minuten.", "The S-Bahn comes every ten minutes."),
            CollectionWord("das ", "Ticket", "ticket",
                           "Hast du schon ein Ticket?", "Have you got a ticket yet?"),
            CollectionWord("der ", "Automat", "ticket machine",
                           "Der Automat nimmt nur Karten.", "The machine only takes cards."),
            CollectionWord("", "hin und zurück", "return (ticket)",
                           "Einmal Köln, hin und zurück, bitte.", "A return to Cologne, please."),
            CollectionWord("die ", "Abfahrt", "departure",
                           "Die Abfahrt ist um 10 Uhr.", "Departure is at 10 o’clock."),
            CollectionWord("die ", "Ankunft", "arrival",
                           "Die Ankunft in München ist um 14 Uhr.", "Arrival in Munich is at 2 pm."),
            CollectionWord("", "fahren", "to go (by bus, train or car)",
                           "Wir fahren morgen nach Berlin.", "We’re going to Berlin tomorrow."),
            CollectionWord("", "einsteigen", "to get on",
                           "Bitte schnell einsteigen!", "Please get on quickly!"),
            CollectionWord("", "aussteigen", "to get off",
                           "An der nächsten Station müssen wir aussteigen.", "We have to get off at the next stop."),
            CollectionWord("", "ankommen", "to arrive",
                           "Wir möchten pünktlich ankommen.", "We’d like to arrive on time."),
            CollectionWord("der ", "Flughafen", "airport",
                           "Wir müssen um sechs am Flughafen sein.", "We have to be at the airport at six.")
        ]
    )
}
