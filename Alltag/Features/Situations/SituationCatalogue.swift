//
//  SituationCatalogue.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 12.11.26.
//

import Foundation

/// The everyday situations Alltag offers to train.
enum SituationCatalogue {
    static func situation(id: String) -> Situation? {
        all.first { $0.id == id }
    }

    static func situations(in category: Situation.Category) -> [Situation] {
        all.filter { $0.category == category }
    }

    /// A few situations for Today, different every day.
    static func suggestions(on date: Date = .now, count: Int = 4, calendar: Calendar = .current) -> [Situation] {
        let day = calendar.ordinality(of: .day, in: .era, for: date) ?? 0
        let start = (day * count) % all.count
        return (0..<min(count, all.count)).map { all[(start + $0 * 5) % all.count] }
    }

    // Ordered so that neighbours come from different parts of life.
    static let all: [Situation] = [
        Situation(id: "doctor", category: .health, title: "At the doctor", detail: "Describe what's wrong",
                  systemImage: "stethoscope",
                  role: "a friendly GP (Hausärztin) seeing a patient in the practice",
                  aim: "explain their symptoms, answer the doctor's questions and understand what to do next"),
        Situation(id: "pharmacy", category: .health, title: "At the pharmacy", detail: "Ask for something for a cold",
                  systemImage: "pills.fill",
                  role: "a pharmacist behind the counter of an Apotheke",
                  aim: "say what is wrong, ask for a medicine without a prescription and how to take it"),
        Situation(id: "doctor-call", category: .health, title: "Calling the practice", detail: "Book an appointment by phone",
                  systemImage: "phone.fill",
                  role: "the receptionist of a doctor's practice, on the phone",
                  aim: "book an appointment this week and give their name and insurance"),

        Situation(id: "buergeramt", category: .authorities, title: "At the Bürgeramt", detail: "Register your new address",
                  systemImage: "building.columns.fill",
                  role: "a clerk at the Bürgeramt handling an Anmeldung",
                  aim: "register their new address, hand over the right documents and ask what happens next"),
        Situation(id: "immigration", category: .authorities, title: "At the Ausländerbehörde",
                  detail: "Ask about your residence permit", systemImage: "person.text.rectangle.fill",
                  role: "a clerk at the Ausländerbehörde",
                  aim: "ask how to extend their residence permit and which documents they need"),
        Situation(id: "bank", category: .authorities, title: "At the bank", detail: "Open an account",
                  systemImage: "creditcard.fill",
                  role: "an adviser at a German bank branch",
                  aim: "open a current account (Girokonto) and ask about fees and the card"),
        Situation(id: "post-office", category: .authorities, title: "At the post office", detail: "Send a parcel abroad",
                  systemImage: "shippingbox.fill",
                  role: "a clerk at the counter of a post office",
                  aim: "send a parcel abroad, ask what it costs and how long it takes"),

        Situation(id: "landlord", category: .home, title: "Calling the landlord", detail: "Report that the heating is broken",
                  systemImage: "house.fill",
                  role: "the learner's landlord, on the phone",
                  aim: "explain that the heating does not work and agree when someone comes to repair it"),
        Situation(id: "viewing", category: .home, title: "Flat viewing", detail: "Ask about the rent and the flat",
                  systemImage: "key.fill",
                  role: "an estate agent showing a flat to rent",
                  aim: "ask about the rent, extra costs and the move-in date, and say something about themselves"),
        Situation(id: "neighbour", category: .home, title: "Meeting a neighbour", detail: "Introduce yourself in the stairwell",
                  systemImage: "figure.2",
                  role: "a neighbour who lives in the same building and meets the learner in the stairwell",
                  aim: "introduce themselves, make small talk and ask something about the building"),
        Situation(id: "tradesperson", category: .home, title: "A repair at home", detail: "Explain the problem to the plumber",
                  systemImage: "wrench.adjustable.fill",
                  role: "a plumber who has come to the learner's flat",
                  aim: "show and explain what is broken and ask how long the repair takes and what it costs"),

        Situation(id: "interview", category: .work, title: "Job interview", detail: "Talk about yourself and your experience",
                  systemImage: "briefcase.fill",
                  role: "a hiring manager interviewing the learner for a job",
                  aim: "introduce themselves, describe their experience and ask one question about the job"),
        Situation(id: "sick", category: .work, title: "Calling in sick", detail: "Tell your boss you can't come in",
                  systemImage: "thermometer.medium",
                  role: "the learner's manager, on the phone in the morning",
                  aim: "say that they are ill, how long they will be away and what happens with their work"),
        Situation(id: "colleagues", category: .work, title: "Lunch with colleagues", detail: "Small talk about the weekend",
                  systemImage: "cup.and.saucer.fill",
                  role: "a friendly colleague at lunch in the canteen",
                  aim: "talk about their weekend, ask questions back and keep the small talk going"),

        Situation(id: "bakery", category: .outAndAbout, title: "At the bakery", detail: "Order bread and rolls",
                  systemImage: "storefront.fill",
                  role: "a shop assistant in a busy bakery",
                  aim: "order bread and rolls, ask what something is, and pay"),
        Situation(id: "restaurant", category: .outAndAbout, title: "At a restaurant", detail: "Order, ask a question and pay",
                  systemImage: "fork.knife",
                  role: "a waiter in a German restaurant",
                  aim: "order food and a drink, ask about a dish and ask for the bill"),
        Situation(id: "supermarket", category: .outAndAbout, title: "At the supermarket", detail: "Ask where to find something",
                  systemImage: "cart.fill",
                  role: "a supermarket employee stocking shelves",
                  aim: "ask where to find two things and whether something is in stock"),
        Situation(id: "station", category: .outAndAbout, title: "At the station", detail: "Buy a ticket and ask about the platform",
                  systemImage: "tram.fill",
                  role: "a clerk at the ticket desk of a railway station",
                  aim: "buy a ticket for today, ask which platform the train leaves from and whether they must change"),
        Situation(id: "hairdresser", category: .outAndAbout, title: "At the hairdresser", detail: "Say how you'd like your hair",
                  systemImage: "scissors",
                  role: "a hairdresser greeting a customer",
                  aim: "say what haircut they want, answer questions and make small talk")
    ]
}
