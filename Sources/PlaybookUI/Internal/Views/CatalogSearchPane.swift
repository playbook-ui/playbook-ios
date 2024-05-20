import SwiftUI

@available(iOS 15.0, *)
internal struct CatalogSearchPane: View {
    @EnvironmentObject
    private var searchState: SearchState
    @EnvironmentObject
    private var catalogState: CatalogState
    @FocusState
    private var isFocused

    let onSelect: (SelectData) -> Void

    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                Spacer.fixed(length: 16)

                SearchBar(text: $searchState.query)
                    .focused($isFocused)
                Counter(
                    count: searchState.result.count,
                    total: searchState.result.total
                )

                Spacer.fixed(length: 16)

                Divider()

                List {
                    Group {
                        if searchState.result.kinds.isEmpty {
                            UnavailableView(
                                symbol: .magnifyingglass,
                                description: "No Result for \"\(searchState.query)\""
                            )
                        }
                        else {
                            ForEach(searchState.result.kinds, id: \.kind) { data in
                                let isExpanded = catalogState.currentExpandedKinds.contains(data.kind)

                                CatalogKindRow(data: data, isExpanded: isExpanded) {
                                    withAnimation(.smooth(duration: 0.1)) {
                                        if isExpanded {
                                            catalogState.currentExpandedKinds.remove(data.kind)
                                        }
                                        else {
                                            catalogState.currentExpandedKinds.insert(data.kind)
                                        }
                                    }
                                }

                                if isExpanded {
                                    ForEach(data.scenarios, id: \.scenario.name) { data in
                                        let select = SelectData(
                                            kind: data.kind,
                                            scenario: data.scenario
                                        )

                                        CatalogScenarioRow(
                                            data: data,
                                            isSelected: catalogState.selected?.id == select.id
                                        ) {
                                            onSelect(select)
                                        }
                                    }
                                }
                            }
                        }

                        Spacer.fixed(length: 16)
                    }
                    .listRowSpacing(.zero)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .environment(\.defaultMinListRowHeight, 0)
            }

            Rectangle()
                .fill(Color(.translucentFill))
                .frame(width: 2)
                .fixedSize(horizontal: true, vertical: false)
                .ignoresSafeArea()
        }
        .background {
            Color(.background)
                .ignoresSafeArea()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: searchState.query) { query in
            catalogState.updateSearchingKinds(query: query, searchResult: searchState.result)
        }
        .onChange(of: catalogState.isSearchPainCollapsed) { isCollapsed in
            if isCollapsed {
                isFocused = false
            }
        }
    }
}
