import SwiftUI

@testable import PlaybookUI

enum ExtraScenarios: ScenarioProvider {
    static func addScenarios(into playbook: Playbook) {
        playbook.addScenarios(of: "Normalizable\u{7FFFF}\u{1D} \n.:/") {
            Scenario("Normalizable\u{7FFFF}\u{1D} \n.:/", layout: .fixed(length: 300)) {
                Color(.systemBlue).edgesIgnoringSafeArea(.all)
            }
        }
    }
}
