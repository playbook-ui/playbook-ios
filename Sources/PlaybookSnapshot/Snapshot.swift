import XCTest

/// The testing tool which generates snapshot images from scenarios managed by `Playbook`.
public struct Snapshot: TestTool {
    /// A base directory for exporting snapshot image files.
    public var directory: URL

    /// Specifies whether that to clean directory before generating snapshots.
    public var clean: Bool

    /// An image file format of exported data.
    public var format: SnapshotSupport.ImageFormat

    /// A timeout interval until the finish snapshot of all scenarios.
    public var timeout: TimeInterval

    /// A rendering scale of the snapshot image.
    public var scale: CGFloat

    /// The key window of the application.
    public weak var keyWindow: UIWindow?

    /// A set of snapshot environment simulating devices.
    public var devices: [SnapshotDevice]

    /// Creates a new snapshot tool for export all image files into specified directory.
    ///
    /// - Parameters:
    ///   - directory: A base directory for exporting snapshot image files.
    ///   - clean: Specifies whether to clean directory before generating snapshots.
    ///   - format: An image file format of exported data.
    ///   - timeout: A timeout interval until the finish snapshot of all scenarios.
    ///   - scale: A rendering scale of the snapshot image.
    ///   - keyWindow: The key window of the application.
    ///   - devices: A set of snapshot environment simulating devices.
    public init(
        directory: URL,
        clean: Bool = false,
        format: SnapshotSupport.ImageFormat,
        timeout: TimeInterval = 600,
        scale: CGFloat = UIScreen.main.scale,
        keyWindow: UIWindow? = nil,
        devices: [SnapshotDevice]
    ) {
        self.directory = directory
        self.clean = clean
        self.format = format
        self.timeout = timeout
        self.scale = scale
        self.keyWindow = keyWindow
        self.devices = devices
    }

    /// Generates snapshot images for passed `Playbook` instance.
    ///
    /// - Parameters:
    ///   - playbook: A `Playbook` instance to be tested.
    public func run(with playbook: Playbook) throws {
        let expectation = XCTestExpectation(description: "Wait for done take all snapshots")
        let group = DispatchGroup()

        let fileManager = FileManager.default

        let directoryURL = URL(fileURLWithPath: directory.path, isDirectory: true)

        if clean && fileManager.fileExists(atPath: directoryURL.path) {
            try fileManager.removeItem(at: directoryURL)
        }

        for device in devices {
            for store in playbook.stores {
                let directoryURL =
                    directoryURL
                    .appendingPathComponent(device.name, isDirectory: true)
                    .appendingPathComponent(store.kind.rawValue, isDirectory: true)
                try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)

                func attemptToWrite(data: Data, scenario: Scenario) {
                    let fileURL =
                        directoryURL
                        .appendingPathComponent(scenario.name.rawValue)
                        .appendingPathExtension(format.fileExtension)

                    XCTAssertNoThrow(try data.write(to: fileURL), file: scenario.file, line: scenario.line)
                }

                for scenario in store.scenarios {
                    group.enter()

                    SnapshotSupport.data(
                        for: scenario,
                        on: device,
                        format: format,
                        scale: scale,
                        keyWindow: keyWindow,
                        handler: { data in
                            attemptToWrite(data: data, scenario: scenario)
                            group.leave()
                        }
                    )
                }
            }
        }

        group.notify(queue: .main, execute: expectation.fulfill)
        XCTWaiter().wait(for: [expectation], timeout: timeout)
    }
}
