import SwiftUI

@available(iOS 15, *)
internal struct CatalogScenarioRow: View {
    let data: SearchedData
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Image(symbol: .circleFill)
                        .imageStyle(
                            font: .system(size: 8),
                            color: Color(isSelected ? .primaryBlue : .translucentFill)
                        )

                    Spacer.fixed(length: 8)

                    HighlightText(
                        content: data.scenario.title.rawValue,
                        range: data.highlightRange
                    )
                    .textStyle(font: .subheadline)

                    Spacer(minLength: 8)
                }
                .padding(16)

                Separator(height: 1)
            }
            .padding(.leading, 16)
        }
        .buttonStyle(.borderless)
    }
}
