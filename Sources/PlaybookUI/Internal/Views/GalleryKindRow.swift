import SwiftUI

@available(iOS 15.0, *)
internal struct GalleryKindRow: View {
    let data: SearchedKindData
    let onSelect: (SearchedData) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 8) {
                Image(uiImage: .logoMark)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 16)

                HighlightText(
                    content: data.kind.rawValue,
                    range: data.highlightRange
                )
                .textStyle(font: .headline)
            }
            .padding(.top, 16)
            .padding(.horizontal, 24)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 0) {
                    ForEach(data.scenarios, id: \.scenario.name) { data in
                        Button {
                            onSelect(data)
                        } label: {
                            GalleryThumbnail(data: data)
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
                .padding(12)
            }

            Separator(height: 2)
        }
    }
}

private struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.snappy(duration: 0.2), value: configuration.isPressed)
    }
}
