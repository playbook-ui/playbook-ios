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
    private(set) var result = SearchResult(count: 0, total: 0, categories: [])

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

        let categories: [SearchedCategoryData] =
            if query.isEmpty {
                playbook.stores.map { store in
                    SearchedCategoryData(
                        category: store.category,
                        highlightRange: nil,
                        scenarios: store.scenarios.map { scenario in
                            SearchedData(
                                category: store.category,
                                scenario: scenario,
                                highlightRange: nil
                            )
                        }
                    )
                }
            }
            else {
                playbook.stores.compactMap { store in
                    if let range = matchedRange(store.category.rawValue) {
                        return SearchedCategoryData(
                            category: store.category,
                            highlightRange: range,
                            scenarios: store.scenarios.map { scenario in
                                SearchedData(
                                    category: store.category,
                                    scenario: scenario,
                                    highlightRange: matchedRange(scenario.title.rawValue)
                                )
                            }
                        )
                    }
                    else {
                        let data = SearchedCategoryData(
                            category: store.category,
                            highlightRange: nil,
                            scenarios: store.scenarios.compactMap { scenario in
                                guard let range = matchedRange(scenario.title.rawValue) else {
                                    return nil
                                }

                                return SearchedData(
                                    category: store.category,
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
            count: categories.reduce(0) { $0 + $1.scenarios.count },
            total: playbook.stores.reduce(0) { $0 + $1.scenarios.count },
            categories: categories
        )
    }
}
