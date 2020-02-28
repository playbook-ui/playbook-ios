import Foundation

/// A snapshot timing manager to wait and fulfillment for the scenario
/// content to be rendered.
public final class SnapshotWaiter {
    /// Specifies whether currently waiting.
    public var isWaiting: Bool {
        timeout.map { $0 > .now() } ?? false
    }

    private var _timeout: DispatchTime?
    private let lock = NSLock()

    /// Wait for the snapshot for 10 seconds from now.
    public func wait() {
        wait(until: .now() + 10)
    }

    /// Wait for the snapshot until the specified timeout period.
    ///
    /// - Parameters:
    ///   - timeout: A timeout period for waiting the snapshot.
    public func wait(until timeout: DispatchTime) {
        self.timeout = timeout
    }

    /// Complete waiting for the snapshot.
    public func fulfill() {
        timeout = nil
    }

    /// Initialize a new waiter.
    public init() {}
}

internal extension SnapshotWaiter {
    func await() {
        while isWaiting {}
        fulfill()
    }
}

private extension SnapshotWaiter {
    private var timeout: DispatchTime? {
        get {
            lock.lock()
            defer { lock.unlock() }
            return _timeout
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            _timeout = newValue
        }
    }
}
