//
//  Lettertypen.swift
//  Klusmaat
//
//  Lettertypen van de app, overgenomen uit klusmaat-android (ui/theme/Type.kt):
//  Gugi voor het logo, Lexend voor titels en Open Sans voor lopende tekst.
//

import CoreText
import SwiftUI

enum Lettertypen {
    /// Registreert de meegeleverde fonts in Resources/Fonts, zodat er geen UIAppFonts-entry in de Info.plist nodig is.
    static func registreer() {
        let urls = Bundle.main.urls(forResourcesWithExtension: "ttf", subdirectory: nil) ?? []
        for url in urls {
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }
}

extension Font {
    static func logo(_ size: CGFloat) -> Font {
        .custom("Gugi", size: size)
    }

    static func titel(_ size: CGFloat, weight: Font.Weight = .semibold, relativeTo style: Font.TextStyle = .title) -> Font {
        .custom("Lexend", size: size, relativeTo: style).weight(weight)
    }

    static func tekst(_ size: CGFloat, weight: Font.Weight = .regular, relativeTo style: Font.TextStyle = .body) -> Font {
        .custom("Open Sans", size: size, relativeTo: style).weight(weight)
    }
}
