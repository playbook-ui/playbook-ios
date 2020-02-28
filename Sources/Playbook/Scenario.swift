import UIKit

/// Represents part of the component state.
public struct Scenario {
    /// An unique name of scenario that describes component and its state.
    public var name: ScenarioName

    /// Represents how the component should be laid out.
    public var layout: ScenarioLayout

    /// A file path where defined this scenario.
    public var file: StaticString

    /// A line number where defined this scenario in file.
    public var line: UInt

    /// A closure that make a new content with passed context.
    public var content: (ScenarioContext) -> ScenarioContent

    /// Creates a new scenario.
    ///
    /// - Parameters:
    ///   - name: An unique name of this scenario.
    ///   - layout: Represents how the component should be laid out.
    ///   - file: A file path where defined this scenario.
    ///   - line: A line number where defined this scenario in file.
    ///   - content: A closure that make a new content with passed context.
    public init(
        _ name: ScenarioName,
        layout: ScenarioLayout,
        file: StaticString = #file,
        line: UInt = #line,
        content: @escaping (ScenarioContext) -> ScenarioContent
    ) {
        self.name = name
        self.layout = layout
        self.file = file
        self.line = line
        self.content = content
    }

    /// Creates a new scenario.
    ///
    /// - Parameters:
    ///   - name: An unique name of this scenario.
    ///   - layout: Represents how the component should be laid out.
    ///   - file: A file path where defined this scenario.
    ///   - line: A line number where defined this scenario in file.
    ///   - content: A closure that make a new content.
    public init(
        _ name: ScenarioName,
        layout: ScenarioLayout,
        file: StaticString = #file,
        line: UInt = #line,
        content: @escaping () -> ScenarioContent
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
