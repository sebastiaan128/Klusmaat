//
//  AppTab.swift
//  Klusmaat
//
//  De tabs in de tabbalk. De "+"-knop om een klus te plaatsen is geen tab, die opent een sheet.
//

enum AppTab: Hashable, CaseIterable {
    case zoeken
    case overzicht
    case reacties
    case profiel

    var titel: String {
        switch self {
        case .zoeken: "Zoeken"
        case .overzicht: "Overzicht"
        case .reacties: "Reacties"
        case .profiel: "Profiel"
        }
    }

    var icoon: String {
        switch self {
        case .zoeken: "magnifyingglass"
        case .overzicht: "doc.text"
        case .reacties: "bubble.left"
        case .profiel: "person"
        }
    }
}
