import SwiftUI

@testable import PlaybookUI

enum ExtraScenarios: ScenarioProvider {
    static func addScenarios(into playbook: Playbook) {
        playbook.addScenarios(of: "Extra") {
            Scenario("Over internal size limitation 8192x8192", layout: .fixed(width: 10000, height: 10000)) {
                Color.red.edgesIgnoringSafeArea(.all)
            }
        }

        playbook.addScenarios(of: "Normalizable\u{7FFFF}\u{1D} \n.:/") {
            Scenario("Normalizable\u{7FFFF}\u{1D} \n.:/", layout: .fixed(length: 300)) {
                Color.blue.edgesIgnoringSafeArea(.all)
            }
        }
    }
}
