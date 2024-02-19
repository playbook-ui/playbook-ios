import Playbook

internal struct SearchedKindData {
    let kind: ScenarioKind
    let highlightRange: Range<String.Index>?
    let scenarios: [SearchedData]
}
