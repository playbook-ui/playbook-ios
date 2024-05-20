import Playbook
import SwiftUI

internal struct ImageCache {
    private let fileManager = FileManager.default

    func data(for source: ImageSource) -> Data? {
        let url = fileURL(for: source)

        do {
            if fileManager.fileExists(atPath: url.path) {
                return try Data(contentsOf: url)
            }
            else {
                return nil
            }
        }
        catch {
            debugLog(error: error, description: "Failed to read cache data.")
            remove(at: url)
            return nil
        }
    }

    func create(file: Data, for source: ImageSource) {
        do {
            let fileURL = fileURL(for: source)
            let directoryURL = fileURL.deletingPathExtension()

            if !fileManager.fileExists(atPath: directoryURL.path) {
                try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
            }

            try file.write(to: fileURL)
        }
        catch {
            debugLog(error: error, description: "Failed to create cache data.")
        }
    }

    func clear() {
        let url = baseDirectoryURL()
        remove(at: url)
    }
}

private extension ImageCache {
    static let normalizationCharacters = CharacterSet(charactersIn: ".:/")
        .union(.whitespacesAndNewlines)
        .union(.illegalCharacters)
        .union(.controlCharacters)

    func baseDirectoryURL() -> URL {
        fileManager
            .urls(for: .cachesDirectory, in: .userDomainMask).first!
            .appendingPathComponent("app.playbook-ui", isDirectory: true)
    }

    func fileURL(for source: ImageSource) -> URL {
        baseDirectoryURL()
            .appendingPathComponent("images", isDirectory: true)
            .appendingPathComponent(source.size.width.description, isDirectory: true)
            .appendingPathComponent(source.size.height.description, isDirectory: true)
            .appendingPathComponent(source.scale.description, isDirectory: true)
            .appendingPathComponent("\(source.colorScheme)", isDirectory: true)
            .appendingPathComponent(normalize(source.category.rawValue), isDirectory: true)
            .appendingPathComponent(normalize(source.scenario.title.rawValue))
            .appendingPathExtension(SnapshotSupport.ImageFormat.png.fileExtension)
    }

    func remove(at url: URL) {
        guard fileManager.fileExists(atPath: url.path) else {
            return
        }

        do {
            try fileManager.removeItem(at: url)
        }
        catch {
            debugLog(error: error, description: "Failed to clear cache data.")
        }
    }

    func normalize(_ string: String) -> String {
        string.components(separatedBy: Self.normalizationCharacters).joined(separator: "_")
    }

    func debugLog(error: @autoclosure () -> Error, description: @autoclosure () -> String) {
        #if DEBUG
        print("[Playbook]", description(), error())
        #endif
    }
}
