import CoreGraphics

/// The context of scenario.
public struct ScenarioContext {
    /// The waiter that controls snapshot to wait until content did finished rendering.
    public var snapshotWaiter: SnapshotWaiter

    /// Specifies whether that currently in snapshotting context.
    public var isSnapshot: Bool

    /// The size of screen or snapshotting device.
    public var screenSize: CGSize { getScreenSize() }

    private var getScreenSize: () -> CGSize

    /// Creates a new context.
    ///
    /// - Parameters:
    ///   - snapshotWaiter: The waiter that controls snapshot to wait until
    ///                      content did finished rendering.
    ///   - isSnapshot: Specifies whether that currently in snapshotting context.
    ///   - screenSize: The size of screen or snapshotting device.
    public init(
        snapshotWaiter: SnapshotWaiter,
        isSnapshot: Bool,
        screenSize: @autoclosure @escaping () -> CGSize
    ) {
        self.snapshotWaiter = snapshotWaiter
        self.isSnapshot = isSnapshot
        self.getScreenSize = screenSize
    }
}
