import SwiftUI

internal struct ScenarioSearchTree: View {
    @EnvironmentObject
    private var store: CatalogStore

    var body: some View {
        VStack(spacing: 0) {
            searchBar()

            if store.result.data.isEmpty {
                emptyContent()
            }
            else {
                TableView(
                    snapshot: snapshot(),
                    configureUIView: configureTableView,
                    row: row,
                    onSelect: onSelect
                )
                    .edgesIgnoringSafeArea(.bottom)
            }
        }
            .background(
                Color(.secondaryBackground)
                    .edgesIgnoringSafeArea(.all)
            )
    }
}

private extension ScenarioSearchTree {
    struct Section: Hashable {
        var data: SearchedListData

        func hash(into hasher: inout Hasher) {
            hasher.combine(data.kind)
        }

        static func == (lhs: Section, rhs: Section) -> Bool {
            lhs.data.kind == rhs.data.kind && lhs.data.shouldHighlight == rhs.data.shouldHighlight
        }
    }

    enum Row: Hashable {
        case kind(data: SearchedListData, isOpen: Bool)
        case scenario(data: SearchedData, isSelected: Bool)

        func hash(into hasher: inout Hasher) {
            switch self {
            case .kind(let data, isOpen: _):
                hasher.combine(data.kind)

            case .scenario(let data, isSelected: _):
                hasher.combine(data.id)
            }
        }

        static func == (lhs: Row, rhs: Row) -> Bool {
            switch (lhs, rhs) {
            case (.kind(let lhs), .kind(let rhs)):
                return lhs.data.kind == rhs.data.kind
                    && lhs.data.shouldHighlight == rhs.data.shouldHighlight
                    && lhs.isOpen == rhs.isOpen

            case (.scenario(let lhs), .scenario(let rhs)):
                return lhs.data.kind == rhs.data.kind
                    && lhs.data.scenario.name == rhs.data.scenario.name
                    && lhs.data.shouldHighlight == rhs.data.shouldHighlight
                    && lhs.isSelected == rhs.isSelected

            default:
                return false
            }
        }
    }

    func currentOpenedKindsBinding() -> Binding<Set<ScenarioKind>> {
        Binding($store.openedSearchingKinds) ?? $store.openedKinds
    }

    func searchTextBinding() -> Binding<String?> {
        Binding(
            get: { self.store.searchText },
            set: { newValue in
                let isEmpty = newValue.map { $0.isEmpty } ?? true
                self.store.openedSearchingKinds = isEmpty ? nil : Set(self.store.result.data.map { $0.kind })
                self.store.searchText = newValue
            }
        )
    }

    func searchBar() -> some View {
        let height: CGFloat = 44
        return VStack(spacing: 0) {
            SearchBar(text: searchTextBinding(), placeholder: "Search") { searchBar in
                let backgroundImage = UIColor.tertiarySystemFill.circleImage(length: height)
                searchBar.setSearchFieldBackgroundImage(backgroundImage, for: .normal)
            }
                .accentColor(Color(.primaryBlue))
                .frame(height: height)
                .padding(.top, 16)
                .padding(.horizontal, 8)

            Counter(
                numerator: store.result.matchedCount,
                denominator: store.scenariosCount
            )

            HorizontalSeparator()
                .padding(.top, 8)
        }
    }

    func row(with row: Row) -> some View {
        switch row {
        case .kind(let data, let isOpen):
            return AnyView(kindRow(data: data, isOpen: isOpen))

        case .scenario(let data, let isSelected):
            return AnyView(scenarioRow(data: data, isSelected: isSelected))
        }
    }

    func kindRow(data: SearchedListData, isOpen: Bool) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Image(symbol: .chevronRight)
                    .imageScale(.small)
                    .foregroundColor(Color(.label))
                    .rotationEffect(.radians(isOpen ? .pi / 2 : 0))

                Image(symbol: .bookmarkFill)
                    .imageScale(.medium)
                    .foregroundColor(Color(.primaryBlue))

                Text(data.kind.rawValue)
                    .bold()
                    .font(.system(size: 20))
                    .lineSpacing(4)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(Color(.label))
                    .background(Highlight(data.shouldHighlight))

                Spacer(minLength: 16)
            }
                .padding(.vertical, 24)

            HorizontalSeparator()
        }
            .padding(.leading, 16)
    }

    func scenarioRow(data: SearchedData, isSelected: Bool) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Image(symbol: .circleFill)
                    .font(.system(size: 10))
                    .foregroundColor(Color(isSelected ? .primaryBlue : .tertiarySystemFill))

                Text(data.scenario.name.rawValue)
                    .font(.subheadline)
                    .bold()
                    .lineLimit(nil)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(Color(.label))
                    .background(Highlight(data.shouldHighlight))

                Spacer(minLength: 16)
            }
                .padding(.vertical, 16)

            HorizontalSeparator()
        }
            .padding(.leading, 56)
    }

    func emptyContent() -> some View {
        VStack(spacing: 0) {
            Text("This filter resulted in 0 results")
                .foregroundColor(Color(.label))
                .font(.body)
                .bold()
                .lineLimit(nil)
                .padding(24)

            Spacer.zero
        }
            .padding(.top, 24)
    }

    func snapshot() -> NSDiffableDataSourceSnapshot<Section, Row> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Row>()

        guard !store.result.data.isEmpty else {
            return snapshot
        }

        let sections = store.result.data.map(Section.init)
        snapshot.appendSections(sections)

        for section in sections {
            let isOpen = currentOpenedKindsBinding().wrappedValue.contains(section.data.kind)
            let scenarios = isOpen ? section.data.scenarios.map { Row.scenario(data: $0, isSelected: $0.id == store.selectedScenario?.id) } : []
            snapshot.appendItems([.kind(data: section.data, isOpen: isOpen)] + scenarios, toSection: section)
        }

        return snapshot
    }

    func onSelect(_ row: Row) {
        switch row {
        case .kind(let data, let isOpen):
            if isOpen {
                currentOpenedKindsBinding().wrappedValue.remove(data.kind)
            }
            else {
                currentOpenedKindsBinding().wrappedValue.insert(data.kind)
            }

        case .scenario(let data, isSelected: _):
            store.selectedScenario = data
        }
    }

    func configureTableView(_ tableView: UITableView) {
        tableView.estimatedRowHeight = 70
        tableView.contentInset.bottom = 44
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.insetsContentViewsToSafeArea = false
    }
}
