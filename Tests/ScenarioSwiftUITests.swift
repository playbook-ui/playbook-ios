import Playbook
import SwiftUI
import XCTest

final class ScenarioSwiftUITests: XCTestCase {
    @available(iOS 13.0, *)
    func testSwiftUI() {
        let scenario = Scenario(
            "title",
            layout: .fill,
            file: "file",
            line: 10,
            content: { Color.blue }
        )

        XCTAssertEqual(scenario.title, "title")
        XCTAssertEqual(scenario.layout, .fill)
        XCTAssertEqual(String(describing: scenario.file), "file")
        XCTAssertEqual(scenario.line, 10)
    }
}
