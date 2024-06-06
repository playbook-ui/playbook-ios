import Playbook
import UIKit

/// The testing tool which generates snapshot images from scenarios managed by `Playbook`.
public struct Snapshot: TestTool {
    private let directory: URL
    private let clean: Bool
    private let format: SnapshotSupport.ImageFormat
    private let timeout: TimeInterval
    private let scale: CGFloat
    private let keyWindow: UIWindow?
    private let devices: [SnapshotDevice]
    private let logOutput: TextOutputStream?
    private let viewPreprocessor: ((UIView) -> UIView)?

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
    ///   - viewPreprocessor: A closure to preprocess scenario UIView before generating snapshot.
    public init(
        directory: URL,
        clean: Bool = false,
        format: SnapshotSupport.ImageFormat,
        timeout: TimeInterval = 600,
        scale: CGFloat = UIScreen.main.scale,
        keyWindow: UIWindow? = nil,
        devices: [SnapshotDevice],
        logOutput: TextOutputStream? = nil,
        viewPreprocessor: ((UIView) -> UIView)? = nil
    ) {
        self.directory = directory
        self.clean = clean
        self.format = format
        self.timeout = timeout
        self.scale = scale
        self.keyWindow = keyWindow
        self.devices = devices
        self.logOutput = logOutput
        self.viewPreprocessor = viewPreprocessor
    }

    /// Generates snapshot images for passed `Playbook` instance.
    ///
    /// - Parameters:
    ///   - playbook: A `Playbook` instance to be tested.
    public func run(with playbook: Playbook) throws {
        let timeoutTimestamp = Date.timeIntervalSinceReferenceDate + timeout
        let group = DispatchGroup()
        let fileManager = FileManager.default
        let directoryURL = URL(fileURLWithPath: directory.path, isDirectory: true)

        if clean && fileManager.fileExists(atPath: directoryURL.path) {
            try fileManager.removeItem(at: directoryURL)
        }

        var writingFailureURLs = [URL]()

        for device in devices {
            for store in playbook.stores {
                let directoryURL =
                    directoryURL
                    .appendingPathComponent(device.name, isDirectory: true)
                    .appendingPathComponent(normalize(store.category.rawValue), isDirectory: true)

                try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)

                for scenario in store.scenarios {
                    let fileURL =
                        directoryURL
                        .appendingPathComponent(normalize(scenario.title.rawValue))
                        .appendingPathExtension(format.fileExtension)

                    log(
                        """
                        Generating snapshot for:
                         - Device: \(device.name.rawString)
                         - Category: \(store.category.rawValue.rawString)
                         - Scenario: \(scenario.title.rawValue.rawString)
                        """
                    )

                    group.enter()

                    SnapshotSupport.data(
                        for: scenario,
                        on: device,
                        format: format,
                        scale: scale,
                        keyWindow: keyWindow,
                        viewPreprocessor: viewPreprocessor,
                        handler: { data in
                            do {
                                try data.write(to: fileURL)
                                log("Generated in \(fileURL.absoluteString)")
                            }
                            catch {
                                log(
                                    """
                                    Failed to write the snapshot in \(fileURL.absoluteString)
                                    Error: \(error)
                                    """
                                )
                                writingFailureURLs.append(fileURL)
                            }

                            group.leave()
                        }
                    )
                }
            }
        }

        let waiter = SnapshotWaiter()
        let awaitQueue = DispatchQueue(label: #file, qos: .default)
        let runLoop = RunLoop.current

        waiter.wait(until: .distantFuture)
        group.notify(queue: awaitQueue) {
            waiter.fulfill()
        }

        while waiter.isWaiting {
            let remaining = timeoutTimestamp - Date.timeIntervalSinceReferenceDate
            let timeIntervalToRun = min(0.1, remaining)

            if timeIntervalToRun <= 0 {
                try log(error: .timeout(timeout))
            }

            runLoop.run(mode: .default, before: Date(timeIntervalSinceNow: timeIntervalToRun))
        }

        if !writingFailureURLs.isEmpty {
            try log(error: .fileWritingFailure(urls: writingFailureURLs))
        }
    }
}

private extension Snapshot {
    static let nameNormalizationCharacters = CharacterSet(charactersIn: ".:/")
        .union(.whitespacesAndNewlines)
        .union(.illegalCharacters)
        .union(.controlCharacters)

    func normalize(_ string: String) -> String {
        string.components(separatedBy: Self.nameNormalizationCharacters).joined(separator: "_")
    }

    func log(error: SnapshotError) throws {
        log(error.debugDescription)
        throw error
    }

    func log(_ message: String) {
        let log = "[Playbook] \(message)"

        if var logOutput {
            logOutput.write(log)
        }
        else {
            print(log)
        }
    }
}

private extension String {
    var rawString: String {
        unicodeScalars.reduce(into: "") { $0 += $1.escaped(asASCII: true) }
    }
}
