import Foundation

final class JobService {
    static let sampleJobs: [Job] = [
        Job(id: "1", title: "Heg snoeien in de voortuin", category: .garden, distance: "400 m", distanceMeters: 400, pay: 40,
             dateLabel: "Za 10 okt", timing: .weekend, duration: .halfDay, hoursAgo: 2,
             photos: photo("klusmaat-1-1", "klusmaat-1-2", "klusmaat-1-3"), toolsProvided: true,
             description: "Ongeveer 6 meter heg langs de stoep, gereedschap is aanwezig. "
                 + "De heg is al een paar jaar niet goed bijgehouden, dus hij is aan de bovenkant flink "
                 + "uitgegroeid. Het groenafval mag in de container achter het huis. Koffie en "
                 + "appeltaart staan klaar, en als het uitkomt kun je ook meteen even naar de "
                 + "klimop aan de zijgevel kijken.",
             summary: "6 meter heg bijknippen, gereedschap ligt klaar.",
             owner: "Anouk", postedAgo: "2 uur geleden"),
        Job(id: "2", title: "Kast in elkaar zetten", category: .assembly, distance: "1,2 km", distanceMeters: 1200, pay: 35,
             dateLabel: "Di 13 okt", timing: .thisWeek, duration: .halfDay, hoursAgo: 20,
             photos: photo("klusmaat-2-1"),
             description: "IKEA Pax, handleiding kwijt. Twee linkerhanden hier.",
             summary: "IKEA Pax-kast in elkaar zetten zonder handleiding.",
             owner: "Samir", postedAgo: "gisteren"),
        Job(id: "3", title: "Lekkende kraan in de keuken", category: .repair, distance: "800 m", distanceMeters: 800, pay: 25,
             dateLabel: "Deze week", timing: .thisWeek, hoursAgo: 5,
             photos: photo("klusmaat-3-1", "klusmaat-3-2"), toolsProvided: true,
             description: "Druppelt al een week, nieuwe leertjes liggen klaar. Ik heb zelf al "
                 + "geprobeerd de kraan open te draaien maar de moer zit muurvast. Waarschijnlijk "
                 + "moet de hoofdkraan even dicht, die zit in de meterkast. Liefst deze week nog, "
                 + "want de waterrekening loopt op.",
             summary: "Kraanleertjes vervangen, nieuwe leertjes liggen klaar.",
             owner: "Ria", postedAgo: "vandaag"),
        Job(id: "4", title: "Gras maaien en onkruid wieden", category: .garden, distance: "1,5 km", distanceMeters: 1500, pay: 30,
             dateLabel: "In het weekend", timing: .weekend, hoursAgo: 72, toolsProvided: true,
             description: "Achtertuin van zo'n 30 m², maaier staat in de schuur.",
             summary: "30 m² gras maaien en onkruid wieden.",
             owner: "Joost", postedAgo: "3 dagen geleden"),
        Job(id: "5", title: "Schilderij en planken ophangen", category: .indoor, distance: "2,0 km", distanceMeters: 2000, pay: 20,
             hoursAgo: 22,
             description: "Drie planken en een grote spiegel, boor heb ik niet.",
             summary: "3 planken en een spiegel ophangen, neem een boor mee.",
             owner: "Fatima", postedAgo: "gisteren"),
        Job(id: "6", title: "Fietsband plakken", category: .repair, distance: "600 m", distanceMeters: 600, pay: 15,
             dateLabel: "Voor vrijdag", timing: .thisWeek, hoursAgo: 1,
             photos: photo("klusmaat-6-1"),
             description: "Achterband is lek, liefst voor het weekend.",
             summary: "Lekke achterband van een fiets plakken.",
             owner: "Kees", postedAgo: "1 uur geleden"),
        Job(id: "7", title: "Verhuisdozen naar de zolder", category: .pickup, distance: "900 m", distanceMeters: 900, pay: 25,
             dateLabel: "Zo 11 okt", timing: .weekend, hoursAgo: 8,
             description: "Twaalf dozen van de gang naar de zolder, vaste trap aanwezig.",
             summary: "12 verhuisdozen naar zolder sjouwen.",
             owner: "Lotte", postedAgo: "vandaag"),
        Job(id: "8", title: "Dakgoot leeghalen", category: .repair, distance: "2,6 km", distanceMeters: 2600, pay: 35,
             dateLabel: "Deze week", timing: .thisWeek, hoursAgo: 6, wasteRemoved: true,
             description: "Goot aan de achterkant zit vol bladeren, ladder staat klaar.",
             summary: "Bladeren uit de dakgoot halen, ladder staat klaar.",
             owner: "Henk", postedAgo: "vandaag"),
        Job(id: "9", title: "Wasmachine aansluiten", category: .repair, distance: "3,1 km", distanceMeters: 3100, pay: 30,
             dateLabel: "Ma 12 okt", timing: .thisWeek, hoursAgo: 26, toolsProvided: true,
             description: "Nieuwe wasmachine staat er al, alleen aansluiten op kraan en afvoer.",
             summary: "Nieuwe wasmachine aansluiten op kraan en afvoer.",
             owner: "Daan", postedAgo: "gisteren"),
        Job(id: "10", title: "Schutting beitsen", category: .painting, distance: "3,4 km", distanceMeters: 3400, pay: 60,
             dateLabel: "Za 17 okt", timing: .weekend, duration: .halfDay, hoursAgo: 30, toolsProvided: true,
             description: "Schutting van 10 meter, beits en kwasten zijn al gekocht.",
             summary: "10 meter schutting beitsen, spullen zijn gekocht.",
             owner: "Marloes", postedAgo: "gisteren"),
        Job(id: "11", title: "Slaapkamer schilderen", category: .painting, distance: "4,8 km", distanceMeters: 4800, pay: 120,
             duration: .fullDay, hoursAgo: 48, toolsProvided: true,
             description: "Muren en plafond, ongeveer 14 m². Verf is in huis.",
             summary: "Muren en plafond verven (14 m²), verf is er.",
             owner: "Bram", postedAgo: "2 dagen geleden"),
        Job(id: "12", title: "Coniferen kappen", category: .garden, distance: "7,5 km", distanceMeters: 7500, pay: 140,
             dateLabel: "Za 24 okt", timing: .weekend, duration: .fullDay, hoursAgo: 96, wasteRemoved: true,
             description: "Vier coniferen van zo'n 3 meter, het snoeiafval wordt opgehaald.",
             summary: "4 coniferen van 3 meter kappen.",
             owner: "Yvonne", postedAgo: "4 dagen geleden"),
    ]

    private static func photo(_ seeds: String...) -> [URL] {
        seeds.map { URL(string: "https://picsum.photos/seed/\($0)/1200/800")! }
    }
}
