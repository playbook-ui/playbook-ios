import Playbook
import SampleComponent
import SwiftUI

struct ProfilesScenarios: ScenarioProvider {
    static func addScenarios(into playbook: Playbook) {
        playbook.addScenarios(of: "Profiles") {
            Scenario("ProfileSummary", layout: .fill) {
                ProfileSummary(profile: .stub)
            }

            Scenario("ProfileEditor", layout: .fill) {
                ProfileEditor(profile: .constant(.stub))
            }

            Scenario("ProfileHost", layout: .fill) {
                ProfileHost().environmentObject(UserData.stub)
            }

            Scenario("HikeDetail", layout: .fixedH(300)) {
                HikeDetail(hike: hikeData[0])
            }

            Scenario("HikeView", layout: .compressed) {
                VStack {
                    HikeView(hike: hikeData[0], showDetail: false)

                    Divider()

                    HikeView(hike: hikeData[0], showDetail: true)
                }
            }

            Scenario("HikeBadge", layout: .compressed) {
                HikeBadge(name: "Awesome Hike")
            }
        }
    }
}
