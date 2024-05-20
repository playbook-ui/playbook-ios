import SwiftUI

@available(iOS 15.0, *)
internal struct CatalogBottomBar: View {
    let title: String?
    let primaryItemSymbol: Image.SFSymbols

    @EnvironmentObject
    private var catalogState: CatalogState
    @EnvironmentObject
    private var shareState: ShareState

    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .ignoresSafeArea()

            HStack(spacing: 0) {
                Button {
                    catalogState.isSearchPainCollapsed.toggle()
                } label: {
                    Image(symbol: primaryItemSymbol)
                        .imageStyle(font: .title2)
                        .padding(8)
                }

                Spacer.fixed(length: 8)

                if catalogState.selected != nil {
                    Button {
                        shareState.shareSnapshot()
                    } label: {
                        Image(symbol: .ellipsisCircle)
                            .imageStyle(font: .title2)
                            .padding(8)
                    }
                }

                Spacer(minLength: 0)

                if let title {
                    Text(title)
                        .textStyle(
                            font: .headline,
                            lineLimit: 1
                        )
                        .minimumScaleFactor(0.5)
                        .padding(.horizontal, 8)
                }

                Spacer(minLength: 8)

                ColorSchemePicker(colorScheme: $catalogState.colorScheme)
            }
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: 56)
        .background {
            MaterialView()
        }
    }
}
