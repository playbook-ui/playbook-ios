import SwiftUI

@available(iOS 15, *)
internal struct CatalogCategoryRow: View {
    let data: SearchedCategoryData
    let isExpanded: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Image(uiImage: .logoMark)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 16)

                    Spacer.fixed(length: 8)

                    HighlightText(
                        content: data.category.rawValue,
                        range: data.highlightRange
                    )
                    .textStyle(font: .headline)

                    Spacer(minLength: 8)

                    Image(symbol: .chevronRight)
                        .imageStyle(
                            font: .caption,
                            color: Color(.secondaryLabel)
                        )
                        .rotationEffect(.radians(isExpanded ? .pi / 2 : 0))
                }
                .padding(16)

                Separator(height: 1)
            }
        }
        .buttonStyle(.borderless)
    }
}
