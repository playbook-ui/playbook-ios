import SwiftUI

/// A view that displays scenarios manged by given `Playbook` instance with
/// gallery-style appearance.
public struct PlaybookGallery: View {
    private let name: String
    private let snapshotColorScheme: ColorScheme
    private let store: GalleryStore

    /// Creates a new view that displays scenarios managed by given `Playbook` instance.
    ///
    /// - Parameters:
    ///   - name: A name of `Playbook` to be displayed on the user interface.
    ///   - playbook: A `Playbook` instance that manages scenarios to be displayed.
    ///   - preSnapshotCountLimit: The limit on the number of snapshot images for preview
    ///                            that can be generated before being displayed.
    ///   - snapshotColorScheme: The color scheme of the snapshot image for preview.
    ///
    /// - Note: If the displaying of this view is heavy, you can delay the generation
    ///         of the snapshot image for preview by lowering `preSnapshotCountLimit`.
    public init(
        name: String = "PLAYBOOK",
        playbook: Playbook = .default,
        preSnapshotCountLimit: Int = 100,
        snapshotColorScheme: ColorScheme = .light
    ) {
        self.name = name
        self.snapshotColorScheme = snapshotColorScheme
        self.store = GalleryStore(
            playbook: playbook,
            preSnapshotCountLimit: preSnapshotCountLimit,
            screenSize: UIScreen.main.fixedCoordinateSpace.bounds.size,
            userInterfaceStyle: snapshotColorScheme.userInterfaceStyle
        )
    }

    /// Declares the content and behavior of this view.
    @ViewBuilder
    public var body: some View {
        #if swift(>=5.3)
        if #available(iOS 14.0, *) {
            PlaybookGalleryIOS14(
                name: name,
                snapshotColorScheme: snapshotColorScheme,
                store: store
            )
        }
        else {
            PlaybookGalleryIOS13(
                name: name,
                snapshotColorScheme: snapshotColorScheme,
                store: store
            )
        }
        #else
        PlaybookGalleryIOS13(
            name: name,
            snapshotColorScheme: snapshotColorScheme,
            store: store
        )
        #endif
    }
}

#if swift(>=5.3)
@available(iOS 14.0, *)
internal struct PlaybookGalleryIOS14: View {
    var name: String
    var snapshotColorScheme: ColorScheme

    @ObservedObject
    var store: GalleryStore

    @Environment(\.galleryDependency)
    var dependency

    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ScrollView {
                    LazyVStack(spacing: .zero) {
                        SearchBar(text: $store.searchText, height: 44)
                            .padding(.leading, geometry.safeAreaInsets.leading)
                            .padding(.trailing, geometry.safeAreaInsets.trailing)

                        statefulBody(geometry: geometry)
                    }
                }
                .ignoresSafeArea(edges: .horizontal)
                .navigationBarTitle(name)
                .background(Color(.primaryBackground).ignoresSafeArea())
                .sheet(item: $store.selectedScenario) { data in
                    ScenarioDisplaySheet(data: data) {
                        store.selectedScenario = nil
                    }
                }
            }
            .environmentObject(store)
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear {
                dependency.scheduler.schedule(on: .main, action: store.prepare)
            }
        }
    }
}

@available(iOS 14.0, *)
private extension PlaybookGalleryIOS14 {
    @ViewBuilder
    func statefulBody(geometry: GeometryProxy) -> some View {
        switch store.status {
        case .ready where store.result.data.isEmpty:
            message("This filter resulted in 0 results", font: .headline)

        case .ready:
            Counter(numerator: store.result.matchedCount, denominator: store.scenariosCount)

            ForEach(store.result.data, id: \.kind) { data in
                ScenarioDisplayList(
                    data: data,
                    safeAreaInsets: geometry.safeAreaInsets,
                    serialDispatcher: SerialMainDispatcher(
                        interval: 0.2,
                        scheduler: dependency.scheduler
                    ),
                    onSelect: { store.selectedScenario = $0 }
                )
            }

        case .standby:
            VStack(spacing: .zero) {
                message("Preparing snapshots ...", font: .system(size: 24))

                Image(symbol: .book)
                    .imageScale(.large)
                    .font(.system(size: 60))
                    .foregroundColor(Color(.label))
            }
        }
    }

    func message(_ text: String, font: Font) -> some View {
        Text(text)
            .foregroundColor(Color(.label))
            .font(font)
            .bold()
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.vertical, 44)
            .padding(.horizontal, 24)
    }
}
#endif

internal struct PlaybookGalleryIOS13: View {
    var name: String
    var snapshotColorScheme: ColorScheme

