import Foundation

nonisolated struct ImageRequest: Hashable, Sendable {
    let url: URL
    let maxPixels: Int

    nonisolated init(url: URL, maxPixels: Int) {
        let pixels = max(1, maxPixels)
        let bucket = [256, 384, 512, 768, 1024, 1200, 1600, 2048].first { $0 >= pixels } ?? pixels
        self.maxPixels = bucket
        self.url = Self.resizedURL(url, maxPixels: bucket)
    }

    private nonisolated static func resizedURL(_ url: URL, maxPixels: Int) -> URL {
        guard url.host == "picsum.photos", var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else { return url }
        var parts = components.path.split(separator: "/").map(String.init)
        guard parts.count == 4, parts[0] == "seed",
              let width = Int(parts[2]), let height = Int(parts[3]), width > 0, height > 0
        else { return url }
        let ratio = min(1, Double(maxPixels) / Double(max(width, height)))
        parts[2] = String(max(1, Int((Double(width) * ratio).rounded())))
        parts[3] = String(max(1, Int((Double(height) * ratio).rounded())))
        components.path = "/" + parts.joined(separator: "/")
        return components.url ?? url
    }

    nonisolated var cacheKey: NSString { "\(url.absoluteString)#\(maxPixels)" as NSString }
}
