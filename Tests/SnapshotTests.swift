import PlaybookSnapshot
import XCTest

@available(iOS 15.0, *)
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
                keyWindow: getKeyWindow(),
                devices: [
                    .iPhone15Pro(.portrait),
                    .iPhone15Pro(.landscape).style(.dark),
                    .iPhone13Mini(.portrait),
                    .iPadPro12_9(.landscape),
                ],
                viewPreprocessor: { view in
                    view.backgroundColor = .white
                    return view
                }
            )
        )
    }

    func getKeyWindow() -> UIWindow? {
        UIApplication.shared.connectedScenes
            .lazy
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)
    }
}
