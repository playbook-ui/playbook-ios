/// The class for managing a set of scenarios identified by the arbitrary category.
public final class ScenarioStore {
    /// A unique identifier of the secenarios managed by this instance.
    public let category: ScenarioCategory

    private var storage = OrderedStorage<ScenarioTitle, Scenario>()

    /// The set of scenarios managed by this store.
    public var scenarios: [Scenario] {
        Array(storage)
    }

    /// Initialize a new store with given category.
    ///
    /// - Parameters:
    ///   - category: A unique identifier of the secenarios managed by this instance.
    public init(category: ScenarioCategory) {
        self.category = category
    }

    /// Adds a scenario to this store instance.
    ///
    /// - Parameters:
    ///   - scenario: The scenario to be added to this instance.
    ///
    /// - Returns: A instance of `self`.
    @discardableResult
    public func add(_ scenario: Scenario) -> Self {
        storage.append(scenario, for: scenario.title)
        return self
    }
}
