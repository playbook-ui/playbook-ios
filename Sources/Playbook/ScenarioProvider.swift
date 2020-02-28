/// Products a group of separated scenario definitions.
///
///     struct UserScenarios: ScenarioProvider {
///         static func addScenarios(into playbook: Playbook) {
///             playbook.addScenarios(of: "User") {
///                 Scenario("signed in", layout: .compressed) {
///                     UserView(name: "John", isSignedIn: true)
///                 }
///
///                 Scenario("signed out", layout: .compressed) {
///                     UserView(name: "Jane", isSignedIn: false)
///                 }
///             }
///         }
///     }
public protocol ScenarioProvider {
    /// The function to defines a group of scenarios.
    ///
    /// - Parameters:
    ///   - playbook: A `Playbook` instance to be added the scenarios.
    static func addScenarios(into playbook: Playbook)
}
