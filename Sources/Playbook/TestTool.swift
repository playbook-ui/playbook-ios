/// Represents a tool for testing scenarios managed by playbooks.
public protocol TestTool {
    /// Runs testing for passed `Playbook` instance.
    ///
    /// - Parameters:
    ///   - playbook: A `Playbook` instance to be tested.
    func run(with playbook: Playbook) throws
}
