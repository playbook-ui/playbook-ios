import PlaybookAccessibility
import XCTest

final class AccessibilitySnapshotTests: XCTestCase {
    func testTakeAccessibilitySnapshot() throws {
        guard let directory = ProcessInfo.processInfo.environment["SNAPSHOT_DIR_ACC"] else {
            fatalError("Set directory to the build environment variables with key `SNAPSHOT_DIR`.")
        }

        try Playbook.default.run(
            PlaybookAccessibilitySnapshot(
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
