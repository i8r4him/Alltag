//
//  GermanWords.swift
//  AlltagKeyboard
//
//  Created by Ibrahim Abdullah on 21.11.26.
//

import Foundation

/// The German the keyboard knows before the learner has typed a word: which words often
/// follow which, and which words every text is full of. Written for Alltag, not taken from a corpus.
enum GermanWords {
    /// For a word (small letters), the words most often written after it.
    static let pairs: [String: [String]] = [
        "ich": ["bin", "habe", "möchte"], "du": ["bist", "hast", "kannst"], "er": ["ist", "hat", "war"],
        "sie": ["ist", "hat", "sind"], "es": ["ist", "gibt", "war"], "wir": ["sind", "haben", "können"],
        "ihr": ["seid", "habt", "könnt"], "man": ["kann", "muss", "sagt"],
        "bin": ["ich", "gleich", "nicht"], "bist": ["du"], "ist": ["das", "nicht", "es"],
        "sind": ["wir", "die", "nicht"], "seid": ["ihr"], "war": ["ich", "sehr", "das"],
        "habe": ["ich", "keine", "eine"], "hab": ["ich", "keine", "dich"], "hast": ["du"], "hat": ["er", "sie", "mir"],
        "haben": ["wir", "Sie", "sie"], "kann": ["ich", "man", "nicht"], "kannst": ["du"],
        "können": ["Sie", "wir", "sie"], "könnten": ["Sie", "wir"], "möchte": ["ich", "gern", "einen"],
        "will": ["ich", "nicht", "nur"], "muss": ["ich", "noch", "jetzt"], "wird": ["es", "schon", "das"],
        "das": ["ist", "war", "geht"], "der": ["ist", "war", "hat"], "die": ["ist", "sind", "haben"],
        "ein": ["bisschen", "paar", "gutes"], "eine": ["Frage", "gute", "kleine"],
        "einen": ["schönen", "Kaffee", "Termin"], "kein": ["Problem", "Thema", "Wunder"],
        "keine": ["Ahnung", "Zeit", "Sorge"],
        "wie": ["geht", "viel", "lange"], "was": ["ist", "machst", "meinst"], "wo": ["bist", "ist", "kann"],
        "wann": ["kommst", "ist", "hast"], "warum": ["nicht", "ist", "hast"], "wer": ["ist", "hat", "kommt"],
        "geht": ["es", "das", "nicht"], "gibt": ["es"], "machst": ["du"], "kommst": ["du"], "meinst": ["du"],
        "guten": ["Morgen", "Tag", "Abend"], "gute": ["Nacht", "Besserung", "Idee"], "vielen": ["Dank"],
        "danke": ["schön", "dir", "für"], "bitte": ["schön", "nicht", "sehr"], "bis": ["später", "morgen", "bald"],
        "schönen": ["Tag", "Abend", "Feierabend"], "schönes": ["Wochenende"], "liebe": ["Grüße"],
        "viele": ["Grüße"], "alles": ["gut", "klar", "Gute"], "hallo": ["wie", "zusammen", "ich"],
        "ja": ["klar", "das", "genau"], "nein": ["danke", "das", "nicht"], "tut": ["mir"],
        "freue": ["mich"], "mich": ["auf", "sehr", "nicht"], "mir": ["geht", "ist", "auch"],
        "dir": ["auch", "geht", "gut"], "dich": ["auch", "sehr", "nicht"],
        "zu": ["Hause", "spät", "viel"], "nach": ["Hause", "der", "dem"], "mit": ["dem", "der", "dir"],
        "in": ["der", "die", "den"], "auf": ["dem", "der", "jeden"], "für": ["dich", "mich", "die"],
        "von": ["mir", "dir", "der"], "bei": ["mir", "dir", "der"], "aus": ["dem", "der", "Deutschland"],
        "am": ["Montag", "Wochenende", "Abend"], "um": ["wie", "die", "zu"], "im": ["Moment", "Büro", "Urlaub"],
        "zum": ["Glück", "Beispiel", "Arzt"], "zur": ["Arbeit", "Schule", "Zeit"],
        "und": ["dann", "ich", "du"], "aber": ["ich", "nicht", "das"], "oder": ["nicht", "so", "was"],
        "wenn": ["du", "ich", "es"], "dass": ["du", "ich", "es"], "weil": ["ich", "es", "du"],
        "ob": ["du", "es", "das"], "nicht": ["so", "mehr", "nur"], "noch": ["nicht", "einmal", "mal"],
        "sehr": ["gut", "gern", "schön"], "auch": ["nicht", "so", "noch"], "schon": ["mal", "wieder", "lange"],
        "so": ["ein", "viel", "gut"], "dann": ["bis", "ist", "können"], "mal": ["sehen", "wieder", "kurz"],
        "heute": ["Abend", "ist", "nicht"], "morgen": ["früh", "Abend", "ist"], "gestern": ["Abend", "war", "habe"],
        "komme": ["aus", "gleich", "später"], "wohne": ["in"], "lerne": ["Deutsch"],
        "spreche": ["ein", "Deutsch", "kein"], "sprechen": ["Sie"], "weiß": ["ich", "nicht", "es"],
        "glaube": ["ich", "nicht", "schon"], "denke": ["ich", "schon", "nicht"], "finde": ["ich", "es", "das"],
        "geehrte": ["Damen", "Frau"], "geehrter": ["Herr"], "damen": ["und"], "freundlichen": ["Grüßen"],
        "gern": ["geschehen"]
    ]

    /// Words of chats that no dictionary lists: they are left as typed.
    static let chat: Set<String> = [
        "ok", "okay", "oki", "hey", "hi", "na", "ne", "nee", "nö", "jo", "joa", "oh", "ah", "aha", "hm", "hmm",
        "haha", "hahaha", "hihi", "lol", "omg", "btw", "bzw", "usw", "zb", "vllt", "mfg", "lg", "vg", "hab", "nix"
    ]

    /// The words every German text is full of.
    static let common: Set<String> = {
        var words: Set<String> = [
            "ab", "alle", "als", "also", "an", "andere", "bald", "da", "dabei", "damit", "danach", "dem", "den",
            "denn", "des", "deshalb", "doch", "dort", "durch", "eigentlich", "einem", "einer", "eines", "einfach",
            "etwas", "euch", "fast", "ganz", "gar", "gegen", "genau", "gerade", "gleich", "gut", "habt", "hatte",
            "hier", "hin", "ihm", "ihn", "ihnen", "immer", "ins", "jetzt", "jeden", "jeder", "kommt", "lange",
            "leider", "machen", "mehr", "mein", "meine", "dein", "deine", "sein", "seine", "unser", "nichts", "nie",
            "nun", "nur", "ohne", "sagen", "sagt", "schön", "seit", "sich", "sollen", "soll", "später", "über",
            "uns", "unter", "viel", "vielleicht", "vom", "vor", "waren", "weiter", "welche", "wenig", "werden",
            "wieder", "wirklich", "wollen", "würde", "zusammen", "zwei", "zwischen"
        ]
        for (word, followers) in pairs {
            words.insert(word)
            for follower in followers where follower.first?.isLowercase == true { words.insert(follower) }
        }
        return words
    }()
}
