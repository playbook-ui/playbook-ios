import SwiftUI

@available(iOS 13.0, *)
public extension Scenario {
    /// Creates a new scenario with SwiftUI view.
    ///
    /// - Parameters:
    ///   - title: A unique title of this scenario.
    ///   - layout: Represents how the component should be laid out.
    ///   - file: A file path where defined this scenario.
    ///   - line: A line number where defined this scenario in file.
    ///   - content: A closure that make a new content with passed context.
    init<Content: View>(
        _ title: ScenarioTitle,
        layout: ScenarioLayout,
        file: StaticString = #file,
        line: UInt = #line,
        @ViewBuilder content: @escaping (ScenarioContext) -> Content
    ) {
        self.init(title, layout: layout, file: file, line: line) { context in
            let content = content(context).transaction { transaction in
                if context.isSnapshot {
                    transaction.disablesAnimations = true
                }
            }
            let controller = UIHostingController(rootView: content)
            controller.view.backgroundColor = .clear
            return controller
        }
    }

    /// Creates a new scenario with SwiftUI view.
    ///
    /// - Parameters:
    ///   - title: A unique title of this scenario.
    ///   - layout: Represents how the component should be laid out.
    ///   - file: A file path where defined this scenario.
    ///   - line: A line number where defined this scenario in file.
    ///   - content: A closure that make a new content.
    init<Content: View>(
        _ title: ScenarioTitle,
        layout: ScenarioLayout,
        file: StaticString = #file,
        line: UInt = #line,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            title,
            layout: layout,
            file: file,
            line: line,
            content: { _ in content() }
        )
    }
}
