/// The class for managing a set of scenarios identified by the arbitrary kind.
public final class ScenarioStore {
    /// An unique identifier of the secenarios managed by this instance.
    public let kind: ScenarioKind

    private var storage = OrderedStorage<ScenarioName, Scenario>()

    /// The set of scenarios managed by this store.
    public var scenarios: [Scenario] {
        Array(storage)
    }

    /// Initialize a new store with given kind.
    ///
    /// - Parameters:
    ///   - kind: An unique identifier of the secenarios managed by this instance.
    public init(kind: ScenarioKind) {
        self.kind = kind
    }

    /// Adds a scenario to this store instance.
    ///
    /// - Parameters:
    ///   - scenario: The scenario to be added to this instance.
    ///
    /// - Returns: A instance of `self`.
    @discardableResult
    public func add(_ scenario: Scenario) -> Self {
        storage.append(scenario, for: scenario.name)
        return self
    }
}
