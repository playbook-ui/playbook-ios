import Playbook
import SwiftUI

@available(iOS 15.0, *)
internal struct PlaybookCatalogContent: View {
    let title: String?

    @EnvironmentObject
    private var searchState: SearchState
    @EnvironmentObject
    private var catalogState: CatalogState
    @EnvironmentObject
    private var shareState: ShareState
    @Environment(\.horizontalSizeClass)
    private var horizontalSizeClass
    @Environment(\.verticalSizeClass)
    private var verticalSizeClass

    var body: some View {
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
        .onAppear {
            catalogState.selectInitial(searchResult: searchState.result)
        }
    }
}

@available(iOS 15.0, *)
private extension PlaybookCatalogContent {
    var primaryBarItemSymbol: Image.SFSymbols {
        switch (horizontalSizeClass, verticalSizeClass) {
        case (.regular, .regular):
            return .sidebarLeft

        default:
            return .magnifyingglass
        }
    }
}
