import SwiftUI

/// A view that displays scenarios manged by given `Playbook` instance with
/// gallery-style appearance.
public struct PlaybookGallery: View {
    private var underlyingView: PlaybookGalleryInternal

    /// Declares the content and behavior of this view.
    public var body: some View {
        underlyingView
    }

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
        underlyingView = PlaybookGalleryInternal(
            name: name,
            snapshotColorScheme: snapshotColorScheme,
            store: GalleryStore(
                playbook: playbook,
                preSnapshotCountLimit: preSnapshotCountLimit,
                screenSize: UIScreen.main.fixedCoordinateSpace.bounds.size,
                userInterfaceStyle: snapshotColorScheme.userInterfaceStyle
            )
        )
    }
}

internal struct PlaybookGalleryInternal: View {
    var name: String
    var snapshotColorScheme: ColorScheme

    @ObservedObject
    var store: GalleryStore

    @Environment(\.galleryDependency)
    private var dependency

    init(
        name: String,
        snapshotColorScheme: ColorScheme,
        store: GalleryStore
    ) {
        self.name = name
        self.snapshotColorScheme = snapshotColorScheme
        self.store = store
    }

    public var body: some View {
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
                .environment(\.snapshotColorScheme, self.snapshotColorScheme)
                .environmentObject(self.store)
                .navigationViewStyle(StackNavigationViewStyle())
                .onAppear {
                    self.dependency.scheduler.schedule(on: .main, action: self.store.prepare)
                }
        }
    }
}

private extension PlaybookGalleryInternal {
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

            case (.counter(let lhs), .counter(let rhs)):
                return lhs == rhs

            case (.standby, .standby), (.empty, .empty):
                return true

            default:
                return false
            }
        }
    }

    func searchBar() -> some View {
        let height: CGFloat = 44
        return SearchBar(text: $store.searchText, placeholder: "Search") { searchBar in
            let backgroundImage = UIColor.tertiarySystemFill.circleImage(length: height)
            searchBar.setSearchFieldBackgroundImage(backgroundImage, for: .normal)
        }
            .accentColor(Color(.primaryBlue))
            .frame(height: height)
            .padding(.top, 16)
            .padding(.horizontal, 8)
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
            HStack {
                Spacer.zero
            }

            message("Preparing snapshots ...", font: .system(size: 24))

            Image(symbol: .book)
                .imageScale(.large)
                .font(.system(size: 60))
                .foregroundColor(Color(.label))
        }
    }

    func message(_ text: String, font: Font) -> some View {
        VStack(spacing: 0) {
            HStack {
                Spacer.zero
            }

            Text(text)
                .foregroundColor(Color(.label))
                .font(font)
                .bold()
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
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
        let tableHeaderView = UIHostingController(rootView: searchBar())
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
