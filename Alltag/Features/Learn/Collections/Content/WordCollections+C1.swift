//
//  WordCollections+C1.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WordCollections {
    /// C1: fifteen topics of fifteen words, in the `WordCollections+C1…` files, for
    /// learners who get by everywhere and want to sound precise. This file has people and everyday life.
    static let c1: [WordCollection] = [
        c1Discussing, c1Personality, c1Conflicts, c1Language, c1Science, c1Food, c1Gastronomy, c1Property, c1Medicine, c1Mobility,
        c1Leadership, c1EmploymentLaw, c1Law, c1Economy, c1Art
    ]

    static let c1Discussing = WordCollection(
        id: "c1-diskutieren", title: "Diskutieren und Argumentieren", subtitle: "Discussing and arguing", level: .c1,
        category: .work, systemImage: "bubble.left.and.bubble.right.fill",
        words: [
            CollectionWord("das ", "Gegenargument", "counter-argument",
                           "Darauf habe ich gerade kein gutes Gegenargument.", "I don’t have a good counter-argument to that right now."),
            CollectionWord("der ", "Standpunkt", "point of view",
                           "Ich kann deinen Standpunkt nachvollziehen, aber ich teile ihn nicht.",
                           "I can follow your point of view, but I don’t share it."),
            CollectionWord("die ", "These", "claim, thesis",
                           "Diese These ist ziemlich gewagt.", "That claim is pretty bold."),
            CollectionWord("der ", "Einwand", "objection",
                           "Gibt es noch Einwände, bevor wir abstimmen?", "Are there any objections before we vote?"),
            CollectionWord("die ", "Schlussfolgerung", "conclusion",
                           "Welche Schlussfolgerung ziehen Sie daraus?", "What conclusion do you draw from that?"),
            CollectionWord("der ", "Aspekt", "aspect",
                           "Diesen Aspekt haben wir bisher völlig übersehen.", "We’ve completely overlooked this aspect so far."),
            CollectionWord("die ", "Begründung", "reason, justification",
                           "Ohne Begründung kann ich das nicht akzeptieren.", "I can’t accept that without a reason."),
            CollectionWord("der ", "Beleg", "evidence",
                           "Gibt es dafür einen Beleg, oder ist das nur ein Gefühl?",
                           "Is there any evidence for that, or is it just a feeling?"),
            CollectionWord("", "einräumen", "to concede",
                           "Ich muss einräumen, dass du in diesem Punkt recht hast.", "I have to admit that you’re right on this point."),
            CollectionWord("", "widersprechen", "to disagree, to contradict",
                           "Da muss ich Ihnen leider widersprechen.", "I’m afraid I have to disagree with you there."),
            CollectionWord("", "abwägen", "to weigh up",
                           "Wir sollten die Vor- und Nachteile genau abwägen.", "We should weigh up the pros and cons carefully."),
            CollectionWord("", "untermauern", "to back up (with facts)",
                           "Können Sie das mit Zahlen untermauern?", "Can you back that up with figures?"),
            CollectionWord("", "relativieren", "to qualify, to play down",
                           "Er hat seine Aussage später relativiert.", "He later qualified his statement."),
            CollectionWord("", "stichhaltig", "sound, convincing",
                           "Ihre Argumente sind durchaus stichhaltig.", "Your arguments are perfectly sound."),
            CollectionWord("", "einseitig", "one-sided",
                           "Der Artikel ist mir zu einseitig.", "The article is too one-sided for me.")
        ]
    )

    static let c1Personality = WordCollection(
        id: "c1-persoenlichkeit", title: "Charakter und Persönlichkeit", subtitle: "Character and personality", level: .c1,
        category: .people, systemImage: "person.crop.circle.fill",
        words: [
            CollectionWord("die ", "Eigenschaft", "trait, quality",
                           "Welche Eigenschaft schätzt du an ihr am meisten?", "Which quality do you value most in her?"),
            CollectionWord("das ", "Selbstbewusstsein", "self-confidence",
                           "Seit dem neuen Job hat sie viel mehr Selbstbewusstsein.",
                           "Since her new job she has a lot more self-confidence."),
            CollectionWord("die ", "Gelassenheit", "calm, composure",
                           "Mit den Jahren habe ich mehr Gelassenheit gelernt.", "Over the years I’ve learned to stay calmer."),
            CollectionWord("die ", "Bescheidenheit", "modesty",
                           "Trotz ihres Erfolgs hat sie ihre Bescheidenheit nicht verloren.", "Despite her success she has stayed modest."),
            CollectionWord("die ", "Zuverlässigkeit", "reliability",
                           "Bei uns zählt vor allem Zuverlässigkeit.", "What counts most for us is reliability."),
            CollectionWord("die ", "Hilfsbereitschaft", "willingness to help",
                           "Die Hilfsbereitschaft der Nachbarn hat uns sehr berührt.",
                           "Our neighbours’ willingness to help really touched us."),
            CollectionWord("die ", "Neugier", "curiosity",
                           "Aus reiner Neugier habe ich mich für den Kurs angemeldet.",
                           "I signed up for the course out of pure curiosity."),
            CollectionWord("die ", "Schwäche", "weakness",
                           "Ungeduld ist meine größte Schwäche.", "Impatience is my biggest weakness."),
            CollectionWord("", "zurückhaltend", "reserved",
                           "Am Anfang wirkt er zurückhaltend, aber er ist sehr witzig.",
                           "He seems reserved at first, but he’s very funny."),
            CollectionWord("", "aufgeschlossen", "open-minded, outgoing",
                           "Meine neuen Kollegen sind sehr aufgeschlossen.", "My new colleagues are very open and friendly."),
            CollectionWord("", "eigensinnig", "headstrong",
                           "Unsere Tochter ist ziemlich eigensinnig.", "Our daughter is pretty headstrong."),
            CollectionWord("", "gewissenhaft", "conscientious",
                           "Sie arbeitet sehr gewissenhaft und vergisst nie etwas.",
                           "She works very conscientiously and never forgets anything."),
            CollectionWord("", "einfühlsam", "sensitive, empathetic",
                           "Die Ärztin war unglaublich einfühlsam.", "The doctor was incredibly sensitive."),
            CollectionWord("", "schlagfertig", "quick-witted",
                           "Ich wäre gern so schlagfertig wie meine Schwester.", "I wish I were as quick-witted as my sister."),
            CollectionWord("", "sich durchsetzen", "to assert yourself",
                           "In großen Runden kann ich mich schlecht durchsetzen.", "I find it hard to assert myself in big groups.")
        ]
    )

    static let c1Conflicts = WordCollection(
        id: "c1-konflikte", title: "Konflikte lösen", subtitle: "Resolving conflicts", level: .c1,
        category: .people, systemImage: "person.2.fill",
        words: [
            CollectionWord("die ", "Meinungsverschiedenheit", "disagreement",
                           "Wir hatten eine kleine Meinungsverschiedenheit über den Urlaub.",
                           "We had a small disagreement about the holiday."),
            CollectionWord("der ", "Streitpunkt", "point of contention",
                           "Der größte Streitpunkt bei uns ist immer der Abwasch.",
                           "Our biggest point of contention is always the washing-up."),
            CollectionWord("das ", "klärende Gespräch", "a talk to clear the air",
                           "Nach dem Streit hatten wir ein klärendes Gespräch.", "After the row we had a talk to clear the air."),
            CollectionWord("die ", "Einigung", "agreement",
                           "Nach langem Hin und Her haben wir eine Einigung gefunden.",
                           "After a lot of back and forth we reached an agreement."),
            CollectionWord("die ", "Sichtweise", "perspective",
                           "Versuch doch mal, seine Sichtweise zu verstehen.", "Try to understand his perspective."),
            CollectionWord("die ", "Versöhnung", "reconciliation",
                           "Zur Versöhnung hat er ihr Blumen mitgebracht.", "He brought her flowers to make up."),
            CollectionWord("die ", "Ich-Botschaft", "“I” statement",
                           "Mit Ich-Botschaften klingt Kritik weniger wie ein Angriff.",
                           "With “I” statements, criticism sounds less like an attack."),
            CollectionWord("der ", "Vermittler", "mediator",
                           "Ein neutraler Vermittler kann bei Streit im Team helfen.",
                           "A neutral mediator can help with conflict in a team."),
            CollectionWord("die ", "Eskalation", "escalation",
                           "Wir wollten eine Eskalation unbedingt vermeiden.", "We absolutely wanted to stop things escalating."),
            CollectionWord("", "nachgeben", "to give in",
                           "Diesmal gebe ich nicht nach.", "This time I won’t give in."),
            CollectionWord("", "sich einmischen", "to interfere",
                           "Misch dich bitte nicht in unsere Angelegenheiten ein.", "Please don’t interfere in our business."),
            CollectionWord("", "beschwichtigen", "to calm down, to placate",
                           "Er versuchte, die wütenden Gäste zu beschwichtigen.", "He tried to calm down the angry guests."),
            CollectionWord("", "sich aussprechen", "to talk things through",
                           "Wir sollten uns endlich mal in Ruhe aussprechen.", "We should finally talk things through calmly."),
            CollectionWord("", "einlenken", "to back down, to come round",
                           "Nach einer Woche hat der Vermieter doch eingelenkt.", "After a week the landlord came round after all."),
            CollectionWord("", "verletzend", "hurtful",
                           "Deine Bemerkung war ziemlich verletzend.", "Your comment was pretty hurtful.")
        ]
    )

    static let c1Language = WordCollection(
        id: "c1-sprache", title: "Sprache und Kommunikation", subtitle: "Language and communication", level: .c1,
        category: .everyday, systemImage: "character.bubble.fill",
        words: [
            CollectionWord("die ", "Mehrsprachigkeit", "being multilingual",
                           "Bei uns zu Hause ist Mehrsprachigkeit ganz normal.", "Being multilingual is completely normal in our home."),
            CollectionWord("die ", "Redewendung", "idiom, saying",
                           "Diese Redewendung kenne ich gar nicht.", "I don’t know that saying at all."),
            CollectionWord("der ", "Dialekt", "dialect",
                           "Mein Schwiegervater spricht so starken Dialekt, dass ich kaum etwas verstehe.",
                           "My father-in-law has such a strong dialect that I hardly understand a thing."),
            CollectionWord("der ", "Akzent", "accent",
                           "Man hört bei dir kaum noch einen Akzent.", "You can hardly hear an accent any more when you speak."),
            CollectionWord("die ", "Körpersprache", "body language",
                           "Seine Körpersprache verrät, dass er nervös ist.", "His body language gives away that he’s nervous."),
            CollectionWord("der ", "Tonfall", "tone of voice",
                           "Es geht nicht darum, was du sagst, sondern um den Tonfall.", "It’s not what you say, it’s your tone."),
            CollectionWord("die ", "Andeutung", "hint",
                           "Sie hat nur eine Andeutung gemacht, aber ich habe es verstanden.", "She only dropped a hint, but I got it."),
            CollectionWord("das ", "Fingerspitzengefühl", "tact, a delicate touch",
                           "Für dieses Gespräch braucht man viel Fingerspitzengefühl.", "This conversation needs a lot of tact."),
            CollectionWord("die ", "Fachsprache", "technical language, jargon",
                           "Die Fachsprache in Arztbriefen verstehe ich kaum.", "I barely understand the jargon in doctors’ letters."),
            CollectionWord("der ", "Smalltalk", "small talk",
                           "Beim Smalltalk mit Kollegen fehlen mir oft die Worte.",
                           "I’m often lost for words making small talk with colleagues."),
            CollectionWord("", "umschreiben", "to put another way, to paraphrase",
                           "Wenn dir ein Wort fehlt, umschreib es einfach.", "If you can’t think of a word, just describe it another way."),
            CollectionWord("", "sich verständigen", "to make yourself understood",
                           "Mit Händen und Füßen konnten wir uns gut verständigen.",
                           "We managed to make ourselves understood with gestures."),
            CollectionWord("", "sich verhaspeln", "to trip over your words",
                           "Vor Aufregung habe ich mich ständig verhaspelt.", "I kept tripping over my words because I was nervous."),
            CollectionWord("", "wortwörtlich", "word for word, literally",
                           "Das darfst du nicht wortwörtlich übersetzen.", "You mustn’t translate that word for word."),
            CollectionWord("", "missverständlich", "unclear, open to misunderstanding",
                           "Die E-Mail war etwas missverständlich formuliert.", "The email was worded in a slightly confusing way.")
        ]
    )

    static let c1Science = WordCollection(
        id: "c1-wissenschaft", title: "Wissenschaft und Forschung", subtitle: "Science and research", level: .c1,
        category: .everyday, systemImage: "flask.fill",
        words: [
            CollectionWord("die ", "Forschung", "research",
                           "Sie arbeitet in der Forschung an einer Uniklinik.", "She works in research at a university hospital."),
            CollectionWord("die ", "Studie", "study",
                           "Laut einer neuen Studie schlafen wir zu wenig.", "According to a new study, we don’t sleep enough."),
            CollectionWord("die ", "Erkenntnis", "finding, insight",
                           "Die neuen Erkenntnisse überraschen selbst die Experten.", "The new findings surprise even the experts."),
            CollectionWord("die ", "Hypothese", "hypothesis",
                           "Die Hypothese konnte nicht bestätigt werden.", "The hypothesis couldn’t be confirmed."),
            CollectionWord("das ", "Experiment", "experiment",
                           "Im Experiment schliefen die Teilnehmer in einem dunklen Raum.",
                           "In the experiment the participants slept in a dark room."),
            CollectionWord("der ", "Proband", "test subject",
                           "Für die Studie werden noch Probanden gesucht.", "They’re still looking for test subjects for the study."),
            CollectionWord("die ", "Fachzeitschrift", "academic journal",
                           "Der Artikel erscheint nächsten Monat in einer Fachzeitschrift.",
                           "The article comes out in a journal next month."),
            CollectionWord("der ", "Durchbruch", "breakthrough",
                           "Der Impfstoff war ein medizinischer Durchbruch.", "The vaccine was a medical breakthrough."),
            CollectionWord("die ", "Wissenschaftlerin", "scientist (woman)",
                           "Meine Tochter will Wissenschaftlerin werden.", "My daughter wants to be a scientist."),
            CollectionWord("die ", "Fachleute", "experts (plural)",
                           "Die Fachleute sind sich in dieser Frage nicht einig.", "The experts don’t agree on this question."),
            CollectionWord("die ", "Messung", "measurement",
                           "Die Messungen zeigen einen deutlichen Anstieg.", "The measurements show a clear rise."),
            CollectionWord("", "belegen", "to prove, to show",
                           "Das ist wissenschaftlich gut belegt.", "That’s well proven scientifically."),
            CollectionWord("", "erforschen", "to research, to explore",
                           "Das Gehirn ist noch lange nicht vollständig erforscht.", "The brain is still far from fully understood."),
            CollectionWord("", "nachweisen", "to detect, to prove",
                           "Im Wasser wurden Spuren von Mikroplastik nachgewiesen.", "Traces of microplastics were found in the water."),
            CollectionWord("", "repräsentativ", "representative",
                           "Die Umfrage ist leider nicht repräsentativ.", "Unfortunately the survey isn’t representative.")
        ]
    )
}
