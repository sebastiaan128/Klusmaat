import Foundation
import UIKit

nonisolated private final class Fixture: @unchecked Sendable {
    static let shared = Fixture()
    private let lock = NSLock()
    private var responseData = Data()
    private var responseStatus = 200
    private var started = 0
    private var stopped = 0

    func reset(data: Data, status: Int = 200) {
        lock.withLock {
            responseData = data; responseStatus = status; started = 0; stopped = 0
        }
    }
    func begin() -> (Data, Int) {
        lock.withLock { started += 1; return (responseData, responseStatus) }
    }
    func stop() { lock.withLock { stopped += 1 } }
    var counts: (started: Int, stopped: Int) { lock.withLock { (started, stopped) } }
}

nonisolated private final class FixtureProtocol: URLProtocol, @unchecked Sendable {
    private let lock = NSLock()
    private var stopped = false

    override class func canInit(with request: URLRequest) -> Bool { request.url?.host == "fixture.invalid" }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        let (data, status) = Fixture.shared.begin()
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) {
            self.lock.withLock {
                guard !self.stopped else { return }
                let response = HTTPURLResponse(url: self.request.url!, statusCode: status, httpVersion: nil, headerFields: nil)!
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                self.client?.urlProtocol(self, didLoad: data)
                self.client?.urlProtocolDidFinishLoading(self)
            }
        }
    }

    override func stopLoading() {
        lock.withLock { stopped = true }
        Fixture.shared.stop()
    }
}

@main
struct ImagePipelineChecks {
    @MainActor static func main() async throws {
        let original = URL(string: "https://picsum.photos/seed/test/1200/800?grayscale")!
        let thumbnail = ImageRequest(url: original, maxPixels: 330)
        precondition(thumbnail.url.absoluteString == "https://picsum.photos/seed/test/384/256?grayscale")
        precondition(ImageRequest(url: original, maxPixels: 3000).url == original)
        let external = URL(string: "https://example.invalid/original.jpg?token=example")!
        precondition(ImageRequest(url: external, maxPixels: 330).url == external)
        precondition(ImageRequest(url: original, maxPixels: 329) == thumbnail)
        print("PASS: thumbnail sizing, buckets, original URLs and query preservation")

        let data = UIGraphicsImageRenderer(size: CGSize(width: 1200, height: 800)).image { context in
            UIColor.systemGreen.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 1200, height: 800))
        }.jpegData(compressionQuality: 0.8)!
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [FixtureProtocol.self]
        let service = ImageService(session: URLSession(configuration: configuration))
        let request = ImageRequest(url: URL(string: "https://fixture.invalid/shared.jpg")!, maxPixels: 330)
        Fixture.shared.reset(data: data)
        let first = Task { await service.image(request) }
        let second = Task { await service.image(request) }
        try await waitForStart()
        try await Task.sleep(for: .milliseconds(50))
        first.cancel()
        let secondImage = await second.value
        let firstImage = await first.value
        precondition(firstImage == nil && secondImage != nil)
        precondition(Fixture.shared.counts.started == 1)
        precondition(secondImage!.cgImage!.width == 384)
        print("PASS: shared download survives one consumer cancelling; image decoded at thumbnail size")
        let cached = await service.image(request)
        precondition(cached != nil && Fixture.shared.counts.started == 1)
        print("PASS: repeat requests use memory cache")

        Fixture.shared.reset(data: data)
        let cancelRequest = ImageRequest(url: URL(string: "https://fixture.invalid/cancel.jpg")!, maxPixels: 330)
        let cancelled = Task { await service.image(cancelRequest) }
        try await waitForStart()
        cancelled.cancel()
        let cancelledImage = await cancelled.value
        precondition(cancelledImage == nil)
        for _ in 0..<200 {
            if Fixture.shared.counts.stopped > 0 { break }
            try await Task.sleep(for: .milliseconds(10))
        }
        precondition(Fixture.shared.counts.stopped > 0, "Cancellation did not stop URLSession")
        let replacement = await service.image(cancelRequest)
        precondition(replacement != nil && Fixture.shared.counts.started == 2)
        print("PASS: last cancellation stops network; a new subscriber can retry")

        Fixture.shared.reset(data: data, status: 500)
        let errorRequest = ImageRequest(url: URL(string: "https://fixture.invalid/error.jpg")!, maxPixels: 330)
        let errorImage = await service.image(errorRequest)
        precondition(errorImage == nil)
        Fixture.shared.reset(data: data)
        let retry = await service.image(errorRequest)
        precondition(retry != nil && Fixture.shared.counts.started == 1)
        print("PASS: HTTP errors are not cached and can be retried")

        Fixture.shared.reset(data: Data("invalid image".utf8))
        let invalid = await service.image(ImageRequest(url: URL(string: "https://fixture.invalid/invalid.jpg")!, maxPixels: 330))
        precondition(invalid == nil)
        print("PASS: invalid image data is rejected")
        print("All 6 image-pipeline checks passed.")
    }

    @MainActor private static func waitForStart() async throws {
        for _ in 0..<200 {
            if Fixture.shared.counts.started > 0 { return }
            try await Task.sleep(for: .milliseconds(10))
        }
        preconditionFailure("Fixture request did not start within two seconds")
    }
}
