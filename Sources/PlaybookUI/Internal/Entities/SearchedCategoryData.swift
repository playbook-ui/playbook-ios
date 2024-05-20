import Playbook

internal struct SearchedCategoryData {
    let category: ScenarioCategory
    let highlightRange: Range<String.Index>?
    let scenarios: [SearchedData]
}
