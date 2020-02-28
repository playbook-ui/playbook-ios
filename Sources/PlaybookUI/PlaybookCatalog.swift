import SwiftUI

/// A view that displays scenarios manged by given `Playbook` instance with
/// catalog-style appearance.
public struct PlaybookCatalog: View {
    private var underlyingView: PlaybookCatalogInternal

    /// Declares the content and behavior of this view.
    public var body: some View {
        underlyingView
    }

    /// Creates a new view that displays scenarios managed by given `Playbook` instance.
    /// 
    /// - Parameters:
    ///   - name: A name of `Playbook` to be displayed on the user interface.
    ///   - playbook: A `Playbook` instance that manages scenarios to be displayed.
    public init(
        name: String = "PLAYBOOK",
        playbook: Playbook = .default
    ) {
        underlyingView = PlaybookCatalogInternal(
            name: name,
            playbook: playbook,
            store: CatalogStore(playbook: playbook)
        )
    }
}

internal struct PlaybookCatalogInternal: View {
    var name: String
    var playbook: Playbook

    @ObservedObject
    var store: CatalogStore

    @WeakReference
    private var contentUIView: UIView?

    @Environment(\.horizontalSizeClass)
    private var horizontalSizeClass

    @Environment(\.verticalSizeClass)
    private var verticalSizeClass

    public var body: some View {
        platformContent()
            .environmentObject(store)
            .onAppear(perform: selectFirstScenario)
            .sheet(item: $store.shareItem) { item in
                ImageSharingView(item: item) { self.store.shareItem = nil }
                    .edgesIgnoringSafeArea(.all)
            }
    }
}

private extension PlaybookCatalogInternal {
    var bottomBarHeight: CGFloat { 44 }

    func platformContent() -> some View {
        switch (horizontalSizeClass, verticalSizeClass) {
        case (.regular, .regular):
            return AnyView(
                CatalogSplitStyle(
                    name: name,
                    searchTree: ScenarioSearchTree(),
                    content: scenarioContent
                )
            )

        default:
            return AnyView(
                CatalogDrawerStyle(
                    name: name,
                    searchTree: ScenarioSearchTree(),
                    content: scenarioContent
                )
            )
        }
    }

    func displayView() -> some View {
        if let data = store.selectedScenario {
            return AnyView(
                ScenarioContentView(
                    kind: data.kind,
                    scenario: data.scenario,
                    additionalSafeAreaInsets: .only(bottom: bottomBarHeight),
                    contentUIView: _contentUIView
                )
                    .edgesIgnoringSafeArea(.all)
            )
        }
        else {
            return AnyView(emptyContent())
        }
    }

    func emptyContent() -> some View {
        VStack(spacing: 0) {
            HStack {
                Spacer.zero
            }

            Spacer.zero

            Image(symbol: .book)
                .imageScale(.large)
                .font(.system(size: 60))
                .foregroundColor(Color(.label))

            Spacer.fixed(length: 44)

            Text("There are no scenarios")
                .foregroundColor(Color(.label))
                .font(.system(size: 24, weight: .bold))
                .lineLimit(nil)

            Spacer.zero
        }
            .padding(.horizontal, 24)
    }

    func scenarioContent(firstBarItem: CatalogBarItem) -> some View {
        ZStack {
            Color(.scenarioBackground)
                .edgesIgnoringSafeArea(.all)

            displayView()

            VStack(spacing: 0) {
                Spacer.zero

                Divider()
                    .edgesIgnoringSafeArea(.all)

                bottomBar(firstBarItem: firstBarItem)
            }
        }
    }

    func bottomBar(firstBarItem: CatalogBarItem) -> some View {
        HStack(spacing: 24) {
            firstBarItem

            if store.selectedScenario != nil {
                CatalogBarItem(
                    image: Image(symbol: .squareAndArrowUp),
                    insets: .only(bottom: 4),
                    action: share
                )
            }

            HStack(spacing: 0) {
                Spacer(minLength: 0)

                Text(name)
                    .bold()
                    .lineLimit(1)
                    .font(.system(size: 24))
            }
        }
            .padding(.horizontal, 24)
            .frame(height: bottomBarHeight)
            .background(
                Blur(style: .systemMaterial)
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all),
                alignment: .topLeading
            )
    }

    func share() {
        guard let uiView = contentUIView else { return }

        let image = UIGraphicsImageRenderer(bounds: uiView.bounds).image { _ in
            uiView.drawHierarchy(in: uiView.bounds, afterScreenUpdates: true)
        }

        store.shareItem = ImageSharingView.Item(image: image)
    }

    func selectFirstScenario() {
        guard store.selectedScenario == nil, let store = playbook.stores.first, let scenario = store.scenarios.first else {
            return
        }

        self.store.start()
        self.store.selectedScenario = SearchedData(
            scenario: scenario,
            kind: store.kind,
            shouldHighlight: false
        )
    }
}
