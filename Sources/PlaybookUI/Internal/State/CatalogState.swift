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
    var expandedKinds = Set<ScenarioKind>()
    @Published
    var searchingKinds: Set<ScenarioKind>?

    var currentExpandedKinds: Set<ScenarioKind> {
        get { searchingKinds ?? expandedKinds }
        set {
            if searchingKinds != nil {
                searchingKinds = newValue
            }
            else {
                expandedKinds = newValue
            }
        }
    }

    func selectInitial(searchResult: SearchResult) {
        guard selected == nil else {
            return
        }

        let scenario = searchResult.kinds.first?.scenarios.first
        selected = scenario.map { scenario in
            SelectData(
                kind: scenario.kind,
                scenario: scenario.scenario
            )
        }
    }

    func updateSearchingKinds(query: String, searchResult: SearchResult) {
        searchingKinds =
            query.isEmpty
            ? nil
            : Set(searchResult.kinds.map(\.kind))
    }
}
