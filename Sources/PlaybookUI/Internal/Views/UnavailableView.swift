import SwiftUI

@available(iOS 15.0, *)
internal struct UnavailableView: View {
    let symbol: Image.SFSymbols
    let description: String

    var body: some View {
        VStack(spacing: 16) {
            Image(symbol: symbol)
                .imageStyle(
                    font: .largeTitle,
                    color: Color(.secondaryLabel)
                )

            Text(description)
                .textStyle(font: .headline)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 40)
        .padding(.horizontal, 24)
    }
}
