/// Represents an instance that can build an array of scenarios.
public protocol ScenariosBuildable {
    /// Builds an array of scenarios.
    func buildScenarios() -> [Scenario]
}

extension Scenario: ScenariosBuildable {
    /// Builds an array of scenarios containing only `self`.
    public func buildScenarios() -> [Scenario] { [self] }
}
