internal struct SearchedData: Identifiable {
    struct ID: Hashable {
        var kind: ScenarioKind
        var name: ScenarioName
    }

    var scenario: Scenario
    var kind: ScenarioKind
    var shouldHighlight: Bool

    var id: ID {
        ID(kind: kind, name: scenario.name)
    }
}
