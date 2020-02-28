import UIKit

/// Represents a content of scenario.
public protocol ScenarioContent {
    /// Makes a new `UIViewController` instance thats wraps `self`.
    func makeUIViewController() -> UIViewController
}

extension UIView: ScenarioContent {
    /// Makes a new `UIViewController` instance thats wraps `self`.
    public func makeUIViewController() -> UIViewController {
        UIViewHostingController(view: self)
    }
}

extension UIViewController: ScenarioContent {
    /// Makes a new `UIViewController` instance thats wraps `self`.
    public func makeUIViewController() -> UIViewController { self }
}

private final class UIViewHostingController: UIViewController {
    private let _view: UIView

    init(view: UIView) {
        self._view = view
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = _view
    }
}
