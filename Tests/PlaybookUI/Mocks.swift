import Playbook
import SwiftUI

@testable import PlaybookUI

struct SchedulerMock: SchedulerProtocol {
    func schedule(on queue: DispatchQueue, action: @escaping () -> Void) {
        action()
    }

    func schedule(on: DispatchQueue, after interval: TimeInterval, action: @escaping () -> Void) {
        action()
    }
}

final class SnapshotLoaderMock: SnapshotLoaderProtocol {
    let device: SnapshotDevice
    let takeSnapshotResult: Data
    let loadImageResult: Result<UIImage?, Error>

    init(
        device: SnapshotDevice,
        takeSnapshotResult: Data = Data(),
        loadImageResult: Result<UIImage?, Error> = .success(nil)
    ) {
        self.device = device
        self.takeSnapshotResult = takeSnapshotResult
        self.loadImageResult = loadImageResult
    }

    func takeSnapshot(for scenario: Scenario, kind: ScenarioKind, completion: ((Data) -> Void)?) {
        completion?(takeSnapshotResult)
    }

    func loadImage(kind: ScenarioKind, name: ScenarioName) -> Result<UIImage?, Error> {
        loadImageResult
    }

    func clean() {}
}

extension Playbook {
    static let test: Playbook = {
        let playbok = Playbook()

        for kindNumber in 1...3 {
            let store = playbok.scenarios(of: "Kind \(kindNumber)")

            for scenarioNumber in 1...3 {
                store.add(.stub("Scenario \(scenarioNumber)"))
            }
        }

        return playbok
    }()
}

extension SearchedData {
    static var stub: Self {
        SearchedData(
            scenario: .stub("Scenario 1"),
            kind: "Kind 1",
            shouldHighlight: false
        )
    }
}

extension Scenario {
    static func stub(_ name: ScenarioName) -> Self {
        Scenario(name, layout: .fill) {
            StubView()
        }
    }
}

private struct StubView: View {
    @Environment(\.horizontalSizeClass)
    var horizontalSizeClass

    @Environment(\.verticalSizeClass)
    var verticalSizeClass

    var body: some View {
        ZStack {
            Image(systemName: "sun.haze")
                .foregroundColor(.orange)
                .imageScale(.large)
                .font(.system(size: 150))

            VStack {
                Spacer()

                HStack {
                    Spacer()

                    Text("SizeClass: \(displayName(of: horizontalSizeClass)) x \(displayName(of: verticalSizeClass))")
                        .font(.headline)
                        .padding(16)
                }
            }
        }
    }

    func displayName(of sizeClass: UserInterfaceSizeClass?) -> String {
        switch sizeClass {
        case .compact:
            return "C"

        case .regular:
            return "R"

        case .none:
            return "unspecified"

        @unknown default:
            return "unknown"
        }
    }
}
