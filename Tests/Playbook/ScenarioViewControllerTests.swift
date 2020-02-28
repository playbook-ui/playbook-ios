import Playbook
import XCTest

final class ScenarioViewControllerTests: XCTestCase {
    func testShouldStatusBarHidden() {
        let controller = ScenarioViewController(context: .stub)
        controller.shouldStatusBarHidden = true
        XCTAssertTrue(controller.prefersStatusBarHidden)
    }

    func testContentViewController() {
        let controller = ScenarioViewController(context: .stub)
        let content = UIView()

        controller.scenario = Scenario("name", layout: .fill) {
            content
        }

        XCTAssertEqual(
            controller.contentViewController?.view.superview,
            controller.view
        )

        XCTAssertEqual(controller.contentViewController?.view, content)
    }

    func testLayout() {
        func assert(
            intrinsicSize: CGSize?,
            actualSize: CGSize?,
            layout: ScenarioLayout,
            file: StaticString = #file,
            line: UInt = #line
        ) {
            let controller = ScenarioViewController(context: .stub)

            controller.scenario = Scenario("name", layout: layout) {
                IntrinsicSizeView(intrinsicSize)
            }
            controller.view.layoutIfNeeded()

            XCTAssertEqual(
                actualSize ?? intrinsicSize ?? controller.view.bounds.size,
                controller.contentViewController?.view.bounds.size,
                file: file,
                line: line
            )
        }

        assert(
            intrinsicSize: nil,
            actualSize: nil,
            layout: .fill
        )
        assert(
            intrinsicSize: CGSize(width: 100, height: 200),
            actualSize: nil,
            layout: .compressed
        )
        assert(
            intrinsicSize: CGSize(width: 100, height: 200),
            actualSize: CGSize(width: 300, height: 400),
            layout: .fixed(width: 300, height: 400)
        )
    }
}

private extension ScenarioContext {
    static var stub: ScenarioContext {
        ScenarioContext(
            snapshotWaiter: SnapshotWaiter(),
            isSnapshot: false,
            screenSize: .zero
        )
    }
}

private final class IntrinsicSizeView: UIView {
    let intrinsicSize: CGSize?

    init(_ intrinsicSize: CGSize?) {
        self.intrinsicSize = intrinsicSize
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        intrinsicSize ?? super.intrinsicContentSize
    }
}
