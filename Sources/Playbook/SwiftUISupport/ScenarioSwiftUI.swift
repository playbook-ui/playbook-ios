#if canImport(SwiftUI) && canImport(Combine)

import SwiftUI

@available(iOS 13.0, *)
public extension Scenario {
    /// Creates a new scenario with SwiftUI view.
    ///
    /// - Parameters:
    ///   - name: An unique name of this scenario.
    ///   - layout: Represents how the component should be laid out.
    ///   - file: A file path where defined this scenario.
    ///   - line: A line number where defined this scenario in file.
    ///   - content: A closure that make a new content with passed context.
    init<Content: View>(
        _ name: ScenarioName,
        layout: ScenarioLayout,
        file: StaticString = #file,
        line: UInt = #line,
        content: @escaping (ScenarioContext) -> Content
    ) {
        self.init(name, layout: layout, file: file, line: line) { context in
            let controller = UIHostingController(rootView: content(context))
            controller.view.backgroundColor = .clear
            return controller
        }
    }

    /// Creates a new scenario with SwiftUI view.
    ///
    /// - Parameters:
    ///   - name: An unique name of this scenario.
    ///   - layout: Represents how the component should be laid out.
    ///   - file: A file path where defined this scenario.
    ///   - line: A line number where defined this scenario in file.
    ///   - content: A closure that make a new content.
    init<Content: View>(
        _ name: ScenarioName,
        layout: ScenarioLayout,
        file: StaticString = #file,
        line: UInt = #line,
        content: @escaping () -> Content
    ) {
        self.init(
            name,
            layout: layout,
            file: file,
            line: line,
            content: { _ in content() }
        )
    }
}

#endif
