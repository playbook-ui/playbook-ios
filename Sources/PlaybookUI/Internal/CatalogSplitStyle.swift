import SwiftUI

internal struct CatalogSplitStyle<Content: View>: View {
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
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                HStack(spacing: 0) {
                    self.searchTree

                    Divider()
                        .edgesIgnoringSafeArea(.all)
                }
                    .frame(width: self.sidebarWidth(with: geometry))

                HStack(spacing: 0) {
                    Spacer.fixed(length: self.store.isSearchTreeHidden ? 0 : self.sidebarWidth(with: geometry))

                    self.content(
                        CatalogBarItem(
                            image: Image(symbol: self.store.isSearchTreeHidden ? .sidebarLeft : .rectangle),
                            insets: .only(top: 2),
                            action: { self.store.isSearchTreeHidden.toggle() }
                        )
                    )
                }
            }
                .animation(nil, value: geometry.size)
                .animation(.interactiveSpring())
                .transformEnvironment(\.horizontalSizeClass) { sizeClass in
                    if !self.store.isSearchTreeHidden && geometry.size.width < geometry.size.height {
                        sizeClass = .compact
                    }
                }
        }
    }
}

private extension CatalogSplitStyle {
    func sidebarWidth(with geometry: GeometryProxy) -> CGFloat {
        geometry.size.width / 3
    }
}
