import Foundation

enum KlusSoort: String, CaseIterable, Identifiable {
    case tuin = "Tuin"
    case binnen = "Binnen"
    case reparatie = "Reparatie"

    var id: Self { self }

    var icoon: String {
        switch self {
        case .tuin: "leaf"
        case .binnen: "house"
        case .reparatie: "wrench.and.screwdriver"
        }
    }
}

enum KlusTiming: String, CaseIterable, Identifiable {
    case dezeWeek = "Deze week"
    case weekend = "Weekend"
    case flexibel = "Datum flexibel"

    var id: Self { self }
}

enum KlusDuur: String, CaseIterable, Identifiable {
    case kort = "< 2 uur"
    case halveDag = "Halve dag"
    case heleDag = "Hele dag"

    var id: Self { self }
}

struct Klus: Identifiable {
    let id: String
    let titel: String
    let soort: KlusSoort
    let afstand: String
    let afstandMeters: Int
    let vergoeding: Int
    var wanneer = KlusTiming.flexibel.rawValue
    var timing = KlusTiming.flexibel
    var duur = KlusDuur.kort
    let urenGeleden: Int
    var fotos: [URL] = []
    var gereedschapAanwezig = false
    var afvalWordtAfgevoerd = false
    let beschrijving: String
    let eigenaar: String
    let geplaatst: String

    var isNieuw: Bool { urenGeleden < 12 }
}
