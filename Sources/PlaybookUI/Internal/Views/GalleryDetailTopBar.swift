import SwiftUI

@available(iOS 15.0, *)
internal struct GalleryDetailTopBar: View {
    let title: String
    let share: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Button(action: share) {
                    Image(symbol: .ellipsisCircle)
                        .imageStyle(font: .title2)
                }

                Spacer(minLength: 16)

                Text(title)
                    .textStyle(font: .headline, lineLimit: 1)

                Spacer(minLength: 16)

                CloseButton()
            }
            .padding(.horizontal, 16)
            .frame(maxHeight: .infinity)

            Divider()
                .ignoresSafeArea()
        }
        .frame(height: 56)
        .background {
            MaterialView()
        }
    }
}

@available(iOS 15.0, *)
private struct CloseButton: View {
    @Environment(\.dismiss)
    private var dismiss

    var body: some View {
        Button {
            dismiss()
        } label: {
            ZStack {
                Circle()
                    .fill(Color(.translucentFill))
                    .frame(width: 30, height: 30)

                Image(symbol: .xmark)
                    .imageStyle(
                        font: .subheadline.weight(.bold),
                        color: Color(.secondaryLabel)
                    )
            }
        }
    }
}
