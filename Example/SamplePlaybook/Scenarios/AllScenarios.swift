import Playbook
import SampleComponent
import SwiftUI

struct AllScenarios: ScenarioProvider {
    static func addScenarios(into playbook: Playbook) {
        playbook
            .add(HomeScenarios.self)
            .add(ProfilesScenarios.self)
            .add(SupportingViewsScenarios.self)
    }
}
