#if canImport(SwiftUI) && canImport(Combine)

import SwiftUI
import Playbook
import XCTest

final class ScenarioSwiftUITests: XCTestCase {
    @available(iOS 13.0, *)
    func testSwiftUI() {
        let scenario = Scenario("name", layout: .fill) {
            Color.blue
        }

        let context = ScenarioContext(
            snapshotWaiter: SnapshotWaiter(),
            isSnapshot: false,
            screenSize: .zero
        )
        let controller = scenario.content(context).makeUIViewController()

        XCTAssertTrue(controller is UIHostingController<Color>)
        XCTAssertEqual((controller as? UIHostingController<Color>)?.rootView, .blue)
    }
}

#endif
