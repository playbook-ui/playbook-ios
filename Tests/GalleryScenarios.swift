import SwiftUI

@testable import PlaybookUI

@available(iOS 15.0, *)
enum GalleryScenarios: ScenarioProvider {
    @MainActor
    static func addScenarios(into playbook: Playbook) {
        playbook.addScenarios(of: "Gallery") {
            Scenario("Thumbnails", layout: .fill) { context in
                PlaybookGallery(playbook: .test)
            }

            Scenario("Empty", layout: .fill) { context in
                PlaybookGallery(playbook: Playbook())
            }

            Scenario("Searching", layout: .fill) { context in
                let searchState = SearchState(playbook: .test)
                searchState.query = "1"

                return PlaybookGalleryContent(title: nil)
                    .environmentObject(searchState)
                    .environmentObject(GalleryState())
                    .environmentObject(ImageLoader())
            }

            Scenario("Row", layout: .fillH) { context in
                GalleryCategoryRow(data: .stub()) { _ in }
                    .environmentObject(ImageLoader())
            }

            Scenario("Detail", layout: .fill) { context in
                GalleryDetail(data: .stub())
            }
        }
    }
}
