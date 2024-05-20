import Playbook
import XCTest

final class ScenarioStoreTests: XCTestCase {
    func testScenariosOrder() {
        let store = ScenarioStore(category: "category")
        let first = Scenario("first", layout: .fill) { UIView() }
        let second = Scenario("second", layout: .fill) { UIView() }
        let third = Scenario("third", layout: .fill) { UIView() }

        store.add(first)
        store.add(second)
        store.add(third)

        XCTAssertEqual(
            store.scenarios.map { $0.title },
            [
                first.title,
                second.title,
                third.title,
            ]
        )
    }
}
