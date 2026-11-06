//
//  AppTab.swift
//  Klusmaat
//
//  De tabs in de tabbalk. Plaatsen is de losse "+"-knop rechts; die opent een sheet in plaats van een tab.
//

enum AppTab: Hashable, CaseIterable {
    case zoeken
    case overzicht
    case reacties
    case profiel
    case plaatsen

    var titel: String {
        switch self {
        case .zoeken: "Zoeken"
        case .overzicht: "Overzicht"
        case .reacties: "Reacties"
        case .profiel: "Profiel"
        case .plaatsen: "Plaatsen"
        }
    }

    var icoon: String {
        switch self {
        case .zoeken: "magnifyingglass"
        case .overzicht: "doc.text"
        case .reacties: "bubble.left"
        case .profiel: "person"
        case .plaatsen: "plus"
        }
    }
}
