import Playbook
import SwiftUI

@MainActor
internal final class SearchState: ObservableObject {
    private let playbook: Playbook

    @Published
    var query = "" {
        didSet { search(query: query) }
    }

    @Published
    private(set) var result = SearchResult(count: 0, total: 0, kinds: [])

    init(playbook: Playbook) {
        self.playbook = playbook
        search(query: query)
    }
}

private extension SearchState {
    func search(query: String) {
        let query = query.lowercased()

        func matchedRange(_ string: String) -> Range<String.Index>? {
            string.lowercased().range(of: query)
        }

        let kinds: [SearchedKindData] =
            if query.isEmpty {
                playbook.stores.map { store in
                    SearchedKindData(
                        kind: store.kind,
                        highlightRange: nil,
                        scenarios: store.scenarios.map { scenario in
                            SearchedData(
                                kind: store.kind,
                                scenario: scenario,
                                highlightRange: nil
                            )
                        }
                    )
                }
            }
            else {
                playbook.stores.compactMap { store in
                    if let range = matchedRange(store.kind.rawValue) {
                        return SearchedKindData(
                            kind: store.kind,
                            highlightRange: range,
                            scenarios: store.scenarios.map { scenario in
                                SearchedData(
                                    kind: store.kind,
                                    scenario: scenario,
                                    highlightRange: matchedRange(scenario.name.rawValue)
                                )
                            }
                        )
                    }
                    else {
                        let data = SearchedKindData(
                            kind: store.kind,
                            highlightRange: nil,
                            scenarios: store.scenarios.compactMap { scenario in
                                guard let range = matchedRange(scenario.name.rawValue) else {
                                    return nil
                                }

                                return SearchedData(
                                    kind: store.kind,
                                    scenario: scenario,
                                    highlightRange: range
                                )
                            }
                        )
                        return data.scenarios.isEmpty ? nil : data
                    }
                }
            }

        result = SearchResult(
            count: kinds.reduce(0) { $0 + $1.scenarios.count },
            total: playbook.stores.reduce(0) { $0 + $1.scenarios.count },
            kinds: kinds
        )
    }
}
