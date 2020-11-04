import SwiftUI

@testable import PlaybookUI

struct CatalogScenarios: ScenarioProvider {
    static func addScenarios(into playbook: Playbook) {
        playbook.addScenarios(of: "Catalog") {
            Scenario("Drawer close", layout: .fill) {
                PlaybookCatalogInternal(
                    name: "TEST",
                    playbook: .test,
                    store: CatalogStore(
                        playbook: .test,
                        selectedScenario: .stub,
                        isSearchTreeHidden: true
                    )
                    .start()
                )
            }

            Scenario("Drawer open", layout: .fill) {
                PlaybookCatalogInternal(
                    name: "TEST",
                    playbook: .test,
                    store: CatalogStore(
                        playbook: .test,
                        selectedScenario: .stub,
                        openedKinds: ["Kind 1"],
                        isSearchTreeHidden: false
                    )
                    .start()
                )
            }

            Scenario("Drawer close empty", layout: .fill) {
                PlaybookCatalogInternal(
                    name: "TEST",
                    playbook: Playbook(),
                    store: CatalogStore(
                        playbook: Playbook(),
                        isSearchTreeHidden: true
                    )
                )
            }

            Scenario("Drawer open empty", layout: .fill) {
                PlaybookCatalogInternal(
                    name: "TEST",
                    playbook: Playbook(),
                    store: CatalogStore(
                        playbook: Playbook(),
                        isSearchTreeHidden: false
                    )
                )
            }

            Scenario("Searching", layout: .fill) {
                PlaybookCatalogInternal(
                    name: "TEST",
                    playbook: .test,
                    store: CatalogStore(
                        playbook: .test,
                        selectedScenario: .stub,
                        openedSearchingKinds: Set(Playbook.test.stores.map { $0.kind }),
                        isSearchTreeHidden: false
                    )
                    .start(with: "2")
                )
            }

            Scenario("Drawer", layout: .sizing(h: .fixed(300), v: .fill)) {
                ScenarioSearchTreeIOS13()
                    .environmentObject(
                        CatalogStore(
                            playbook: .test,
                            selectedScenario: .stub,
                            openedKinds: ["Kind 1"],
                            isSearchTreeHidden: false
                        )
                        .start()
                    )
            }
        }

        #if swift(>=5.3)
        if #available(iOS 14.0, *) {
            playbook.addScenarios(of: "Catalog") {
                Scenario("Drawer iOS14", layout: .sizing(h: .fixed(300), v: .fill)) {
                    ScenarioSearchTreeIOS14()
                        .environmentObject(
                            CatalogStore(
                                playbook: .test,
                                selectedScenario: .stub,
                                openedKinds: ["Kind 1"],
                                isSearchTreeHidden: false
                            )
                            .start()
                        )
                }
            }
        }
        #endif
    }
}
