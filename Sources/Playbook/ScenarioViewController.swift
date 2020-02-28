import UIKit

/// The view controller to layout scenario's content.
open class ScenarioViewController: UIViewController {
    /// The context of scenario that indicating environments.
    public let context: ScenarioContext

    /// The currently displayed scenario.
    public var scenario: Scenario? {
        didSet { updateContent(scenario: scenario, previous: oldValue) }
    }

    /// The view controller wrapping content of currently displayed scenario.
    public private(set) var contentViewController: UIViewController? {
        didSet {
            guard let oldValue = oldValue else { return }

            oldValue.willMove(toParent: nil)
            oldValue.view.removeFromSuperview()
            oldValue.removeFromParent()
            oldValue.didMove(toParent: nil)
        }
    }

    /// Specifies whether the status bar should be hidden.
    public var shouldStatusBarHidden = false

    /// Specifies whether the `endAppearanceTransition` should be call after transition.
    public var disablesEndAppearanceTransition = false

    /// Specifies whether the view controller prefers the status bar to be hidden or shown.
    open override var prefersStatusBarHidden: Bool { shouldStatusBarHidden }

    /// Tells the child controller its appearance changed.
    open override func endAppearanceTransition() {
        // Override to prevent warning in snapshot phase: Unbalanced calls to begin/end appearance transitions for <XXX: 0x000000000000>.
        if !disablesEndAppearanceTransition {
            super.endAppearanceTransition()
        }
    }

    /// Initialize a new scenario view controller with given context.
    ///
    /// - Parameters:
    ///   - context: The context of scenario.
    public init(context: ScenarioContext) {
        self.context = context

        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = .clear
        view.clipsToBounds = true
    }

    /// Initialize a new scenario view controller with given context.
    ///
    /// - Parameters:
    ///   - context: The context of scenario.
    ///   - scenario: A scenario to be displayed initially.
    public convenience init(context: ScenarioContext, scenario: Scenario) {
        self.init(context: context)

        self.scenario = scenario
        updateContent(scenario: scenario, previous: nil)
    }

    /// Unavailable initializer.
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ScenarioViewController {
    func updateContent(scenario: Scenario?, previous: Scenario?) {
        guard let scenario = scenario else {
            return contentViewController = nil
        }

        if let previous = previous, scenario.name == previous.name {
            return
        }

        let contentViewController = scenario.content(context).makeUIViewController()
        self.contentViewController = contentViewController

        contentViewController.willMove(toParent: self)
        contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(contentViewController)
        view.addSubview(contentViewController.view)

        let horizontalConstraints: [NSLayoutConstraint]
        let verticalConstraints: [NSLayoutConstraint]

        switch scenario.layout.h {
        case .compressed:
            horizontalConstraints = [
                view.centerXAnchor.constraint(equalTo: contentViewController.view.centerXAnchor),
                view.leadingAnchor.constraint(lessThanOrEqualTo: contentViewController.view.leadingAnchor),
                view.trailingAnchor.constraint(greaterThanOrEqualTo: contentViewController.view.trailingAnchor),
            ]

        case .fill:
            horizontalConstraints = [
                view.leadingAnchor.constraint(equalTo: contentViewController.view.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: contentViewController.view.trailingAnchor),
            ]

        case .fixed(let width):
            horizontalConstraints = [
                contentViewController.view.widthAnchor.constraint(equalToConstant: width).priority(.required - 1),
                view.centerXAnchor.constraint(equalTo: contentViewController.view.centerXAnchor).priority(.defaultHigh),
                view.leadingAnchor.constraint(lessThanOrEqualTo: contentViewController.view.leadingAnchor),
                view.trailingAnchor.constraint(greaterThanOrEqualTo: contentViewController.view.trailingAnchor),
            ]
        }

        switch scenario.layout.v {
        case .compressed:
            verticalConstraints = [
                view.centerYAnchor.constraint(equalTo: contentViewController.view.centerYAnchor),
                view.topAnchor.constraint(lessThanOrEqualTo: contentViewController.view.topAnchor),
                view.bottomAnchor.constraint(greaterThanOrEqualTo: contentViewController.view.bottomAnchor),
            ]

        case .fill:
            verticalConstraints = [
                view.topAnchor.constraint(equalTo: contentViewController.view.topAnchor),
                view.bottomAnchor.constraint(equalTo: contentViewController.view.bottomAnchor),
            ]

        case .fixed(let height):
            verticalConstraints = [
                contentViewController.view.heightAnchor.constraint(equalToConstant: height).priority(.required - 1),
                view.centerYAnchor.constraint(equalTo: contentViewController.view.centerYAnchor).priority(.defaultHigh),
                view.topAnchor.constraint(lessThanOrEqualTo: contentViewController.view.topAnchor),
                view.bottomAnchor.constraint(greaterThanOrEqualTo: contentViewController.view.bottomAnchor),
            ]
        }

        NSLayoutConstraint.activate(horizontalConstraints + verticalConstraints)
        contentViewController.didMove(toParent: self)
    }
}

private extension NSLayoutConstraint {
    func priority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
