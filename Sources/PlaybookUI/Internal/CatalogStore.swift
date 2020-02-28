internal final class CatalogStore: ScenarioSearchStore {
    var selectedScenario: SearchedData? {
        willSet { objectWillChange.send() }
    }

    var openedKinds = Set<ScenarioKind>() {
        willSet { objectWillChange.send() }
    }

    var openedSearchingKinds: Set<ScenarioKind>? {
        willSet { objectWillChange.send() }
    }

    var shareItem: ImageSharingView.Item? {
        willSet { objectWillChange.send() }
    }

    var isSearchTreeHidden = false {
        willSet { objectWillChange.send() }
    }

    init(
        playbook: Playbook,
        selectedScenario: SearchedData? = nil,
        openedKinds: Set<ScenarioKind> = [],
        openedSearchingKinds: Set<ScenarioKind>? = nil,
        shareItem: ImageSharingView.Item? = nil,
        isSearchTreeHidden: Bool = false
    ) {
        self.selectedScenario = selectedScenario
        self.openedKinds = openedKinds
        self.openedSearchingKinds = openedSearchingKinds
        self.shareItem = shareItem
        self.isSearchTreeHidden = isSearchTreeHidden
        super.init(playbook: playbook)
    }
}
