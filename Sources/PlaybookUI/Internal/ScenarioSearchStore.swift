import SwiftUI

internal class ScenarioSearchStore: ObservableObject {
    @Published
    private(set) var result = SearchResult(matchedCount: 0, data: [])

    let playbook: Playbook

    private(set) lazy var scenariosCount = playbook.stores.reduce(0) { $0 + $1.scenarios.count }

    var searchText: String? {
        didSet { search(searchText) }
    }

    init(playbook: Playbook) {
        self.playbook = playbook
    }

    @discardableResult
    func start(with searchText: String? = nil) -> Self {
        self.searchText = searchText
        return self
    }
}

private extension ScenarioSearchStore {
    func search(_ query: String?) {
        let query = query?.lowercased() ?? ""

        func isMatched(_ string: String) -> Bool {
            string.lowercased().contains(query)
        }

        let data: [SearchedListData]

        if query.isEmpty {
            data = playbook.stores.map { store in
                SearchedListData(
                    kind: store.kind,
                    shouldHighlight: false,
                    scenarios: store.scenarios.map { scenario in
                        SearchedData(
                            scenario: scenario,
                            kind: store.kind,
                            shouldHighlight: false
                        )
                    }
                )
            }
        }
        else {
            data = playbook.stores.compactMap { store in
                if isMatched(store.kind.rawValue) {
                    return SearchedListData(
                        kind: store.kind,
                        shouldHighlight: true,
                        scenarios: store.scenarios.map { scenario in
                            SearchedData(
                                scenario: scenario,
                                kind: store.kind,
                                shouldHighlight: isMatched(scenario.name.rawValue)
                            )
                        }
                    )
                }
                else {
                    let data = SearchedListData(
                        kind: store.kind,
                        shouldHighlight: false,
                        scenarios: store.scenarios.compactMap { scenario in
                            guard isMatched(scenario.name.rawValue) else { return nil }

                            return SearchedData(
                                scenario: scenario,
                                kind: store.kind,
                                shouldHighlight: true
                            )
                        }
                    )
                    return data.scenarios.isEmpty ? nil : data
                }
            }
        }

        return result = SearchResult(
            matchedCount: data.reduce(0) { $0 + $1.scenarios.count },
            data: data
        )
    }
}
