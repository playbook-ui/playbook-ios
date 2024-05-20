import Playbook

internal struct SearchedData {
    let category: ScenarioCategory
    let scenario: Scenario
    let highlightRange: Range<String.Index>?
}
