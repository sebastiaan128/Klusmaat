//
//  KlusFilters.swift
//  Klusmaat
//
//  Models/ bevat de datamodellen van de app. KlusFilters zijn de zoekfilters van het startscherm en de filtersheet,
//  gelijk aan JobSearch op Android.
//

import Foundation

enum KlusSortering: String, CaseIterable, Identifiable {
    case nieuwste = "Nieuwste"
    case dichtstbij = "Dichtstbij"
    case hoogsteVergoeding = "Hoogste vergoeding"

    var id: Self { self }

    func sorteer(_ klussen: [Klus]) -> [Klus] {
        switch self {
        case .nieuwste: klussen.sorted { $0.urenGeleden < $1.urenGeleden }
        case .dichtstbij: klussen.sorted { $0.afstandMeters < $1.afstandMeters }
        case .hoogsteVergoeding: klussen.sorted { $0.vergoeding > $1.vergoeding }
        }
    }
}

struct KlusFilters: Equatable {
    var soort: KlusSoort?
    var postcode = ""
    /// nil betekent overal
    var straalKm: Int? = 10
    var minVergoeding: Int?
    var maxVergoeding: Int?
    var timing: KlusTiming?
    var duren: Set<KlusDuur> = []
    var gereedschapAanwezig = false
    var afvalWordtAfgevoerd = false

    static let stralen: [Int?] = [1, 2, 5, 10, nil]
    static let minimaleVergoedingen = [10, 25, 50]

    var titel: String { soort?.rawValue ?? "Alle soorten" }

    var locatieLabel: String {
        let plaats = postcode.trimmingCharacters(in: .whitespaces).uppercased()
        return "\(plaats.isEmpty ? "Jouw buurt" : plaats) · \(straalKm.map { "\($0) km" } ?? "overal")"
    }

    /// Aantal filters uit de filtersheet, voor het bolletje op de filterknop.
    var aantalVerfijningen: Int {
        [minVergoeding != nil, maxVergoeding != nil, timing != nil, gereedschapAanwezig, afvalWordtAfgevoerd]
            .filter { $0 }.count + duren.count
    }

    /// Laat de zoekopdracht van het startscherm staan en wist alleen de filters uit de sheet.
    func zonderVerfijningen() -> KlusFilters {
        KlusFilters(soort: soort, postcode: postcode, straalKm: straalKm)
    }

    func past(_ klus: Klus) -> Bool {
        (soort == nil || klus.soort == soort)
            && (straalKm.map { klus.afstandMeters <= $0 * 1000 } ?? true)
            && (minVergoeding.map { klus.vergoeding >= $0 } ?? true)
            && (maxVergoeding.map { klus.vergoeding <= $0 } ?? true)
            && (timing.map { klus.timing == $0 } ?? true)
            && (duren.isEmpty || duren.contains(klus.duur))
            && (!gereedschapAanwezig || klus.gereedschapAanwezig)
            && (!afvalWordtAfgevoerd || klus.afvalWordtAfgevoerd)
    }
}

extension Array where Element == Klus {
    func passend(bij filters: KlusFilters) -> [Klus] {
        filter(filters.past)
    }
}

/// "12 klussen", "1 tuinklus", "3 reparaties", zoals jobCountLabel op Android.
func klussenLabel(_ aantal: Int, soort: KlusSoort?) -> String {
    switch soort {
    case .tuin: aantal == 1 ? "1 tuinklus" : "\(aantal) tuinklussen"
    case .binnen: aantal == 1 ? "1 klus binnen" : "\(aantal) klussen binnen"
    case .reparatie: aantal == 1 ? "1 reparatie" : "\(aantal) reparaties"
    case nil: aantal == 1 ? "1 klus" : "\(aantal) klussen"
    }
}