    @ObservedObject
    var store: GalleryStore

    @Environment(\.galleryDependency)
    var dependency

    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                TableView(
                    animated: false,
                    snapshot: self.snapshot(),
                    configureUIView: self.configureTableview,
                    row: { self.row(with: $0, geometry: geometry) }
                )
                .edgesIgnoringSafeArea(.all)
                .navigationBarTitle(self.name)
                .sheet(item: self.$store.selectedScenario) { data in
                    ScenarioDisplaySheet(data: data) {
                        self.store.selectedScenario = nil
                    }
                    .environmentObject(self.store)
                }
            }
            .environmentObject(self.store)
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear {
                self.dependency.scheduler.schedule(on: .main, action: self.store.prepare)
            }
        }
    }
}

private extension PlaybookGalleryIOS13 {
    enum Status {
        case standby
        case ready
    }

    struct Section: Hashable {}

    enum Row: Hashable {
        case scenarios(data: SearchedListData)
        case counter(numerator: Int, denominator: Int)
        case standby
        case empty

        func hash(into hasher: inout Hasher) {
            switch self {
            case .scenarios(let data):
                hasher.combine(data.kind)

            case .counter(let numerator, let denominator):
                hasher.combine(numerator)
                hasher.combine(denominator)

            case .standby:
                break

            case .empty:
                break
            }
        }

        static func == (lhs: Row, rhs: Row) -> Bool {
            switch (lhs, rhs) {
            case (.scenarios(let lhs), .scenarios(let rhs)):
                return lhs.kind == rhs.kind && lhs.shouldHighlight == rhs.shouldHighlight

            case (.counter(let lDenominator, let lNumerator), .counter(let rDenominator, let rNumerator)):
                return lDenominator == rDenominator && lNumerator == rNumerator

            case (.standby, .standby), (.empty, .empty):
                return true

            default:
                return false
            }
        }
    }

    func row(with row: Row, geometry: GeometryProxy) -> some View {
        switch row {
        case .scenarios(let data):
            return AnyView(
                ScenarioDisplayList(
                    data: data,
                    safeAreaInsets: geometry.safeAreaInsets,
                    serialDispatcher: SerialMainDispatcher(
                        interval: 0.2,
                        scheduler: self.dependency.scheduler
                    ),
                    onSelect: { self.store.selectedScenario = $0 }
                )
            )

        case .counter(let numerator, let denominator):
            return AnyView(Counter(numerator: numerator, denominator: denominator))

        case .standby:
            return AnyView(standby())

        case .empty:
            return AnyView(message("This filter resulted in 0 results", font: .headline))
        }
    }

    func standby() -> some View {
        VStack(spacing: 0) {
            message("Preparing snapshots ...", font: .system(size: 24))

            Image(symbol: .book)
                .imageScale(.large)
                .font(.system(size: 60))
                .foregroundColor(Color(.label))
        }
    }

    func message(_ text: String, font: Font) -> some View {
        Text(text)
            .foregroundColor(Color(.label))
            .font(font)
            .bold()
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.vertical, 44)
            .padding(.horizontal, 24)
    }

    func snapshot() -> NSDiffableDataSourceSnapshot<Section, Row> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Row>()
        snapshot.appendSections([Section()])

        switch store.status {
        case .ready where store.result.data.isEmpty:
            snapshot.appendItems([.empty])

        case .ready:
            let counter = Row.counter(
                numerator: store.result.matchedCount,
                denominator: store.scenariosCount
            )
            snapshot.appendItems([counter] + store.result.data.map { .scenarios(data: $0) })

        case .standby:
            snapshot.appendItems([.standby])
        }

        return snapshot
    }

    func configureTableview(_ tableView: UITableView) {
        let tableHeaderView = UIHostingController(
            rootView: SearchBar(text: $store.searchText, height: 44)
        )
        tableHeaderView.view.backgroundColor = .clear
        tableHeaderView.view.sizeToFit()
        tableView.backgroundColor = .primaryBackground
        tableView.separatorStyle = .none
        tableView.insetsContentViewsToSafeArea = false
        tableView.keyboardDismissMode = .onDrag
        tableView.estimatedRowHeight = ScenarioDisplay.scale * store.snapshotLoader.device.size.height + 100
        tableView.tableHeaderView = tableHeaderView.view
        tableView.tableFooterView = UIView()
    }
}

private extension ColorScheme {
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .light:
            return .light

        case .dark:
            return .dark

        @unknown default:
            return .light
        }
    }
}
