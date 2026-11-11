//claude gedaan

import ImageIO
import UIKit

actor AfbeeldingService {
    static let gedeeld = AfbeeldingService()

    /// Verkleinde foto's in het geheugen; NSCache ruimt zelf op als het geheugen krap wordt.
    private nonisolated let geheugen = NSCache<NSString, UIImage>()
    /// Originele downloads op schijf, zodat ze na een herstart niet opnieuw van internet hoeven.
    private let sessie: URLSession = {
        let configuratie = URLSessionConfiguration.default
        configuratie.urlCache = URLCache(memoryCapacity: 20_000_000, diskCapacity: 200_000_000)
        configuratie.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: configuratie)
    }()
    /// Lopende downloads, zodat twee views die dezelfde foto vragen maar één download starten.
    private var bezig: [NSString: Task<UIImage?, Never>] = [:]

    /// Direct uit het geheugen, zonder te wachten; nil als de foto er nog niet is.
    nonisolated func uitGeheugen(_ url: URL, maxPixels: Int) -> UIImage? {
        geheugen.object(forKey: Self.sleutel(url, maxPixels))
    }

    func afbeelding(_ url: URL, maxPixels: Int) async -> UIImage? {
        let sleutel = Self.sleutel(url, maxPixels)
        if let afbeelding = geheugen.object(forKey: sleutel) { return afbeelding }
        if let taak = bezig[sleutel] { return await taak.value }

        let sessie = sessie
        let taak = Task.detached(priority: .userInitiated) { () -> UIImage? in
            guard let (data, _) = try? await sessie.data(from: url) else { return nil }
            return Self.verklein(data, maxPixels: maxPixels)
        }
        bezig[sleutel] = taak
        let afbeelding = await taak.value
        bezig[sleutel] = nil
        if let afbeelding { geheugen.setObject(afbeelding, forKey: sleutel) }
        return afbeelding
    }

    private nonisolated static func sleutel(_ url: URL, _ maxPixels: Int) -> NSString {
        "\(url.absoluteString)#\(maxPixels)" as NSString
    }

    /// Decodeert de foto meteen op het gevraagde formaat, in plaats van eerst de hele foto in het geheugen te zetten.
    private nonisolated static func verklein(_ data: Data, maxPixels: Int) -> UIImage? {
        guard let bron = CGImageSourceCreateWithData(data as CFData, [kCGImageSourceShouldCache: false] as CFDictionary)
        else { return nil }
        let opties: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixels,
        ]
        guard let afbeelding = CGImageSourceCreateThumbnailAtIndex(bron, 0, opties as CFDictionary) else { return nil }
        return UIImage(cgImage: afbeelding)
    }
}
