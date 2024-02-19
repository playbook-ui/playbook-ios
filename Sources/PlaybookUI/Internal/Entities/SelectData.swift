import Playbook

internal struct SelectData: Identifiable {
    struct ID: Hashable {
        let kind: ScenarioKind
        let name: ScenarioName
    }

    var id: ID {
        ID(kind: kind, name: scenario.name)
    }

    let kind: ScenarioKind
    let scenario: Scenario
}
