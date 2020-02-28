import SwiftUI

internal protocol SnapshotLoaderProtocol {
    var device: SnapshotDevice { get }

    func takeSnapshot(for scenario: Scenario, kind: ScenarioKind, completion: ((Data) -> Void)?)
    func loadImage(kind: ScenarioKind, name: ScenarioName) -> Result<UIImage?, Error>
    func clean()
}

internal final class SnapshotLoader: SnapshotLoaderProtocol {
    let name: String
    let baseDirectoryURL: URL
    let format: SnapshotSupport.ImageFormat
    let device: SnapshotDevice

    var directoryURL: URL {
        baseDirectoryURL.appendingPathComponent(name, isDirectory: true)
    }

    init(
        name: String,
        baseDirectoryURL: URL,
        format: SnapshotSupport.ImageFormat,
        device: SnapshotDevice
    ) {
        self.baseDirectoryURL = baseDirectoryURL
        self.name = name
        self.format = format
        self.device = device
    }

    func takeSnapshot(for scenario: Scenario, kind: ScenarioKind, completion: ((Data) -> Void)?) {
        SnapshotSupport.data(
            for: scenario,
            on: device,
            format: format,
            scale: 1,
            handler: { [weak self] data in
                self?.storeImage(data: data, kind: kind, name: scenario.name)
                completion?(data)
            }
        )
    }

    func loadImage(kind: ScenarioKind, name: ScenarioName) -> Result<UIImage?, Error> {
        Result {
            let fileURL = self.fileURL(kind: kind, name: name)

            if FileManager.default.fileExists(atPath: fileURL.path) {
                let data = try Data(contentsOf: fileURL)
                return UIImage(data: data)
            }
            else {
                return nil
            }
        }
    }

    func clean() {
        if FileManager.default.fileExists(atPath: directoryURL.path) {
            try? FileManager.default.removeItem(at: directoryURL)
        }
    }
}

private extension SnapshotLoader {
    func fileURL(kind: ScenarioKind, name: ScenarioName) -> URL {
        directoryURL
            .appendingPathComponent(kind.rawValue, isDirectory: true)
            .appendingPathComponent(name.rawValue)
            .appendingPathExtension(format.fileExtension)
    }

    func storeImage(data: Data, kind: ScenarioKind, name: ScenarioName) {
        let fileManager = FileManager.default
        let fileURL = self.fileURL(kind: kind, name: name)
        let kindDirectoryURL = fileURL.deletingLastPathComponent()

        if !fileManager.fileExists(atPath: kindDirectoryURL.path) {
            try? fileManager.createDirectory(at: kindDirectoryURL, withIntermediateDirectories: true)
        }

        try? data.write(to: fileURL)
    }
}
