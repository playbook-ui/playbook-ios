import SwiftUI

@testable import PlaybookUI

@available(iOS 15.0, *)
enum CatalogScenarios: ScenarioProvider {
    @MainActor
    static func addScenarios(into playbook: Playbook) {
        playbook.addScenarios(of: "Catalog") {
            Scenario("Drawer close", layout: .fill) {
                let catalogState = CatalogState()
                catalogState.isSearchPainCollapsed = true

                return PlaybookCatalogContent(title: nil)
                    .environmentObject(SearchState(playbook: .test))
                    .environmentObject(catalogState)
                    .environmentObject(ShareState())
            }

            Scenario("Drawer open", layout: .fill) {
                let catalogState = CatalogState()
                catalogState.isSearchPainCollapsed = false

                return PlaybookCatalogContent(title: nil)
                    .environmentObject(SearchState(playbook: .test))
                    .environmentObject(catalogState)
                    .environmentObject(ShareState())
            }

            Scenario("Drawer close empty", layout: .fill) {
                let searchState = SearchState(playbook: Playbook())
                let catalogState = CatalogState()
                catalogState.isSearchPainCollapsed = true

                return PlaybookCatalogContent(title: nil)
                    .environmentObject(searchState)
                    .environmentObject(catalogState)
                    .environmentObject(ShareState())
            }

            Scenario("Drawer open empty", layout: .fill) {
                let searchState = SearchState(playbook: Playbook())
                let catalogState = CatalogState()
                catalogState.isSearchPainCollapsed = false

                return PlaybookCatalogContent(title: nil)
                    .environmentObject(searchState)
                    .environmentObject(catalogState)
                    .environmentObject(ShareState())
            }

            Scenario("Drawer open searching", layout: .fill) {
                let searchState = SearchState(playbook: .test)
                let catalogState = CatalogState()
                searchState.query = "1"
                catalogState.isSearchPainCollapsed = false

                return PlaybookCatalogContent(title: nil)
                    .environmentObject(searchState)
                    .environmentObject(catalogState)
                    .environmentObject(ShareState())
            }

            Scenario("SearchPane", layout: .sizing(h: .fixed(300), v: .fill)) {
                let catalogState = CatalogState()
                catalogState.selected = SelectData(
                    category: "Category 1",
                    scenario: .stub("Scenario 1")
                )
                catalogState.expandedCategories = ["Category 1"]
                catalogState.isSearchPainCollapsed = false

                return CatalogSearchPane { _ in }
                    .environmentObject(SearchState(playbook: .test))
                    .environmentObject(catalogState)
            }
        }
    }
}
