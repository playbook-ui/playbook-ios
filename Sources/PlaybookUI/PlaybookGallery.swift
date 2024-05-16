import Playbook
import SwiftUI

@available(iOS 15.0, *)
public struct PlaybookGallery: View {
    private let title: String?

    @StateObject
    private var searchState: SearchState
    @StateObject
    private var galleryState = GalleryState()
    @StateObject
    private var imageLoader = ImageLoader()

    public init(
        title: String? = nil,
        playbook: Playbook = .default
    ) {
        self.title = title
        self._searchState = StateObject(wrappedValue: SearchState(playbook: playbook))
    }

    public var body: some View {
        PlaybookGalleryContent(title: title)
            .environmentObject(searchState)
            .environmentObject(galleryState)
            .environmentObject(imageLoader)
    }
}
