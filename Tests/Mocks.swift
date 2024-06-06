import Playbook
import SwiftUI

@testable import PlaybookUI

extension Playbook {
    static let test: Playbook = {
        let playbok = Playbook()

        for categoryNumber in 1...3 {
            let store = playbok.scenarios(of: "Category \(categoryNumber)")

            for scenarioNumber in 1...3 {
                store.add(.stub("Scenario \(scenarioNumber)"))
            }
        }

        return playbok
    }()
}

extension SelectData {
    static func stub() -> Self {
        SelectData(category: "Category", scenario: .stub("Scenario"))
    }
}

extension SearchedData {
    static func stub(_ title: ScenarioTitle) -> Self {
        SearchedData(
            category: "Category",
            scenario: .stub(title),
            highlightRange: nil
        )
    }
}

extension SearchedCategoryData {
    static func stub(
        scenarios: [SearchedData] = (0..<3).map { .stub("Scenario \($0)") }
    ) -> Self {
        SearchedCategoryData(
            category: "Category",
            highlightRange: nil,
            scenarios: scenarios
        )
    }
}

extension Scenario {
    static func stub(_ title: ScenarioTitle) -> Self {
        Scenario(title, layout: .fill) {
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
