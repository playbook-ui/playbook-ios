import UIKit

/// The central scenario manager.
///
/// You can use the singleton `default` or use it
/// with instantiate arbitrarily.
///
///     struct Content: View {
///         var body: some View {
///             Text("Playbook")
///         }
///     }
///
///     Playbook.default.addScenarios(of: "Components") {
///         Scenario("Content", layout: .compressed) {
///             Content()
///         }
///     }
open class Playbook {
    /// The default shared instance of `Playbook`.
    public static let `default` = Playbook()

    /// A set of stores that holds the added scenarios.
    public var stores: [ScenarioStore] {
        Array(storage)
    }

    private var storage = OrderedStorage<ScenarioCategory, ScenarioStore>()

    /// Initialize a new `Playbook`.
    public init() {}

    /// Returns a store identified by specified category.
    ///
    /// If there is no store yet, add and return it.
    ///
    /// - Parameters:
    ///   - category: A unique identifier that stores a set of scenarios.
    ///
    /// - Returns: A store identified by specified category.
    public func scenarios(of category: ScenarioCategory) -> ScenarioStore {
        storage.element(for: category, default: ScenarioStore(category: category))
    }

    /// Adds a set scenarios defined in specified provider.
    ///
    /// - Parameters:
    ///   - provider: A type of provider that provides a set of scenarios.
    ///
    /// - Returns: A instance of `self`.
    @discardableResult
    public func add<Provider: ScenarioProvider>(_ provider: Provider.Type) -> Self {
        provider.addScenarios(into: self)
        return self
    }

    /// Adds a set of scenarios passed by function builder.
    ///
    /// - Parameters:
    ///   - category: A unique identifier that stores a set of scenarios.
    ///   - scenarios: A function builder that create a set of scenarios.
    ///
    /// - Returns: A instance of `self`.
    @discardableResult
    public func addScenarios<S: ScenariosBuildable>(of category: ScenarioCategory, @ScenariosBuilder _ scenarios: () -> S) -> Self {
        let store = self.scenarios(of: category)

        for scenario in scenarios().buildScenarios() {
            store.add(scenario)
        }

        return self
    }

    /// Serialy runs specified tests conform to `TestTool` protocol.
    ///
    /// - Parameters:
    ///   - test: The first test to be run.
    ///   - tests: The trailing tests to be run in order.
    public func run(_ test: TestTool, _ tests: TestTool...) throws {
        let tests = [test] + tests

        for test in tests {
            try test.run(with: self)
        }
    }
}
