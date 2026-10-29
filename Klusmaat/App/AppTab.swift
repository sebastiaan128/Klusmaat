//
//  AppTab.swift
//  Klusmaat
//
//  De tabs in de tabbalk. De "+"-knop om een klus te plaatsen is geen tab, die opent een sheet.
//

enum AppTab: Hashable, CaseIterable {
    case zoeken
    case mijnKlussen
    case reacties
    case profiel

    var titel: String {
        switch self {
        case .zoeken: "Zoeken"
        case .mijnKlussen: "Mijn klussen"
        case .reacties: "Reacties"
        case .profiel: "Profiel"
        }
    }

    var icoon: String {
        switch self {
        case .zoeken: "magnifyingglass"
        case .mijnKlussen: "doc.text"
        case .reacties: "bubble.left"
        case .profiel: "person"
        }
    }
}
