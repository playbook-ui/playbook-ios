import SwiftUI

internal final class GalleryStore: ScenarioSearchStore {
    enum Status {
        case standby
        case ready
    }

    var selectedScenario: SearchedData? {
        willSet { objectWillChange.send() }
    }

    var status = Status.standby {
        willSet { objectWillChange.send() }
    }

    var shareItem: ImageSharingView.Item? {
        willSet { objectWillChange.send() }
    }

    let preSnapshotCountLimit: Int
    let snapshotLoader: SnapshotLoaderProtocol

    func prepare() {
        switch status {
        case .ready:
            break

        case .standby:
            takeSnapshots()
            start()
            status = .ready
        }
    }

    @discardableResult
    func takeSnapshots() -> Self {
        snapshotLoader.clean()

        playbook.stores.lazy
            .flatMap { store in
                store.scenarios.map { scenario in
                    (kind: store.kind, scenario: scenario)
                }
            }
            .prefix(preSnapshotCountLimit)
            .forEach { snapshotLoader.takeSnapshot(for: $0.scenario, kind: $0.kind, completion: nil) }

        return self
    }

    init(
        playbook: Playbook,
        preSnapshotCountLimit: Int,
        selectedScenario: SearchedData? = nil,
        status: Status = .standby,
        shareItem: ImageSharingView.Item? = nil,
        snapshotLoader: SnapshotLoaderProtocol
    ) {
        self.preSnapshotCountLimit = preSnapshotCountLimit
        self.snapshotLoader = snapshotLoader
        self.selectedScenario = selectedScenario
        self.status = status
        self.shareItem = shareItem

        super.init(playbook: playbook)
    }

    convenience init(
        playbook: Playbook,
        preSnapshotCountLimit: Int,
        screenSize: CGSize,
        userInterfaceStyle: UIUserInterfaceStyle,
        selectedScenario: SearchedData? = nil,
        status: Status = .standby,
        shareItem: ImageSharingView.Item? = nil
    ) {
        self.init(
            playbook: playbook,
            preSnapshotCountLimit: preSnapshotCountLimit,
            selectedScenario: selectedScenario,
            status: status,
            shareItem: shareItem,
            snapshotLoader: SnapshotLoader(
                name: "app.playbook-ui.SnapshotLoader",
                baseDirectoryURL: URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true),
                format: .png,
                device: SnapshotDevice(
                    name: "PlaybookCatalog",
                    size: screenSize,
                    traitCollection: UITraitCollection(userInterfaceStyle: userInterfaceStyle)
                )
            )
        )
    }
}
