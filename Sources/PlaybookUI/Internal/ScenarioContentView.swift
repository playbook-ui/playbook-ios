import SwiftUI

internal struct ScenarioContentView: UIViewControllerRepresentable {
    var kind: ScenarioKind
    var scenario: Scenario
    var additionalSafeAreaInsets: UIEdgeInsets

    @WeakReference
    private var contentUIView: UIView?

    init(
        kind: ScenarioKind,
        scenario: Scenario,
        additionalSafeAreaInsets: UIEdgeInsets = .zero,
        contentUIView: WeakReference<UIView>
    ) {
        self.kind = kind
        self.scenario = scenario
        self.additionalSafeAreaInsets = additionalSafeAreaInsets
        self._contentUIView = contentUIView
    }

    init(
        kind: ScenarioKind,
        scenario: Scenario,
        additionalSafeAreaInsets: UIEdgeInsets = .zero
    ) {
        self.kind = kind
        self.scenario = scenario
        self.additionalSafeAreaInsets = additionalSafeAreaInsets
    }

    func makeUIViewController(context: Context) -> ScenarioViewController {
        let context = ScenarioContext(
            snapshotWaiter: SnapshotWaiter(),
            isSnapshot: false,
            screenSize: UIScreen.main.bounds.size
        )
        return ScenarioViewController(context: context)
    }

    func updateUIViewController(_ uiViewController: ScenarioViewController, context: Context) {
        contentUIView = uiViewController.view
        uiViewController.scenario = scenario
        uiViewController.additionalSafeAreaInsets = additionalSafeAreaInsets
    }
}
