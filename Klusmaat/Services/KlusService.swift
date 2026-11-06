//
//  KlusService.swift
//  Klusmaat
//
//  Services/ bevat logica die met externe systemen praat (later Firebase). Deze service haalt straks klussen op en slaat ze op.
//

import Foundation

final class KlusService {
    /// Voorbeeldklussen tot Firebase er is, gelijk aan sampleJobs op Android.
    static let voorbeeldKlussen: [Klus] = [
        Klus(id: "1", titel: "Heg snoeien in de voortuin", soort: .tuin, afstand: "400 m", afstandMeters: 400, vergoeding: 40,
             wanneer: "Za 10 okt", timing: .weekend, duur: .halveDag, urenGeleden: 2,
             fotos: foto("klusmaat-1-1", "klusmaat-1-2", "klusmaat-1-3"), gereedschapAanwezig: true,
             beschrijving: "Ongeveer 6 meter heg langs de stoep, gereedschap is aanwezig. "
                 + "De heg is al een paar jaar niet goed bijgehouden, dus hij is aan de bovenkant flink "
                 + "uitgegroeid. Het groenafval mag in de container achter het huis. Koffie en "
                 + "appeltaart staan klaar, en als het uitkomt kun je ook meteen even naar de "
                 + "klimop aan de zijgevel kijken.",
             eigenaar: "Anouk", geplaatst: "2 uur geleden"),
        Klus(id: "2", titel: "Kast in elkaar zetten", soort: .binnen, afstand: "1,2 km", afstandMeters: 1200, vergoeding: 35,
             wanneer: "Di 13 okt", timing: .dezeWeek, duur: .halveDag, urenGeleden: 20,
             fotos: foto("klusmaat-2-1"),
             beschrijving: "IKEA Pax, handleiding kwijt. Twee linkerhanden hier.",
             eigenaar: "Samir", geplaatst: "gisteren"),
        Klus(id: "3", titel: "Lekkende kraan in de keuken", soort: .reparatie, afstand: "800 m", afstandMeters: 800, vergoeding: 25,
             wanneer: "Deze week", timing: .dezeWeek, urenGeleden: 5,
             fotos: foto("klusmaat-3-1", "klusmaat-3-2"), gereedschapAanwezig: true,
             beschrijving: "Druppelt al een week, nieuwe leertjes liggen klaar. Ik heb zelf al "
                 + "geprobeerd de kraan open te draaien maar de moer zit muurvast. Waarschijnlijk "
                 + "moet de hoofdkraan even dicht, die zit in de meterkast. Liefst deze week nog, "
                 + "want de waterrekening loopt op.",
             eigenaar: "Ria", geplaatst: "vandaag"),
        Klus(id: "4", titel: "Gras maaien en onkruid wieden", soort: .tuin, afstand: "1,5 km", afstandMeters: 1500, vergoeding: 30,
             wanneer: "In het weekend", timing: .weekend, urenGeleden: 72, gereedschapAanwezig: true,
             beschrijving: "Achtertuin van zo'n 30 m², maaier staat in de schuur.",
             eigenaar: "Joost", geplaatst: "3 dagen geleden"),
        Klus(id: "5", titel: "Schilderij en planken ophangen", soort: .binnen, afstand: "2,0 km", afstandMeters: 2000, vergoeding: 20,
             urenGeleden: 22,
             beschrijving: "Drie planken en een grote spiegel, boor heb ik niet.",
             eigenaar: "Fatima", geplaatst: "gisteren"),
        Klus(id: "6", titel: "Fietsband plakken", soort: .reparatie, afstand: "600 m", afstandMeters: 600, vergoeding: 15,
             wanneer: "Voor vrijdag", timing: .dezeWeek, urenGeleden: 1,
             fotos: foto("klusmaat-6-1"),
             beschrijving: "Achterband is lek, liefst voor het weekend.",
             eigenaar: "Kees", geplaatst: "1 uur geleden"),
        Klus(id: "7", titel: "Verhuisdozen naar de zolder", soort: .binnen, afstand: "900 m", afstandMeters: 900, vergoeding: 25,
             wanneer: "Zo 11 okt", timing: .weekend, urenGeleden: 8,
             beschrijving: "Twaalf dozen van de gang naar de zolder, vaste trap aanwezig.",
             eigenaar: "Lotte", geplaatst: "vandaag"),
        Klus(id: "8", titel: "Dakgoot leeghalen", soort: .reparatie, afstand: "2,6 km", afstandMeters: 2600, vergoeding: 35,
             wanneer: "Deze week", timing: .dezeWeek, urenGeleden: 6, afvalWordtAfgevoerd: true,
             beschrijving: "Goot aan de achterkant zit vol bladeren, ladder staat klaar.",
             eigenaar: "Henk", geplaatst: "vandaag"),
        Klus(id: "9", titel: "Wasmachine aansluiten", soort: .reparatie, afstand: "3,1 km", afstandMeters: 3100, vergoeding: 30,
             wanneer: "Ma 12 okt", timing: .dezeWeek, urenGeleden: 26, gereedschapAanwezig: true,
             beschrijving: "Nieuwe wasmachine staat er al, alleen aansluiten op kraan en afvoer.",
             eigenaar: "Daan", geplaatst: "gisteren"),
        Klus(id: "10", titel: "Schutting beitsen", soort: .tuin, afstand: "3,4 km", afstandMeters: 3400, vergoeding: 60,
             wanneer: "Za 17 okt", timing: .weekend, duur: .halveDag, urenGeleden: 30, gereedschapAanwezig: true,
             beschrijving: "Schutting van 10 meter, beits en kwasten zijn al gekocht.",
             eigenaar: "Marloes", geplaatst: "gisteren"),
        Klus(id: "11", titel: "Slaapkamer schilderen", soort: .binnen, afstand: "4,8 km", afstandMeters: 4800, vergoeding: 120,
             duur: .heleDag, urenGeleden: 48, gereedschapAanwezig: true,
             beschrijving: "Muren en plafond, ongeveer 14 m². Verf is in huis.",
             eigenaar: "Bram", geplaatst: "2 dagen geleden"),
        Klus(id: "12", titel: "Coniferen kappen", soort: .tuin, afstand: "7,5 km", afstandMeters: 7500, vergoeding: 140,
             wanneer: "Za 24 okt", timing: .weekend, duur: .heleDag, urenGeleden: 96, afvalWordtAfgevoerd: true,
             beschrijving: "Vier coniferen van zo'n 3 meter, het snoeiafval wordt opgehaald.",
             eigenaar: "Yvonne", geplaatst: "4 dagen geleden"),
    ]

    private static func foto(_ seeds: String...) -> [URL] {
        seeds.map { URL(string: "https://picsum.photos/seed/\($0)/1200/800")! }
    }
}
