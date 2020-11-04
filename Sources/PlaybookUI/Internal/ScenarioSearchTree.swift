import SwiftUI

internal struct ScenarioSearchTree: View {
    @ViewBuilder
    var body: some View {
        #if swift(>=5.3)
        if #available(iOS 14.0, *) {
            ScenarioSearchTreeIOS14()
        }
        else {
            ScenarioSearchTreeIOS13()
        }
        #else
        ScenarioSearchTreeIOS13()
        #endif
    }
}

#if swift(>=5.3)
@available(iOS 14.0, *)
private struct ScenarioSearchTreeIOS14: View {
    @EnvironmentObject
    var store: CatalogStore

    var body: some View {
        VStack(spacing: .zero) {
            searchBar()

            if store.result.data.isEmpty {
                emptyContent()
            }
            else {
                ScrollView {
                    LazyVStack(spacing: .zero) {
                        ForEach(store.result.data, id: \.kind) { data in
                            let isOpened = currentOpenedKindsBinding().wrappedValue.contains(data.kind)

                            kindRow(
                                data: data,
                                isOpened: isOpened
                            )

                            if isOpened {
                                ForEach(data.scenarios, id: \.id) { data in
                                    scenarioRow(
                                        data: data,
                                        isSelected: data.id == store.selectedScenario?.id
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }
        .background(
            Color(.secondaryBackground)
                .edgesIgnoringSafeArea(.all)
        )
    }
}

@available(iOS 14.0, *)
private extension ScenarioSearchTreeIOS14 {
    func searchTextBinding() -> Binding<String?> {
        Binding(
            get: { store.searchText },
            set: { newValue in
                let isEmpty = newValue.map { $0.isEmpty } ?? true
                store.openedSearchingKinds = isEmpty ? nil : Set(store.result.data.map { $0.kind })
                store.searchText = newValue
            }
        )
    }

    func currentOpenedKindsBinding() -> Binding<Set<ScenarioKind>> {
        Binding($store.openedSearchingKinds) ?? $store.openedKinds
    }

    func kindRow(data: SearchedListData, isOpened: Bool) -> some View {
        Button(
            action: {
                if isOpened {
                    currentOpenedKindsBinding().wrappedValue.remove(data.kind)
                }
                else {
                    currentOpenedKindsBinding().wrappedValue.insert(data.kind)
                }
            },
            label: {
                VStack(spacing: .zero) {
                    HStack(spacing: 8) {
                        Image(symbol: .chevronRight)
                            .imageScale(.small)
                            .foregroundColor(Color(.label))
                            .rotationEffect(.radians(isOpened ? .pi / 2 : 0))

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
        )
    }

    func scenarioRow(data: SearchedData, isSelected: Bool) -> some View {
        Button(
            action: {
                store.selectedScenario = data
            },
            label: {
                VStack(spacing: .zero) {
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
        )
    }

    func emptyContent() -> some View {
        Text("This filter resulted in 0 results")
            .foregroundColor(Color(.label))
            .font(.body)
            .bold()
            .lineLimit(nil)
            .padding(24)
            .padding(.top, 24)
    }

    func searchBar() -> some View {
        VStack(spacing: .zero) {
            SearchBar(text: searchTextBinding(), height: 44)

            Counter(
                numerator: store.result.matchedCount,
                denominator: store.scenariosCount
            )

            HorizontalSeparator()
                .padding(.top, 8)
        }
    }
}
#endif

private struct ScenarioSearchTreeIOS13: View {
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

private extension ScenarioSearchTreeIOS13 {
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
        case kind(data: SearchedListData, isOpened: Bool)
        case scenario(data: SearchedData, isSelected: Bool)

        func hash(into hasher: inout Hasher) {
            switch self {
            case .kind(let data, isOpened: _):
                hasher.combine(data.kind)

            case .scenario(let data, isSelected: _):
                hasher.combine(data.id)
            }
        }

        static func == (lhs: Row, rhs: Row) -> Bool {
            switch (lhs, rhs) {
            case (.kind(let lData, let lisOpened), .kind(let rData, let risOpened)):
                return lData.kind == rData.kind
                    && lData.shouldHighlight == rData.shouldHighlight
                    && lisOpened == risOpened

            case (.scenario(let lData, let lIsSelected), .scenario(let rData, let rIsSelected)):
                return lData.kind == rData.kind
                    && lData.scenario.name == rData.scenario.name
                    && lData.shouldHighlight == rData.shouldHighlight
                    && lIsSelected == rIsSelected

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
        VStack(spacing: 0) {
            SearchBar(text: searchTextBinding(), height: 44)

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
        case .kind(let data, let isOpened):
            return AnyView(kindRow(data: data, isOpened: isOpened))

        case .scenario(let data, let isSelected):
            return AnyView(scenarioRow(data: data, isSelected: isSelected))
        }
    }

    func kindRow(data: SearchedListData, isOpened: Bool) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Image(symbol: .chevronRight)
                    .imageScale(.small)
                    .foregroundColor(Color(.label))
                    .rotationEffect(.radians(isOpened ? .pi / 2 : 0))

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
            let isOpened = currentOpenedKindsBinding().wrappedValue.contains(section.data.kind)
            let scenarios = isOpened ? section.data.scenarios.map { Row.scenario(data: $0, isSelected: $0.id == store.selectedScenario?.id) } : []
            snapshot.appendItems([.kind(data: section.data, isOpened: isOpened)] + scenarios, toSection: section)
        }

        return snapshot
    }

    func onSelect(_ row: Row) {
        switch row {
        case .kind(let data, let isOpened):
            if isOpened {
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
