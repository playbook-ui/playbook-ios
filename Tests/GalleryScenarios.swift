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

            Scenario("Thumbnail with long title", layout: .compressed) { context in
                GalleryThumbnail(
                    data: .stub(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
                    )
                )
                .environmentObject(ImageLoader())
            }
        }
    }
}
