import Playbook
import SwiftUI

@testable import PlaybookUI

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

extension SelectData {
    static func stub() -> Self {
        SelectData(kind: "Kind", scenario: .stub("Scenario"))
    }
}

extension SearchedData {
    static func stub(_ index: Int) -> Self {
        SearchedData(
            kind: "Kind",
            scenario: .stub("Scenario \(index)"),
            highlightRange: nil
        )
    }
}

extension SearchedKindData {
    static func stub(
        scenarios: [SearchedData] = (0..<3).map { .stub($0) }
    ) -> Self {
        SearchedKindData(
            kind: "Kind",
            highlightRange: nil,
            scenarios: scenarios
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
            Color(.systemBackground)

            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
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
