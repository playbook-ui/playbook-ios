import Playbook
import SwiftUI

@available(iOS 15.0, *)
public struct PlaybookCatalog: View {
    private let title: String?

    @StateObject
    private var searchState: SearchState
    @StateObject
    private var catalogState = CatalogState()
    @StateObject
    private var shareState = ShareState()

    public init(
        title: String? = nil,
        playbook: Playbook = .default
    ) {
        self.title = title
        self._searchState = StateObject(wrappedValue: SearchState(playbook: playbook))
    }

    public var body: some View {
        PlaybookCatalogContent(title: title)
            .environmentObject(searchState)
            .environmentObject(catalogState)
            .environmentObject(shareState)
    }
}
