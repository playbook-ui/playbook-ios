import Playbook
import SwiftUI

@MainActor
internal final class CatalogState: ObservableObject {
    @Published
    var selected: SelectData?
    @Published
    var isSearchPainCollapsed = true
    @Published
    var colorScheme: ColorScheme?
    @Published
    var expandedCategories = Set<ScenarioCategory>()
    @Published
    var searchingCategories: Set<ScenarioCategory>?

    var currentExpandedCategories: Set<ScenarioCategory> {
        get { searchingCategories ?? expandedCategories }
        set {
            if searchingCategories != nil {
                searchingCategories = newValue
            }
            else {
                expandedCategories = newValue
            }
        }
    }

    func selectInitial(searchResult: SearchResult) {
        guard selected == nil else {
            return
        }

        let scenario = searchResult.categories.first?.scenarios.first
        selected = scenario.map { scenario in
            SelectData(
                category: scenario.category,
                scenario: scenario.scenario
            )
        }
    }

    func updateSearchingCategories(query: String, searchResult: SearchResult) {
        searchingCategories =
            query.isEmpty
            ? nil
            : Set(searchResult.categories.map(\.category))
    }
}
