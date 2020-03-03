import PlaybookSnapshot
import XCTest

final class SnapshotTests: XCTestCase {
    func testTakeSnapshot() throws {
        guard let directory = ProcessInfo.processInfo.environment["SNAPSHOT_DIR"] else {
            fatalError("Set directory to the build environment variables with key `SNAPSHOT_DIR`.")
        }

        Playbook.default.add(AllScenarios.self)

        try Playbook.default.run(
            Snapshot(
                directory: URL(fileURLWithPath: directory),
                clean: true,
                format: .png,
                scale: 1,
                keyWindow: UIApplication.shared.windows.first { $0.isKeyWindow },
                devices: [
                    .iPhone11Pro(.portrait),
                    .iPhone11Pro(.portrait, style: .dark),
                    .iPhone11Pro(.landscape, style: .dark),
                    .iPhoneSE(.portrait),
                    .iPhoneSE(.landscape),
                    .iPadPro12_9(.portrait),
                    .iPadPro12_9(.landscape, style: .dark),
                ]
            )
        )
    }
}
