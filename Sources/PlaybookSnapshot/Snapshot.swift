import XCTest

/// The testing tool which generates snapshot images from scenarios managed by `Playbook`.
public struct Snapshot: TestTool {
    /// A context that holds output data, scenarios, and it's kind.
    public struct Context<Output> {
        /// The generated output data.
        public var output: Output

        /// The kind of the snapshotted scenario.
        public var scenarioKind: ScenarioKind

        /// The snapshotted scenario.
        public var scenario: Scenario

        /// Creates a new snapshot context.
        ///
        /// - Parameters:
        ///   - output: The generated output data.
        ///   - scenarioKind: The kind of the snapshotted scenario.
        ///   - scenario: The snapshotted scenario.
        public init(
            output: Output,
            scenarioKind: ScenarioKind,
            scenario: Scenario
        ) {
            self.output = output
            self.scenarioKind = scenarioKind
            self.scenario = scenario
        }
    }

    /// A timeout interval until the finish snapshot of all scenarios.
    public var timeout: TimeInterval

    /// A rendering scale of the snapshot image.
    public var scale: CGFloat

    /// The key window of the application.
    public weak var keyWindow: UIWindow?

    /// A set of snapshot environment simulating devices.
    public var devices: [SnapshotDevice]

    private var exportMethod: ExportMethod

    /// Creates a new snapshot tool for export all image files into specified directory.
    ///
    /// - Parameters:
    ///   - directory: A base directory for exporting snapshot image files.
    ///   - clean: Specifies whether that to clean directory before generating snapshots.
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
        self.timeout = timeout
        self.scale = scale
        self.keyWindow = keyWindow
        self.devices = devices
        self.exportMethod = .file(directory: directory, clean: clean, format: format)
    }

    /// Creates a new snapshot tool for handles generated image data with closure.
    ///
    /// - Parameters:
    ///   - format: An image file format of exported data.
    ///   - timeout: A timeout interval until the finish snapshot of all scenarios.
    ///   - scale: A rendering scale of the snapshot image.
    ///   - keyWindow: The key window of the application.
    ///   - devices: A set of snapshot environment simulating devices.
    ///   - handler: A closure that to handle generated data.
    public init(
        format: SnapshotSupport.ImageFormat,
        timeout: TimeInterval = 600,
        scale: CGFloat = UIScreen.main.scale,
        keyWindow: UIWindow? = nil,
        devices: [SnapshotDevice],
        handler: @escaping (Context<Data>) -> Void
    ) {
        self.timeout = timeout
        self.scale = scale
        self.keyWindow = keyWindow
        self.devices = devices
        self.exportMethod = .data(format: format, handler: handler)
    }

    /// Creates a new snapshot tool for handles generated `UIImage` with closure.
    ///
    /// - Parameters:
    ///   - timeout: A timeout interval until the finish snapshot of all scenarios.
    ///   - scale: A rendering scale of the snapshot image.
    ///   - keyWindow: The key window of the application.
    ///   - devices: A set of snapshot environment simulating devices.
    ///   - handler: A closure that to handle generated `UIImage`.
    public init(
        timeout: TimeInterval = 600,
        scale: CGFloat = UIScreen.main.scale,
        keyWindow: UIWindow? = nil,
        devices: [SnapshotDevice],
        handler: @escaping (Context<UIImage>) -> Void
    ) {
        self.timeout = timeout
        self.scale = scale
        self.keyWindow = keyWindow
        self.devices = devices
        self.exportMethod = .image(handler: handler)
    }

    /// Generates snapshot images for passed `Playbook` instance.
    ///
    /// - Parameters:
    ///   - playbook: A `Playbook` instance to be tested.
    public func run(with playbook: Playbook) throws {
        let expectation = XCTestExpectation(description: "Wait for done take all snapshots")
        let group = DispatchGroup()

        switch exportMethod {
        case .file(let directory, let clean, let format):
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

        case .data(let format, let handler):
            for device in devices {
                for store in playbook.stores {
                    for scenario in store.scenarios {
                        group.enter()
                        SnapshotSupport.data(
                            for: scenario,
                            on: device,
                            format: format,
                            scale: scale,
                            keyWindow: keyWindow,
                            handler: { data in
                                let context = Context(output: data, scenarioKind: store.kind, scenario: scenario)
                                handler(context)
                                group.leave()
                            }
                        )
                    }
                }
            }

        case .image(let handler):
            for device in devices {
                for store in playbook.stores {
                    for scenario in store.scenarios {
                        group.enter()
                        SnapshotSupport.image(
                            for: scenario,
                            on: device,
                            scale: scale,
                            keyWindow: keyWindow,
                            handler: { image in
                                let context = Context(output: image, scenarioKind: store.kind, scenario: scenario)
                                handler(context)
                                group.leave()
                            }
                        )
                    }
                }
            }
        }

        group.notify(queue: .main, execute: expectation.fulfill)
        XCTWaiter().wait(for: [expectation], timeout: timeout)
    }
}

private extension Snapshot {
    enum ExportMethod {
        case file(directory: URL, clean: Bool, format: SnapshotSupport.ImageFormat)
        case data(format: SnapshotSupport.ImageFormat, handler: (Context<Data>) -> Void)
        case image(handler: (Context<UIImage>) -> Void)
    }
}
