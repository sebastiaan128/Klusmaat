//
//  MijnKlussenView.swift
//  Klusmaat
//
//  Feature Klussen: overzicht van de klussen die de gebruiker zelf heeft geplaatst.
//  Draait nog op voorbeelddata (onderaan dit bestand); later komt hier een Firestore-query op jobs met ownerId.
//

import SwiftUI

struct MijnKlussenView: View {
    @State private var filter: MijnKlussenFilter = .actief

    private var zichtbareKlussen: [MijnKlus] {
        MijnKlus.voorbeelden.filter { filter.bevat($0.status) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Picker("Filter", selection: $filter) {
                        ForEach(MijnKlussenFilter.allCases, id: \.self) { filter in
                            Text(filter.titel).tag(filter)
                        }
                    }
                    .pickerStyle(.segmented)

                    if zichtbareKlussen.isEmpty {
                        ContentUnavailableView(
                            "Geen klussen",
                            systemImage: "doc.text",
                            description: Text("Klussen die je plaatst, zie je hier terug.")
                        )
                        .padding(.top, 40)
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(zichtbareKlussen) { klus in
                                MijnKlusKaart(klus: klus)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Mijn klussen")
            .animation(.snappy, value: filter)
        }
    }
}

private struct MijnKlusKaart: View {
    let klus: MijnKlus

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 14) {
                Image(systemName: klus.categorie.icoon)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(klus.categorie.kleur, in: .rect(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 3) {
                    Text(klus.titel)
                        .font(.headline)
                    Text("\(klus.categorie.titel) · geplaatst \(klus.geplaatstOp.formatted(.relative(presentation: .named).locale(Locale(identifier: "nl_NL"))))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 0)

                if let vergoeding = klus.vergoeding {
                    Text(vergoeding, format: .currency(code: "EUR").precision(.fractionLength(0)).locale(Locale(identifier: "nl_NL")))
                        .font(.subheadline.weight(.semibold))
                }
            }

            Divider()

            HStack {
                StatusLabel(status: klus.status)
                Spacer()
                Text(klus.status.toelichting)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .background(.background, in: .rect(cornerRadius: 20))
    }
}

private struct StatusLabel: View {
    let status: MijnKlusStatus

    var body: some View {
        Text(status.titel)
            .font(.caption.weight(.semibold))
            .foregroundStyle(status.kleur)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(status.kleur.opacity(0.12), in: .capsule)
    }
}

// MARK: - Model

enum MijnKlussenFilter: CaseIterable {
    case actief
    case afgerond

    var titel: String {
        switch self {
        case .actief: "Actief"
        case .afgerond: "Afgerond"
        }
    }

    func bevat(_ status: MijnKlusStatus) -> Bool {
        switch self {
        case .actief: status != .afgerond
        case .afgerond: status == .afgerond
        }
    }
}

enum MijnKlusStatus: Equatable {
    case open(reacties: Int)
    case gepland(helper: String, op: String)
    case afgerond

    var titel: String {
        switch self {
        case .open: "Open"
        case .gepland: "Gepland"
        case .afgerond: "Afgerond"
        }
    }

    var toelichting: String {
        switch self {
        case .open(let reacties):
            switch reacties {
            case 0: "Nog geen reacties"
            case 1: "1 reactie"
            default: "\(reacties) reacties"
            }
        case .gepland(let helper, let op): "\(helper) · \(op)"
        case .afgerond: "Klaar"
        }
    }

    var kleur: Color {
        switch self {
        case .open: .klusGroen
        case .gepland: .blue
        case .afgerond: .secondary
        }
    }
}

enum KlusCategorie {
    case tuin, klussen, verhuizen, schilderen

    var titel: String {
        switch self {
        case .tuin: "Tuin"
        case .klussen: "Klussen in huis"
        case .verhuizen: "Verhuizen"
        case .schilderen: "Schilderen"
        }
    }

    var icoon: String {
        switch self {
        case .tuin: "leaf.fill"
        case .klussen: "hammer.fill"
        case .verhuizen: "shippingbox.fill"
        case .schilderen: "paintbrush.fill"
        }
    }

    var kleur: Color {
        switch self {
        case .tuin: .klusGroen
        case .klussen: .klusOranje
        case .verhuizen: .blue
        case .schilderen: .purple
        }
    }
}

struct MijnKlus: Identifiable {
    let id: String
    let titel: String
    let categorie: KlusCategorie
    let status: MijnKlusStatus
    let geplaatstOp: Date
    let vergoeding: Int?
}

// MARK: - Voorbeelddata

extension MijnKlus {
    static let voorbeelden: [MijnKlus] = [
        MijnKlus(id: "1", titel: "Heg snoeien in de voortuin", categorie: .tuin,
                 status: .open(reacties: 3), geplaatstOp: .now.addingTimeInterval(-2 * 86_400), vergoeding: 25),
        MijnKlus(id: "2", titel: "Kast ophangen in de woonkamer", categorie: .klussen,
                 status: .gepland(helper: "Ahmed", op: "za 2 nov"), geplaatstOp: .now.addingTimeInterval(-5 * 86_400), vergoeding: 20),
        MijnKlus(id: "3", titel: "Hulp bij verhuizen naar Lombok", categorie: .verhuizen,
                 status: .open(reacties: 0), geplaatstOp: .now.addingTimeInterval(-3 * 3_600), vergoeding: 40),
        MijnKlus(id: "4", titel: "Lamp vervangen in de gang", categorie: .klussen,
                 status: .open(reacties: 1), geplaatstOp: .now.addingTimeInterval(-26 * 3_600), vergoeding: nil),
        MijnKlus(id: "5", titel: "Schuur schilderen", categorie: .schilderen,
                 status: .afgerond, geplaatstOp: .now.addingTimeInterval(-21 * 86_400), vergoeding: 60),
        MijnKlus(id: "6", titel: "Bladeren ruimen", categorie: .tuin,
                 status: .afgerond, geplaatstOp: .now.addingTimeInterval(-35 * 86_400), vergoeding: 15),
    ]
}

#Preview {
    MijnKlussenView()
}
