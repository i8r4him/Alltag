//
//  WordCollections+C2Work.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WordCollections {
    // C2: business, official German and history.

    static let c2Business = WordCollection(
        id: "c2-unternehmen", title: "Unternehmen und Strategie", subtitle: "Business strategy", level: .c2,
        category: .work, systemImage: "chart.bar.fill",
        words: [
            CollectionWord("die ", "Geschäftsführung", "management",
                           "Die Geschäftsführung hat den Umzug nach Berlin beschlossen.", "Management has decided to move to Berlin."),
            CollectionWord("die ", "Gewinnspanne", "profit margin",
                           "Im Lebensmittelhandel ist die Gewinnspanne gering.", "Profit margins in grocery retail are slim."),
            CollectionWord("die ", "Fusion", "merger",
                           "Nach der Fusion wurden 500 Stellen gestrichen.", "After the merger 500 jobs were cut."),
            CollectionWord("die ", "Übernahme", "takeover",
                           "Die Übernahme durch den US-Konzern ist geplatzt.", "The takeover by the US group has fallen through."),
            CollectionWord("die ", "Insolvenz", "insolvency",
                           "Der Händler musste Insolvenz anmelden.", "The retailer had to file for insolvency."),
            CollectionWord("der ", "Marktanteil", "market share",
                           "Wir wollen unseren Marktanteil verdoppeln.", "We want to double our market share."),
            CollectionWord("das ", "Alleinstellungsmerkmal", "unique selling point",
                           "Was ist das Alleinstellungsmerkmal Ihres Produkts?", "What’s your product’s unique selling point?"),
            CollectionWord("das ", "Kerngeschäft", "core business",
                           "Wir konzentrieren uns wieder auf unser Kerngeschäft.", "We’re focusing on our core business again."),
            CollectionWord("die ", "Bilanz", "balance sheet",
                           "Die Bilanz für das letzte Jahr sieht gut aus.", "Last year’s balance sheet looks good."),
            CollectionWord("der ", "Lieferengpass", "supply shortage",
                           "Wegen Lieferengpässen stand die Produktion still.", "Production came to a halt because of supply shortages."),
            CollectionWord("die ", "Stellschraube", "lever (to adjust something)",
                           "Der Preis ist nicht die einzige Stellschraube.", "Price isn’t the only lever we can pull."),
            CollectionWord("der ", "Konzern", "corporation, group",
                           "Sie arbeitet für einen großen Konzern.", "She works for a large corporation."),
            CollectionWord("", "auslagern", "to outsource",
                           "Die IT wurde nach Polen ausgelagert.", "IT was outsourced to Poland."),
            CollectionWord("", "expandieren", "to expand",
                           "Die Kette will nach Österreich expandieren.", "The chain wants to expand into Austria."),
            CollectionWord("", "rentabel", "profitable",
                           "Die Filiale ist schon lange nicht mehr rentabel.", "The branch hasn’t been profitable for a long time.")
        ]
    )

    static let c2Officialese = WordCollection(
        id: "c2-amtsdeutsch", title: "Amtsdeutsch", subtitle: "Official German", level: .c2,
        category: .paperwork, systemImage: "doc.text.fill",
        words: [
            CollectionWord("die ", "Rechtsbehelfsbelehrung", "notice of your right to appeal",
                           "Lesen Sie die Rechtsbehelfsbelehrung am Ende des Bescheids.",
                           "Read the notice of your right to appeal at the end of the decision."),
            CollectionWord("die ", "Mitwirkungspflicht", "duty to co-operate",
                           "Wegen Ihrer Mitwirkungspflicht müssen Sie die Unterlagen nachreichen.",
                           "Because of your duty to co-operate, you have to send in the missing documents."),
            CollectionWord("das ", "Aktenzeichen", "reference number",
                           "Bitte geben Sie bei jedem Schreiben das Aktenzeichen an.", "Please quote the reference number in all letters."),
            CollectionWord("der ", "Säumniszuschlag", "late payment surcharge",
                           "Bei verspäteter Zahlung wird ein Säumniszuschlag fällig.", "A surcharge is due if you pay late."),
            CollectionWord("die ", "Zustellung", "(official) delivery",
                           "Die Frist beginnt mit der Zustellung des Briefes.", "The deadline starts when the letter is delivered."),
            CollectionWord("der ", "Vordruck", "printed form",
                           "Bitte verwenden Sie nur den amtlichen Vordruck.", "Please use only the official form."),
            CollectionWord("der ", "Bevollmächtigte", "authorised representative",
                           "Der Bevollmächtigte muss sich ausweisen.", "The authorised representative has to show ID."),
            CollectionWord("der ", "Ermessensspielraum", "discretion",
                           "Die Behörde hat hier einen gewissen Ermessensspielraum.", "The authority has some discretion here."),
            CollectionWord("der ", "Sachstand", "status, current state of things",
                           "Ich wollte mich nach dem Sachstand meines Antrags erkundigen.",
                           "I wanted to ask about the status of my application."),
            CollectionWord("", "fristgerecht", "on time, within the deadline",
                           "Die Unterlagen sind fristgerecht eingegangen.", "The documents arrived on time."),
            CollectionWord("", "unverzüglich", "without delay",
                           "Änderungen Ihrer Adresse sind unverzüglich mitzuteilen.", "Changes of address must be reported without delay."),
            CollectionWord("", "gemäß", "in accordance with",
                           "Gemäß Paragraf 5 steht Ihnen kein Zuschuss zu.", "Under section 5 you are not entitled to a grant."),
            CollectionWord("", "vorbehaltlich", "subject to",
                           "Die Zusage gilt vorbehaltlich der Prüfung Ihrer Unterlagen.",
                           "The approval is subject to your documents being checked."),
            CollectionWord("", "ordnungsgemäß", "properly",
                           "Das Formular wurde nicht ordnungsgemäß ausgefüllt.", "The form wasn’t filled in properly."),
            CollectionWord("", "zur Kenntnis nehmen", "to note, to take note of",
                           "Wir haben Ihr Schreiben zur Kenntnis genommen.", "We have noted your letter.")
        ]
    )

    static let c2History = WordCollection(
        id: "c2-geschichte", title: "Geschichte und Erinnerung", subtitle: "History and remembrance", level: .c2,
        category: .freeTime, systemImage: "building.columns.fill",
        words: [
            CollectionWord("die ", "Erinnerungskultur", "culture of remembrance",
                           "Die deutsche Erinnerungskultur beeindruckt viele Besucher.",
                           "Germany’s culture of remembrance impresses many visitors."),
            CollectionWord("der ", "Zeitzeuge", "eyewitness (to history)",
                           "In der Schule hat uns ein Zeitzeuge von seiner Flucht erzählt.",
                           "At school an eyewitness told us how he fled."),
            CollectionWord("die ", "Gedenkstätte", "memorial site",
                           "Wir haben die Gedenkstätte in Dachau besucht.", "We visited the memorial site in Dachau."),
            CollectionWord("der ", "Stolperstein", "brass memorial stone in the pavement",
                           "Vor unserem Haus liegen zwei Stolpersteine.",
                           "There are two memorial stones in the pavement outside our house."),
            CollectionWord("der ", "Mauerfall", "fall of the Berlin Wall",
                           "Meine Eltern haben den Mauerfall in Berlin erlebt.",
                           "My parents lived through the fall of the Wall in Berlin."),
            CollectionWord("die ", "Wiedervereinigung", "reunification",
                           "Der 3. Oktober erinnert an die Wiedervereinigung.", "On 3 October Germany remembers reunification."),
            CollectionWord("die ", "Nachkriegszeit", "post-war years",
                           "In der Nachkriegszeit wurde die Stadt fast komplett neu aufgebaut.",
                           "In the post-war years the city was almost completely rebuilt."),
            CollectionWord("die ", "Wende", "the 1989 change in East Germany",
                           "Nach der Wende hat mein Vater seine Arbeit verloren.", "After 1989 my father lost his job."),
            CollectionWord("das ", "Mahnmal", "memorial",
                           "Das Mahnmal erinnert an die Opfer des Krieges.", "The memorial commemorates the victims of the war."),
            CollectionWord("die ", "Aufarbeitung", "coming to terms (with the past)",
                           "Die Aufarbeitung der Stasi-Akten dauert bis heute.",
                           "Working through the Stasi files is still going on today."),
            CollectionWord("das ", "Zeitalter", "age, era",
                           "Wir leben im Zeitalter der Digitalisierung.", "We live in the digital age."),
            CollectionWord("die ", "Überlieferung", "tradition, what has been handed down",
                           "Laut Überlieferung wurde die Kirche im 12. Jahrhundert gebaut.",
                           "According to tradition the church was built in the twelfth century."),
            CollectionWord("", "gedenken", "to remember, to commemorate",
                           "Am 9. November gedenken wir der Opfer.", "On 9 November we remember the victims."),
            CollectionWord("", "vertreiben", "to drive out, to expel",
                           "Nach dem Krieg wurde die Familie aus Schlesien vertrieben.",
                           "After the war the family was driven out of Silesia."),
            CollectionWord("", "geschichtsträchtig", "steeped in history",
                           "Regensburg ist eine geschichtsträchtige Stadt.", "Regensburg is a city steeped in history.")
        ]
    )
}
