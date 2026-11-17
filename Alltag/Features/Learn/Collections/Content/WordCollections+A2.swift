//
//  WordCollections+A2.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WordCollections {
    /// A2: everyday life in many topics, the most useful first. The doctor's,
    /// the flat and shopping are in this file; the other topics are in the
    /// `WordCollections+A2….swift` files by group.
    static let a2: [WordCollection] = [
        doctor, flat, shopping, a2Restaurant, a2Town, a2DailyRoutine, a2Friends, a2Phone, a2Weather,
        a2Hobbies, a2Celebrations, a2Feelings, a2Clothes, a2Cooking, a2Housework, a2Furniture,
        a2Hotel, a2CarAndBike, a2WorkingDay, a2LanguageCourse, a2Post, a2Forms, a2Emergencies,
        a2Sport, a2GoingOut
    ]

    static let doctor = WordCollection(
        id: "a2-arzt", title: "Beim Arzt", subtitle: "At the doctor’s", level: .a2, category: .health, systemImage: "stethoscope",
        words: [
            CollectionWord("der ", "Termin", "appointment",
                           "Ich brauche einen Termin beim Hausarzt.", "I need an appointment with my GP."),
            CollectionWord("die ", "Praxis", "practice, surgery",
                           "Die Praxis ist am Mittwochnachmittag geschlossen.", "The practice is closed on Wednesday afternoon."),
            CollectionWord("die ", "Versichertenkarte", "health insurance card",
                           "Geben Sie mir bitte Ihre Versichertenkarte.", "Please give me your health insurance card."),
            CollectionWord("das ", "Wartezimmer", "waiting room",
                           "Nehmen Sie bitte im Wartezimmer Platz.", "Please take a seat in the waiting room."),
            CollectionWord("die ", "Schmerzen", "pain (plural)",
                           "Ich habe seit gestern starke Schmerzen.", "I’ve been in a lot of pain since yesterday."),
            CollectionWord("das ", "Fieber", "fever, temperature",
                           "Das Kind hat 39 Grad Fieber.", "The child has a temperature of 39 degrees."),
            CollectionWord("der ", "Husten", "cough",
                           "Der Husten wird nachts schlimmer.", "The cough gets worse at night."),
            CollectionWord("das ", "Rezept", "prescription",
                           "Die Ärztin schreibt Ihnen ein Rezept.", "The doctor writes you a prescription."),
            CollectionWord("die ", "Apotheke", "pharmacy, chemist’s",
                           "Die Apotheke an der Ecke hat bis 20 Uhr geöffnet.", "The chemist’s on the corner is open until 8 pm."),
            CollectionWord("die ", "Tablette", "tablet, pill",
                           "Nehmen Sie dreimal am Tag eine Tablette.", "Take one tablet three times a day."),
            CollectionWord("die ", "Überweisung", "referral",
                           "Für den Facharzt brauchen Sie eine Überweisung.", "You need a referral for the specialist."),
            CollectionWord("die ", "Krankmeldung", "sick note",
                           "Die Krankmeldung bekommt Ihr Arbeitgeber direkt.", "Your employer gets the sick note directly."),
            CollectionWord("", "krankgeschrieben", "signed off sick",
                           "Ich bin bis Freitag krankgeschrieben.", "I’m signed off sick until Friday."),
            CollectionWord("", "wehtun", "to hurt",
                           "Mir tut der Rücken weh.", "My back hurts."),
            CollectionWord("", "sich hinlegen", "to lie down",
                           "Legen Sie sich bitte hier hin.", "Please lie down here.")
        ]
    )

    static let flat = WordCollection(
        id: "a2-wohnung", title: "Die Wohnung", subtitle: "Your flat", level: .a2, category: .home, systemImage: "house.fill",
        words: [
            CollectionWord("die ", "Miete", "rent",
                           "Die Miete kostet 750 Euro im Monat.", "The rent is 750 euros a month."),
            CollectionWord("der ", "Vermieter", "landlord",
                           "Der Vermieter wohnt im zweiten Stock.", "The landlord lives on the second floor."),
            CollectionWord("die ", "Nebenkosten", "bills, service charges",
                           "Die Nebenkosten sind nicht in der Miete enthalten.", "The bills aren’t included in the rent."),
            CollectionWord("die ", "Kaution", "deposit",
                           "Die Kaution beträgt drei Monatsmieten.", "The deposit is three months’ rent."),
            CollectionWord("das ", "Zimmer", "room",
                           "Die Wohnung hat drei Zimmer und einen Balkon.", "The flat has three rooms and a balcony."),
            CollectionWord("die ", "Küche", "kitchen",
                           "Die Küche ist klein, aber hell.", "The kitchen is small but bright."),
            CollectionWord("das ", "Bad", "bathroom",
                           "Das Bad hat leider kein Fenster.", "Unfortunately the bathroom has no window."),
            CollectionWord("der ", "Schlüssel", "key",
                           "Ich habe meinen Schlüssel in der Wohnung vergessen.", "I left my key in the flat."),
            CollectionWord("der ", "Nachbar", "neighbour",
                           "Unser Nachbar hat ein Paket für uns angenommen.", "Our neighbour took in a parcel for us."),
            CollectionWord("der ", "Müll", "rubbish",
                           "Den Müll bringen wir jeden Abend runter.", "We take the rubbish down every evening."),
            CollectionWord("die ", "Heizung", "heating",
                           "Die Heizung funktioniert seit Montag nicht.", "The heating hasn’t worked since Monday."),
            CollectionWord("der ", "Hausmeister", "caretaker",
                           "Rufen Sie bitte den Hausmeister an.", "Please call the caretaker."),
            CollectionWord("das ", "Erdgeschoss", "ground floor",
                           "Wir wohnen im Erdgeschoss.", "We live on the ground floor."),
            CollectionWord("", "umziehen", "to move house",
                           "Wir ziehen im Mai nach Leipzig um.", "We’re moving to Leipzig in May."),
            CollectionWord("", "lüften", "to air a room",
                           "Im Winter sollte man kurz und oft lüften.", "In winter you should air rooms briefly and often.")
        ]
    )

    static let shopping = WordCollection(
        id: "a2-einkaufen", title: "Einkaufen", subtitle: "Shopping", level: .a2, category: .food, systemImage: "cart.fill",
        words: [
            CollectionWord("der ", "Einkaufswagen", "trolley",
                           "Für den Einkaufswagen brauchst du einen Euro.", "You need a euro for the trolley."),
            CollectionWord("die ", "Kasse", "checkout, till",
                           "An der Kasse ist heute eine lange Schlange.", "There’s a long queue at the checkout today."),
            CollectionWord("der ", "Kassenbon", "receipt",
                           "Brauchen Sie den Kassenbon?", "Do you need the receipt?"),
            CollectionWord("das ", "Angebot", "special offer",
                           "Die Erdbeeren sind diese Woche im Angebot.", "Strawberries are on offer this week."),
            CollectionWord("das ", "Pfand", "deposit on bottles",
                           "Auf die Flasche gibt es 25 Cent Pfand.", "There’s a 25 cent deposit on the bottle."),
            CollectionWord("die ", "Tüte", "bag",
                           "Möchten Sie eine Tüte?", "Would you like a bag?"),
            CollectionWord("die ", "Karte", "card",
                           "Zahlen Sie mit Karte oder bar?", "Are you paying by card or cash?"),
            CollectionWord("das ", "Kleingeld", "change, coins",
                           "Ich habe leider kein Kleingeld.", "Sorry, I haven’t got any change."),
            CollectionWord("die ", "Größe", "size",
                           "Haben Sie die Jacke auch in Größe M?", "Have you got the jacket in a medium too?"),
            CollectionWord("die ", "Umkleidekabine", "changing room",
                           "Die Umkleidekabinen sind hinten links.", "The changing rooms are at the back on the left."),
            CollectionWord("die ", "Öffnungszeiten", "opening hours",
                           "Die Öffnungszeiten stehen an der Tür.", "The opening hours are on the door."),
            CollectionWord("die ", "Bäckerei", "bakery",
                           "Ich hole schnell Brötchen von der Bäckerei.", "I’ll quickly get some rolls from the bakery."),
            CollectionWord("", "bar bezahlen", "to pay cash",
                           "Kann ich hier nur bar bezahlen?", "Can I only pay cash here?"),
            CollectionWord("", "umtauschen", "to exchange",
                           "Kann ich die Schuhe umtauschen?", "Can I exchange the shoes?"),
            CollectionWord("", "günstig", "cheap, good value",
                           "Auf dem Wochenmarkt ist das Obst oft günstiger.", "Fruit is often cheaper at the weekly market.")
        ]
    )
}
