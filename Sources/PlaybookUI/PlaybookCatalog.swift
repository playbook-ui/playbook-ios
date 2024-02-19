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
    @Environment(\.horizontalSizeClass)
    private var horizontalSizeClass
    @Environment(\.verticalSizeClass)
    private var verticalSizeClass

    public init(
        title: String? = nil,
        playbook: Playbook = .default
    ) {
        self.title = title
        self._searchState = StateObject(wrappedValue: SearchState(playbook: playbook))
    }

    public var body: some View {
        Group {
            switch (horizontalSizeClass, verticalSizeClass) {
            case (.regular, .regular):
                CatalogSplit()

            default:
                CatalogDrawer()
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            CatalogBottomBar(
                title: title,
                primaryItemSymbol: primaryBarItemSymbol
            )
        }
        .ignoresSafeArea(.keyboard)
        .preferredColorScheme(catalogState.colorScheme)
        .environmentObject(searchState)
        .environmentObject(catalogState)
        .environmentObject(shareState)
        .onAppear {
            catalogState.selectInitial(searchResult: searchState.result)
        }
    }
}

@available(iOS 15.0, *)
private extension PlaybookCatalog {
    var primaryBarItemSymbol: Image.SFSymbols {
        switch (horizontalSizeClass, verticalSizeClass) {
        case (.regular, .regular):
            return .sidebarLeft

        default:
            return .magnifyingglass
        }
    }
}
