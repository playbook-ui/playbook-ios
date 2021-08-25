import Foundation

public enum SnapshotError: Error, CustomDebugStringConvertible {
    case timeout(TimeInterval)
    case fileWritingFailure(urls: [URL])

    public var debugDescription: String {
        switch self {
        case .timeout(let timeout):
            return "The snapshots were not taken within the given time (\(timeout)s)."

        case .fileWritingFailure(let urls):
            return """
                The snapshot image could not be written in the following destination.
                \(urls.lazy.map { "- \($0.absoluteString)" }.joined(separator: "\n"))
                """
        }
    }
}
