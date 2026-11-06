//
//  Kleuren.swift
//  Klusmaat
//
//  Merkkleuren van de app, gelijk aan klusmaat-android (ui/theme/Color.kt) en klusmaat-web.
//

import SwiftUI

extension Color {
    static let klusKoffie = Color(hex: 0x6E5646)
    static let klusGroen = Color(hex: 0x0C5F50)
    static let klusGroenDonker = Color(hex: 0x094B40)
    /// Accentkleur, op web --kleur-accent
    static let klusSalie = Color(hex: 0xBCD4A7)
    static let klusZand = Color(hex: 0xDFD2C4)
    /// Achtergrond van de schermen
    static let klusLinnen = Color(hex: 0xEEE7E0)
    static let klusHaver = Color(hex: 0xF0E8E0)
    static let klusCreme = Color(hex: 0xF8F5F1)
    /// Kaarten en velden
    static let klusPapier = Color(hex: 0xFBFAF8)
    static let klusTekst = Color(hex: 0x231A14)
    static let klusTekstZacht = Color(hex: 0x6B5E54)

    init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }
}
