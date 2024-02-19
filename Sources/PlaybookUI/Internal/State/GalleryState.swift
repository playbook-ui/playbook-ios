import SwiftUI

@MainActor
internal final class GalleryState: ObservableObject {
    @Published
    var selected: SelectData?
    @Published
    var colorScheme: ColorScheme?

    func clearImageCache() {
        let imageCache = ImageCache()
        imageCache.clear()
    }
}
