import SwiftUI

internal struct CatalogDrawerStyle<Content: View>: View {
    var name: String
    var searchTree: ScenarioSearchTree
    var content: (CatalogBarItem) -> Content

    @EnvironmentObject
    private var store: CatalogStore

    public init(
        name: String,
        searchTree: ScenarioSearchTree,
        content: @escaping (CatalogBarItem) -> Content
    ) {
        self.name = name
        self.searchTree = searchTree
        self.content = content
    }

    var body: some View {
        ZStack {
            content(
                CatalogBarItem(image: Image(symbol: .docTextMagnifyingglass), insets: .only(top: 4)) {
                    self.store.isSearchTreeHidden = false
                }
            )

            Drawer(isOpened: isOpened, content: searchTree)
        }
    }
}

private extension CatalogDrawerStyle {
    var isOpened: Binding<Bool> {
        Binding(
            get: { !self.store.isSearchTreeHidden },
            set: { self.store.isSearchTreeHidden = !$0 }
        )
    }
}
