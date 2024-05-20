import Playbook
import XCTest

final class PlaybookTests: XCTestCase {
    func testScenarios() {
        let playbook = Playbook()
        let first = playbook.scenarios(of: "category")
        let second = playbook.scenarios(of: "category")
        XCTAssertEqual(ObjectIdentifier(first), ObjectIdentifier(second))
    }

    func testScenariosOrder() {
        let playbook = Playbook()
        let first = playbook.scenarios(of: "first")
        let second = playbook.scenarios(of: "second")
        let third = playbook.scenarios(of: "third")

        XCTAssertEqual(
            playbook.stores.map { $0.category },
            [
                first.category,
                second.category,
                third.category,
            ]
        )
    }

    func testAddProvider() {
        struct TestProvider: ScenarioProvider {
            static func addScenarios(into playbook: Playbook) {
                playbook
                    .scenarios(of: "category")
                    .add(Scenario("title", layout: .fill) { UIView() })
            }
        }

        let playbook = Playbook()
        playbook.add(TestProvider.self)

        let scenario = playbook.scenarios(of: "category").scenarios.first
        XCTAssertEqual(scenario?.title, "title")
    }

    func testAddScenarios() {
        let playbook = Playbook()
        let scenario0 = Scenario("0", layout: .fill) { UIView() }
        let scenario1 = Scenario("1", layout: .fill) { UIView() }

        playbook.addScenarios(of: "category") {
            scenario0
            scenario1
        }

        let store = playbook.scenarios(of: "category")

        XCTAssertEqual(store.scenarios.count, 2)
        XCTAssertEqual(store.scenarios[0].title, scenario0.title)
        XCTAssertEqual(store.scenarios[1].title, scenario1.title)
    }

    func testRunTestTools() throws {
        final class TestTestTool: TestTool {
            var playbookIdentifier: ObjectIdentifier?

            func run(with playbook: Playbook) throws {
                playbookIdentifier = ObjectIdentifier(playbook)
            }
        }

        let playbook = Playbook()
        let playbookIdentifier = ObjectIdentifier(playbook)
        let tool0 = TestTestTool()
        let tool1 = TestTestTool()
        let tool2 = TestTestTool()

        try playbook.run(tool0, tool1, tool2)

        XCTAssertEqual(tool0.playbookIdentifier, playbookIdentifier)
        XCTAssertEqual(tool1.playbookIdentifier, playbookIdentifier)
        XCTAssertEqual(tool2.playbookIdentifier, playbookIdentifier)
    }
}
