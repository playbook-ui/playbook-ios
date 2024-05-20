import UIKit

/// Represents part of the component state.
public struct Scenario {
    /// A unique title of scenario that describes component and its state.
    public var title: ScenarioTitle

    /// Represents how the component should be laid out.
    public var layout: ScenarioLayout

    /// A file path where defined this scenario.
    public var file: StaticString

    /// A line number where defined this scenario in file.
    public var line: UInt

    /// A closure that make a new content with passed context.
    public var content: (ScenarioContext) -> UIViewController

    /// Creates a new scenario.
    ///
    /// - Parameters:
    ///   - title: A unique title of this scenario.
    ///   - layout: Represents how the component should be laid out.
    ///   - file: A file path where defined this scenario.
    ///   - line: A line number where defined this scenario in file.
    ///   - content: A closure that make a new content with passed context.
    public init(
        _ title: ScenarioTitle,
        layout: ScenarioLayout,
        file: StaticString = #file,
        line: UInt = #line,
        content: @escaping (ScenarioContext) -> UIViewController
    ) {
        self.title = title
        self.layout = layout
        self.file = file
        self.line = line
        self.content = content
    }

    /// Creates a new scenario.
    ///
    /// - Parameters:
    ///   - title: A unique title of this scenario.
    ///   - layout: Represents how the component should be laid out.
    ///   - file: A file path where defined this scenario.
    ///   - line: A line number where defined this scenario in file.
    ///   - content: A closure that make a new content with passed context.
    public init(
        _ title: ScenarioTitle,
        layout: ScenarioLayout,
        file: StaticString = #file,
        line: UInt = #line,
        content: @escaping (ScenarioContext) -> UIView
    ) {
        self.init(
            title,
            layout: layout,
            file: file,
            line: line,
            content: { context in
                UIViewHostingController(view: content(context))
            }
        )
    }

    /// Creates a new scenario.
    ///
    /// - Parameters:
    ///   - title: A unique title of this scenario.
    ///   - layout: Represents how the component should be laid out.
    ///   - file: A file path where defined this scenario.
    ///   - line: A line number where defined this scenario in file.
    ///   - content: A closure that make a new content.
    public init(
        _ title: ScenarioTitle,
        layout: ScenarioLayout,
        file: StaticString = #file,
        line: UInt = #line,
        content: @escaping () -> UIViewController
    ) {
        self.init(
            title,
            layout: layout,
            file: file,
            line: line,
            content: { _ in content() }
        )
    }

    /// Creates a new scenario.
    ///
    /// - Parameters:
    ///   - title: A unique title of this scenario.
    ///   - layout: Represents how the component should be laid out.
    ///   - file: A file path where defined this scenario.
    ///   - line: A line number where defined this scenario in file.
    ///   - content: A closure that make a new content.
    public init(
        _ title: ScenarioTitle,
        layout: ScenarioLayout,
        file: StaticString = #file,
        line: UInt = #line,
        content: @escaping () -> UIView
    ) {
        self.init(
            title,
            layout: layout,
            file: file,
            line: line,
            content: { _ in
                UIViewHostingController(view: content())
            }
        )
    }
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
