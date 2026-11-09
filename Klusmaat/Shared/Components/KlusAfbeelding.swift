import SwiftUI

struct KlusAfbeelding<Plaatshouder: View>: View {
    let url: URL
    let maxPunten: CGFloat
    @ViewBuilder var plaatshouder: Plaatshouder

    @Environment(\.displayScale) private var schaal
    @State private var geladen: UIImage?

    private var maxPixels: Int { Int(maxPunten * schaal) }

    var body: some View {
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
