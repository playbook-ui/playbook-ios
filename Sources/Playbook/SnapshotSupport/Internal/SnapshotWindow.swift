import UIKit

internal final class SnapshotWindow: UIWindow {
    private let scenario: Scenario
    private let device: SnapshotDevice
    private let scenarioViewController: ScenarioViewController
    private let maxSize: CGSize?

    var contentView: UIView? {
        scenarioViewController.contentViewController?.view
    }

    override var traitCollection: UITraitCollection {
        UITraitCollection(traitsFrom: [super.traitCollection, device.traitCollection])
    }

    override var safeAreaInsets: UIEdgeInsets {
        var safeAreaInsets = device.safeAreaInsets
        let prefersStatusBarHidden = scenarioViewController.contentViewController?.prefersStatusBarHidden ?? false

        if prefersStatusBarHidden {
            safeAreaInsets.top = .zero
        }

        return safeAreaInsets
    }

    init(
        scenario: Scenario,
        device: SnapshotDevice,
        maxSize: CGSize? = nil
    ) {
        let context = ScenarioContext(
            snapshotWaiter: SnapshotWaiter(),
            isSnapshot: true,
            screenSize: device.size
        )

        self.scenario = scenario
        self.device = device
        self.maxSize = maxSize
        self.scenarioViewController = ScenarioViewController(context: context, scenario: scenario)

        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func prepareForSnapshot(completion: @escaping () -> Void) {
        scenarioViewController.disablesEndAppearanceTransition = true
        scenarioViewController.shouldStatusBarHidden = true

        windowLevel = .normal - 1
        layer.speed = .greatestFiniteMagnitude
        rootViewController = scenarioViewController
        isHidden = false

        let idealWidth = scenario.layout.fixedWidth ?? device.size.width
        let idealHeight = scenario.layout.fixedHeight ?? device.size.height

        frame.size = CGSize(
            width: maxSize.map { min($0.width, idealWidth) } ?? idealWidth,
            height: maxSize.map { min($0.height, idealHeight) } ?? idealHeight
        )

        if window != nil {
            // In iOS 16 and 17, setting `isHidden` nor does not update
            // the safeAreaInsets on the rootViewController's view. Updating
            // `additionalSafeAreaInsets` will so force an update
            if scenarioViewController.view.safeAreaInsets == .zero {
                scenarioViewController.additionalSafeAreaInsets = .init(top: 1, left: 0, bottom: 0, right: 0)
                scenarioViewController.additionalSafeAreaInsets = .zero
            }

            // Prioritise use snapshot device's `safeAreaInsets`
            // by `additionalSafeAreaInsets` if having a parent window.
            let originalSafeAreaInsets = scenarioViewController.view.safeAreaInsets
            scenarioViewController.additionalSafeAreaInsets = originalSafeAreaInsets
                .negate
                .adding(insets: safeAreaInsets)
        }

        // This sometimes occurs the warning with symbol `UITableViewAlertForLayoutOutsideViewHierarchy`
        // However, that's probably caused by SwiftUI.
        scenarioViewController.view.layer.layoutIfNeeded()

        let waiter = scenarioViewController.context.snapshotWaiter

        if waiter.isWaiting {
            DispatchQueue.snapshotAwaitQueue.async {
                waiter.await()
                DispatchQueue.main.async(execute: completion)
            }
        }
        else {
            completion()
        }
    }
}

private extension DispatchQueue {
    static let snapshotAwaitQueue = DispatchQueue(
        label: "app.playbook-ui.Snapshot.snapshotAwaitQueue",
        qos: .default,
        attributes: .concurrent,
        autoreleaseFrequency: .workItem
    )
}

private extension ScenarioLayout {
    var fixedWidth: CGFloat? {
        guard case .fixed(let width) = h else {
            return nil
        }
        return width
    }

    var fixedHeight: CGFloat? {
        guard case .fixed(let height) = v else {
            return nil
        }
        return height
    }
}

private extension UIEdgeInsets {
    var negate: UIEdgeInsets {
        UIEdgeInsets(
            top: -top,
            left: -left,
            bottom: -bottom,
            right: -right
        )
    }

    func adding(insets: UIEdgeInsets) -> UIEdgeInsets {
        UIEdgeInsets(
            top: top + insets.top,
            left: left + insets.left,
            bottom: bottom + insets.bottom,
            right: right + insets.right
        )
    }
}
