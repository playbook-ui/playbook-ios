import Playbook

internal struct SearchedData {
    let kind: ScenarioKind
    let scenario: Scenario
    let highlightRange: Range<String.Index>?
}
