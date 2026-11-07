//
//  KlusAfbeelding.swift
//  Klusmaat
//
//  Foto van internet via AfbeeldingService: verkleind tot de grootte op het scherm en bewaard, in plaats van
//  AsyncImage, die elke keer opnieuw de hele foto downloadt en decodeert.
//

import SwiftUI

struct KlusAfbeelding<Plaatshouder: View>: View {
    let url: URL
    /// Langste zijde waarop de foto getoond wordt, in punten
    let maxPunten: CGFloat
    @ViewBuilder var plaatshouder: Plaatshouder

    @Environment(\.displayScale) private var schaal
    @State private var geladen: UIImage?

    private var maxPixels: Int { Int(maxPunten * schaal) }

    var body: some View {
        // Uit het geheugen meteen tonen, zodat een foto bij terugscrollen niet even knippert
        if let afbeelding = geladen ?? AfbeeldingService.gedeeld.uitGeheugen(url, maxPixels: maxPixels) {
            Image(uiImage: afbeelding)
                .resizable()
                .scaledToFill()
        } else {
            plaatshouder
                .task(id: url) {
                    geladen = await AfbeeldingService.gedeeld.afbeelding(url, maxPixels: maxPixels)
                }
        }
    }
}
