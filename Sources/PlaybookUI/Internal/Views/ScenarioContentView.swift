import Playbook
import SwiftUI

@available(iOS 14.0, *)
internal struct ScenarioContentView: UIViewControllerRepresentable {
    let scenario: Scenario
    let additionalSafeAreaInsets: UIEdgeInsets
    let shareState: ShareState

    func makeUIViewController(context: Context) -> ScenarioViewController {
        let context = ScenarioContext(
            snapshotWaiter: SnapshotWaiter(),
            isSnapshot: false,
            screenSize: UIScreen.main.bounds.size
        )
        return ScenarioViewController(context: context)
    }

    func updateUIViewController(_ uiViewController: ScenarioViewController, context: Context) {
        shareState.scenarioViewController = uiViewController
        uiViewController.scenario = scenario
        uiViewController.additionalSafeAreaInsets = additionalSafeAreaInsets
    }
}
