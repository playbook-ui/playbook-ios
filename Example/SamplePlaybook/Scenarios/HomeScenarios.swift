import Playbook
import SampleComponent
import SwiftUI

struct HomeScenarios: ScenarioProvider {
    static func addScenarios(into playbook: Playbook) {
        playbook.addScenarios(of: "Home") {
            Scenario("CategoryHome", layout: .sizing(h: .fill, v: 1100)) {
                CategoryHome().environmentObject(UserData.stub)
            }

            Scenario("LandmarkDetail", layout: .fill) { context in
                LandmarkDetail(landmark: landmarkData[10]) {
                    context.snapshotWaiter.fulfill()
                }
                    .environmentObject(UserData.stub)
                    .onAppear(perform: context.snapshotWaiter.wait)
            }

            Scenario("LandmarkList", layout: .fill) {
                NavigationView {
                    LandmarkList().environmentObject(UserData.stub)
                }
            }

            Scenario("CategoryRow", layout: .fillH) {
                CategoryRow(
                    categoryName: landmarkData[0].category.rawValue,
                    items: Array(landmarkData.prefix(6))
                )
                    .environmentObject(UserData.stub)
            }
        }
    }
}
