import Playbook

internal struct SelectData: Identifiable {
    struct ID: Hashable {
        let category: ScenarioCategory
        let title: ScenarioTitle
    }

    var id: ID {
        ID(category: category, title: scenario.title)
    }

    let category: ScenarioCategory
    let scenario: Scenario
}
