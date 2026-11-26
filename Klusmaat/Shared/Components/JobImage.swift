import SwiftUI

struct JobImage<Placeholder: View>: View {
    let url: URL
    let maxPoints: CGFloat
    @ViewBuilder var placeholder: Placeholder

    @Environment(\.displayScale) private var scale
    @State private var loaded: (request: ImageRequest, image: UIImage)?

    private var request: ImageRequest {
        ImageRequest(url: url, maxPixels: Int(maxPoints * scale))
    }

    var body: some View {
        let request = request
        Group {
            if let image = (loaded?.request == request ? loaded?.image : nil)
                ?? ImageService.shared.cachedImage(request) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                placeholder
            }
        }
        .task(id: request) {
            guard loaded?.request != request else { return }
            let image = await ImageService.shared.image(request)
            guard !Task.isCancelled, let image else { return }
            loaded = (request, image)
        }
    }
}
