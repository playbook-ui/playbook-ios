import PlaybookSnapshot
import XCTest

final class SnapshotTests: XCTestCase {
    func testTakeSnapshot() throws {
        guard let directory = ProcessInfo.processInfo.environment["SNAPSHOT_DIR"] else {
            fatalError("Set directory to the build environment variables with key `SNAPSHOT_DIR`.")
        }

        try Playbook.default.run(
            Snapshot(
                directory: URL(fileURLWithPath: directory),
                clean: true,
                format: .png,
                scale: 1,
                keyWindow: UIApplication.shared.windows.first { $0.isKeyWindow },
                devices: [.iPhone11Pro(.portrait)]
            )
        )
    }
}
