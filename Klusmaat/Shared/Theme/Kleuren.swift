//
//  Kleuren.swift
//  Klusmaat
//
//  Kleurenpalet van de app, overgenomen uit klusmaat-android (ui/theme/Color.kt).
//  Groen en accent zijn gelijk aan klusmaat-web (--kleur-primair, --kleur-primair-hover, --kleur-accent).
//

import SwiftUI

extension Color {
    static let coffee = Color(hex: 0x6E5646)
    static let pine = Color(hex: 0x0C5F50)
    static let pineDark = Color(hex: 0x094B40)
    static let sage = Color(hex: 0xBCD4A7)
    static let sand = Color(hex: 0xDFD2C4)
    static let linen = Color(hex: 0xEEE7E0)
    static let oat = Color(hex: 0xF0E8E0)
    static let cream = Color(hex: 0xF8F5F1)
    static let paper = Color(hex: 0xFBFAF8)
    static let tekstGedempt = Color(hex: 0x6B5E54)
    static let tekstPrimair = Color(hex: 0x231A14)
    static let beoordelingAchtergrond = Color(hex: 0xFFF4E3)

    // Profielscherm: lichtgrijze achtergrond met witte kaarten en een iets donkerder rand
    static let profielAchtergrond = Color(hex: 0xF2F2F3)
    static let kaartRand = Color(hex: 0xE2E2E5)

    // Rood voor destructieve acties (uitloggen)
    static let uitloggen = Color(hex: 0xED1C24)

    static let achtergrond = linen

    // Neutrale warme schaduw onder glasoppervlakken
    static let zachteSchaduw = Color(hex: 0x231A14, opacity: 0.2)

    init(hex: UInt32, opacity: Double = 1) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}
