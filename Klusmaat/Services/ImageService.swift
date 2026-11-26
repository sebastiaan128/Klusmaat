import ImageIO
import UIKit

actor ImageService {
    static let shared = ImageService()

    private nonisolated let memoryCache = ImageMemoryCache()
    private let session: URLSession

    private struct Download {
        let id: UUID
        let task: Task<UIImage?, Never>
        var subscribers: Set<UUID>
    }
    private var inFlight: [ImageRequest: Download] = [:]

    init(session: URLSession? = nil) {
        if let session {
            self.session = session
        } else {
            let configuration = URLSessionConfiguration.default
            configuration.urlCache = URLCache(memoryCapacity: 20_000_000, diskCapacity: 200_000_000)
            configuration.requestCachePolicy = .returnCacheDataElseLoad
            configuration.httpMaximumConnectionsPerHost = 4
            configuration.timeoutIntervalForRequest = 30
            self.session = URLSession(configuration: configuration)
        }
    }

    nonisolated func cachedImage(_ request: ImageRequest) -> UIImage? {
        memoryCache.image(for: request)
    }

    func image(_ request: ImageRequest) async -> UIImage? {
        guard !Task.isCancelled else { return nil }
        if let image = cachedImage(request) { return image }

        let subscriber = UUID()
        let download: Download
        if var existing = inFlight[request] {
            existing.subscribers.insert(subscriber)
            inFlight[request] = existing
            download = existing
        } else {
            let session = session
            let task = Task.detached(priority: .userInitiated) { () -> UIImage? in
                guard let (data, response) = try? await session.data(from: request.url),
                      let response = response as? HTTPURLResponse,
                      (200..<300).contains(response.statusCode), !Task.isCancelled
                else { return nil }
                return Self.downscaled(data, maxPixels: request.maxPixels)
            }
            download = Download(id: UUID(), task: task, subscribers: [subscriber])
            inFlight[request] = download
        }

        return await withTaskCancellationHandler {
            let image = await download.task.value
            guard !Task.isCancelled else { return nil }
            if inFlight[request]?.id == download.id {
                inFlight[request] = nil
                if let image {
                    memoryCache.store(image, for: request)
                }
            }
            return image
        } onCancel: {
            Task { await self.cancel(request, subscriber: subscriber, downloadID: download.id) }
        }
    }

    private func cancel(_ request: ImageRequest, subscriber: UUID, downloadID: UUID) {
        guard var download = inFlight[request], download.id == downloadID else { return }
        download.subscribers.remove(subscriber)
        if download.subscribers.isEmpty {
            inFlight[request] = nil
            download.task.cancel()
        } else {
            inFlight[request] = download
        }
    }

    private nonisolated static func downscaled(_ data: Data, maxPixels: Int) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, [kCGImageSourceShouldCache: false] as CFDictionary)
        else { return nil }
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixels,
        ]
        guard let image = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else { return nil }
        return UIImage(cgImage: image)
    }
}

private nonisolated final class ImageMemoryCache: @unchecked Sendable {
    private let cache: NSCache<NSString, UIImage>

    init() {
        cache = NSCache<NSString, UIImage>()
        cache.totalCostLimit = 32 * 1024 * 1024
        cache.countLimit = 150
    }

    func image(for request: ImageRequest) -> UIImage? {
        cache.object(forKey: request.cacheKey)
    }

    func store(_ image: UIImage, for request: ImageRequest) {
        let cost = image.cgImage.map { $0.bytesPerRow * $0.height } ?? 0
        cache.setObject(image, forKey: request.cacheKey, cost: cost)
    }
}
