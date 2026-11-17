//
//  WordCollections+C2Life.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WordCollections {
    // C2: food, home, health and life between two countries.

    static let c2FoodCulture = WordCollection(
        id: "c2-esskultur", title: "Esskultur", subtitle: "Food culture", level: .c2, category: .food, systemImage: "fork.knife",
        words: [
            CollectionWord("die ", "Tischsitten", "table manners (plural)",
                           "In Japan gelten ganz andere Tischsitten.", "Table manners are very different in Japan."),
            CollectionWord("die ", "Gastfreundschaft", "hospitality",
                           "Die Gastfreundschaft meiner Schwiegereltern ist überwältigend.", "My in-laws’ hospitality is overwhelming."),
            CollectionWord("die ", "Hausmannskost", "plain home cooking",
                           "In der Kantine gibt es einfache Hausmannskost.", "The canteen serves plain home cooking."),
            CollectionWord("das ", "Leibgericht", "favourite dish",
                           "Rouladen sind das Leibgericht meines Vaters.", "Beef roulades are my father’s favourite dish."),
            CollectionWord("die ", "Fastenzeit", "Lent, a time of fasting",
                           "In der Fastenzeit verzichtet sie auf Süßigkeiten.", "During Lent she gives up sweets."),
            CollectionWord("die ", "Völlerei", "gluttony",
                           "Nach der Völlerei an Weihnachten mache ich erst mal Pause.",
                           "After the Christmas gluttony I’m taking a break."),
            CollectionWord("der ", "Leckerbissen", "treat, delicacy",
                           "Frischer Spargel ist für viele ein Leckerbissen.", "For many people, fresh asparagus is a real treat."),
            CollectionWord("der ", "Kaffeeklatsch", "coffee and a chat",
                           "Sonntags ist bei Oma immer Kaffeeklatsch.", "On Sundays there’s always coffee and a chat at Grandma’s."),
            CollectionWord("die ", "Brotzeit", "snack, light meal (southern)",
                           "Zur Brotzeit gibt es Brezen und Obatzda.", "For a snack there are pretzels and Obatzda."),
            CollectionWord("der ", "Nachschlag", "second helping",
                           "Möchte noch jemand einen Nachschlag?", "Would anyone like seconds?"),
            CollectionWord("", "schlemmen", "to feast",
                           "Im Urlaub haben wir nur geschlemmt.", "On holiday we did nothing but feast."),
            CollectionWord("", "auftischen", "to serve up",
                           "Meine Mutter tischt immer viel zu viel auf.", "My mother always serves up far too much."),
            CollectionWord("", "üppig", "lavish",
                           "Das Frühstück im Hotel war sehr üppig.", "The hotel breakfast was very lavish."),
            CollectionWord("", "mäkelig", "fussy (about food)",
                           "Unser Sohn ist beim Essen sehr mäkelig.", "Our son is very fussy about food."),
            CollectionWord("", "naschen", "to nibble (sweets)",
                           "Wer hat schon wieder von der Schokolade genascht?", "Who’s been at the chocolate again?")
        ]
    )

    static let c2City = WordCollection(
        id: "c2-stadtwandel", title: "Stadt im Wandel", subtitle: "A changing city", level: .c2,
        category: .home, systemImage: "building.2.fill",
        words: [
            CollectionWord("die ", "Gentrifizierung", "gentrification",
                           "Durch die Gentrifizierung können sich viele das Viertel nicht mehr leisten.",
                           "Because of gentrification many people can no longer afford the area."),
            CollectionWord("die ", "Verdrängung", "displacement (of residents)",
                           "Mieterinitiativen kämpfen gegen die Verdrängung alter Bewohner.",
                           "Tenant groups fight against long-time residents being pushed out."),
            CollectionWord("der ", "Leerstand", "empty buildings",
                           "Trotz Wohnungsnot gibt es in der Stadt viel Leerstand.",
                           "Despite the housing shortage, many buildings in the city stand empty."),
            CollectionWord("die ", "Zweckentfremdung", "misuse (of housing)",
                           "Die Stadt geht gegen die Zweckentfremdung von Wohnungen als Ferienwohnungen vor.",
                           "The city is cracking down on flats being turned into holiday lets."),
            CollectionWord("der ", "Denkmalschutz", "listed-building protection",
                           "Das Haus steht unter Denkmalschutz.", "The house is a listed building."),
            CollectionWord("das ", "Quartier", "quarter, neighbourhood",
                           "Im neuen Quartier gibt es Wohnungen, Läden und eine Kita.", "The new quarter has flats, shops and a nursery."),
            CollectionWord("der ", "Speckgürtel", "commuter belt",
                           "Viele Familien ziehen in den Speckgürtel von München.", "Many families move to Munich’s commuter belt."),
            CollectionWord("die ", "Nachverdichtung", "building on free space in the city",
                           "Durch die Nachverdichtung verschwinden viele Innenhöfe.",
                           "Building on every free space is making many courtyards disappear."),
            CollectionWord("die ", "Baulücke", "gap site",
                           "In der Baulücke entsteht ein Wohnhaus.", "A block of flats is going up in the gap site."),
            CollectionWord("das ", "Wohnprojekt", "co-housing project",
                           "Wir leben in einem Wohnprojekt mit drei Generationen.",
                           "We live in a co-housing project with three generations."),
            CollectionWord("die ", "Genossenschaft", "housing co-operative",
                           "Die Wohnungen der Genossenschaft sind viel günstiger.", "The co-op’s flats are much cheaper."),
            CollectionWord("der ", "Plattenbau", "prefab tower block",
                           "Ich bin in einem Plattenbau in Rostock aufgewachsen.", "I grew up in a prefab block in Rostock."),
            CollectionWord("die ", "Zersiedelung", "urban sprawl",
                           "Die Zersiedelung frisst immer mehr Ackerland.", "Urban sprawl is eating up more and more farmland."),
            CollectionWord("", "aufwerten", "to smarten up, to upgrade",
                           "Das neue Café hat die ganze Straße aufgewertet.", "The new café has smartened up the whole street."),
            CollectionWord("", "lebenswert", "liveable",
                           "Weniger Autos machen die Stadt lebenswerter.", "Fewer cars make the city more liveable.")
        ]
    )

    static let c2HealthEthics = WordCollection(
        id: "c2-ethik", title: "Medizin und Ethik", subtitle: "Medicine and ethics", level: .c2,
        category: .health, systemImage: "stethoscope",
        words: [
            CollectionWord("die ", "Sterbehilfe", "assisted dying",
                           "Über Sterbehilfe wird in Deutschland heftig gestritten.", "Assisted dying is hotly debated in Germany."),
            CollectionWord("der ", "Placeboeffekt", "placebo effect",
                           "Vielleicht war es nur der Placeboeffekt.", "Maybe it was just the placebo effect."),
            CollectionWord("die ", "Fehldiagnose", "misdiagnosis",
                           "Nach einer Fehldiagnose wurde sie monatelang falsch behandelt.",
                           "After a misdiagnosis she was given the wrong treatment for months."),
            CollectionWord("der ", "Pflegenotstand", "crisis in care",
                           "Der Pflegenotstand trifft vor allem die Altenheime.", "The care crisis hits care homes hardest."),
            CollectionWord("die ", "Lebenserwartung", "life expectancy",
                           "Die Lebenserwartung in Deutschland steigt kaum noch.", "Life expectancy in Germany is barely rising any more."),
            CollectionWord("die ", "Zweiklassenmedizin", "two-tier medicine",
                           "Privatpatienten bekommen schneller Termine, das ist Zweiklassenmedizin.",
                           "Private patients get appointments faster, that’s two-tier medicine."),
            CollectionWord("die ", "Resilienz", "resilience",
                           "Resilienz kann man trainieren.", "Resilience can be trained."),
            CollectionWord("die ", "Prävention", "prevention",
                           "Die Krankenkassen sollten mehr Geld für Prävention ausgeben.",
                           "Health insurers should spend more on prevention."),
            CollectionWord("die ", "Einwilligung", "consent",
                           "Ohne Ihre Einwilligung dürfen wir die Daten nicht weitergeben.",
                           "We may not pass on the data without your consent."),
            CollectionWord("die ", "Schweigepflicht", "duty of confidentiality",
                           "Ärzte unterliegen der Schweigepflicht.", "Doctors are bound by confidentiality."),
            CollectionWord("die ", "Palliativmedizin", "palliative care",
                           "In der Palliativmedizin geht es um Lebensqualität.", "Palliative care is about quality of life."),
            CollectionWord("der ", "Hypochonder", "hypochondriac",
                           "Seit er Symptome googelt, ist er ein richtiger Hypochonder.",
                           "Since he started googling symptoms he’s become a real hypochondriac."),
            CollectionWord("", "psychosomatisch", "psychosomatic",
                           "Die Rückenschmerzen sind wohl psychosomatisch.", "The back pain is probably psychosomatic."),
            CollectionWord("", "unheilbar", "incurable",
                           "Die Krankheit ist leider unheilbar.", "Sadly, the illness is incurable."),
            CollectionWord("", "ausgebrannt", "burnt out",
                           "Nach drei Jahren Nachtschicht fühlte sie sich völlig ausgebrannt.",
                           "After three years of night shifts she felt completely burnt out.")
        ]
    )

    static let c2Belonging = WordCollection(
        id: "c2-heimat", title: "Fernweh und Heimat", subtitle: "Wanderlust and home", level: .c2,
        category: .travel, systemImage: "globe.europe.africa.fill",
        words: [
            CollectionWord("das ", "Fernweh", "wanderlust",
                           "Im November packt mich immer das Fernweh.", "In November I always get wanderlust."),
            CollectionWord("der ", "Kulturschock", "culture shock",
                           "Den ersten Kulturschock hatte ich beim Mülltrennen.", "My first culture shock was sorting the rubbish."),
            CollectionWord("die ", "Zugehörigkeit", "belonging",
                           "Im Chor habe ich zum ersten Mal ein Gefühl der Zugehörigkeit gespürt.",
                           "In the choir I felt a sense of belonging for the first time."),
            CollectionWord("die ", "Wahlheimat", "adopted home",
                           "Hamburg ist längst meine Wahlheimat.", "Hamburg has long been my adopted home."),
            CollectionWord("der ", "Weltenbummler", "globetrotter",
                           "Mein Onkel war ein echter Weltenbummler.", "My uncle was a real globetrotter."),
            CollectionWord("die ", "Auswanderung", "emigration",
                           "Die Auswanderung nach Kanada war die beste Entscheidung unseres Lebens.",
                           "Emigrating to Canada was the best decision of our lives."),
            CollectionWord("die ", "Entwurzelung", "being uprooted",
                           "Viele Geflüchtete sprechen von einem Gefühl der Entwurzelung.",
                           "Many refugees speak of a feeling of being uprooted."),
            CollectionWord("die ", "Fremde", "foreign parts, abroad",
                           "In der Fremde lernt man die Heimat neu schätzen.", "Abroad you learn to appreciate home all over again."),
            CollectionWord("die ", "Reiselust", "love of travel",
                           "Die Reiselust der Deutschen ist ungebrochen.", "Germans’ love of travel is as strong as ever."),
            CollectionWord("der ", "Auslandsaufenthalt", "stay abroad",
                           "Ein Auslandsaufenthalt hat mein Leben verändert.", "A stay abroad changed my life."),
            CollectionWord("", "heimisch", "at home, settled",
                           "Nach zwei Jahren fühle ich mich hier endlich heimisch.", "After two years I finally feel at home here."),
            CollectionWord("", "weltoffen", "cosmopolitan, open to the world",
                           "Leipzig ist eine junge, weltoffene Stadt.", "Leipzig is a young, cosmopolitan city."),
            CollectionWord("", "Wurzeln schlagen", "to put down roots",
                           "Es dauert, bis man in einem neuen Land Wurzeln schlägt.", "It takes time to put down roots in a new country."),
            CollectionWord("", "aufbrechen", "to set off",
                           "Morgen früh brechen wir nach Island auf.", "Tomorrow morning we set off for Iceland."),
            CollectionWord("", "sesshaft werden", "to settle down",
                           "Nach Jahren auf Reisen ist er in Freiburg sesshaft geworden.",
                           "After years of travelling he settled down in Freiburg.")
        ]
    )
}
