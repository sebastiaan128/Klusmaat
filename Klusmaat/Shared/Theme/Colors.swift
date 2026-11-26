import SwiftUI

extension Color {
    static let coffee = Color(hex: 0x6E5646)
    static let brandGreen = Color(hex: 0x0C5F50)
    static let brandGreenDark = Color(hex: 0x094B40)
    static let accentOrange = Color(hex: 0xD9692B)
    static let sage = Color(hex: 0xBCD4A7)
    static let sand = Color(hex: 0xDFD2C4)
    static let linen = Color(hex: 0xEEE7E0)
    static let oat = Color(hex: 0xF0E8E0)
    static let cream = Color(hex: 0xF8F5F1)
    static let paper = Color(hex: 0xFBFAF8)
    static let textPrimary = Color(hex: 0x231A14)
    static let textSecondary = Color(hex: 0x6B5E54)

    init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }
}
