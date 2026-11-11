
import SwiftUI

extension Color {
    static let background = Color(hex: "F2F2F7")

    static let softText = Color(hex: "6B5E54")

    static let greenPrimary = Color(hex: "0C5F50")
    
    static let border = Color(hex: "dfd2c4")
    
    static let greenBackground = Color(hex: "bcd4a7")
    
    static let errorRed = Color(hex: "#b42318")
    
    static let inputBackground = Color(hex: "F9FAFB")
}

// hiermee zet je rgb om naar hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(
            in: CharacterSet.alphanumerics.inverted
        )
        let value = UInt64(hex, radix: 16) ?? 0

        self.init(
            .sRGB,
            red: Double((value >> 16) & 0xFF) / 255,
            green: Double((value >> 8) & 0xFF) / 255,
            blue: Double(value & 0xFF) / 255,
            opacity: 1
        )
    }
}
