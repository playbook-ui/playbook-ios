import Playbook
import XCTest

final class ScenarioContentTests: XCTestCase {
    func testUIView() {
        let view = UIView()
        let controller = view.makeUIViewController()

        XCTAssertEqual(view, controller.view)
    }

    func testUIViewController() {
        let controller0 = UIViewController()
        let controller1 = controller0.makeUIViewController()

        XCTAssertEqual(controller0, controller1)
    }
}
