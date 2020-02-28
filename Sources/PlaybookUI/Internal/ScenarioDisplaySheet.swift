import SwiftUI

internal struct ScenarioDisplaySheet: View {
    var data: SearchedData
    var onClose: () -> Void

    @EnvironmentObject
    private var store: GalleryStore

    @WeakReference
    private var contentUIView: UIView?

    init(
        data: SearchedData,
        onClose: @escaping () -> Void
    ) {
        self.data = data
        self.onClose = onClose
    }

    var body: some View {
        ZStack {
            ScenarioContentView(
                kind: data.kind,
                scenario: data.scenario,
                additionalSafeAreaInsets: .only(top: topBarHeight),
                contentUIView: _contentUIView
            )
                .edgesIgnoringSafeArea(.all)
                .background(
                    Color(.scenarioBackground)
                        .edgesIgnoringSafeArea(.all)
                )

            VStack(spacing: 0) {
                topBar()

                Divider()
                    .edgesIgnoringSafeArea(.all)

                Spacer.zero
            }
        }
            .sheet(item: $store.shareItem) { item in
                ImageSharingView(item: item) { self.store.shareItem = nil }
                    .edgesIgnoringSafeArea(.all)
            }
            .background(
                Color(.scenarioBackground)
                    .edgesIgnoringSafeArea(.all)
            )
    }
}

private extension ScenarioDisplaySheet {
    var topBarHeight: CGFloat { 44 }

    func topBar() -> some View {
        HStack(spacing: 0) {
            shareButton()

            Spacer(minLength: 24)

            Text(data.scenario.name.rawValue)
                .bold()
                .lineLimit(1)

            Spacer(minLength: 24)

            closeButton()
        }
            .padding(.horizontal, 24)
            .frame(height: topBarHeight)
            .background(
                Blur(style: .systemMaterial)
                    .edgesIgnoringSafeArea(.all),
                alignment: .topLeading
            )
    }

    func shareButton() -> some View {
        Button(action: share) {
            Image(symbol: .squareAndArrowUp)
                .imageScale(.large)
                .font(.headline)
                .foregroundColor(Color(.label))
        }
    }

    func closeButton() -> some View {
        Button(action: onClose) {
            ZStack {
                Color.gray.opacity(0.2)
                    .clipShape(Circle())
                    .frame(width: 30, height: 30)

                Image(symbol: .multiply)
                    .imageScale(.large)
                    .font(Font.subheadline.bold())
                    .foregroundColor(.gray)
            }
        }
    }

    func share() {
        guard let uiView = contentUIView else { return }

        let image = UIGraphicsImageRenderer(bounds: uiView.bounds).image { _ in
            uiView.drawHierarchy(in: uiView.bounds, afterScreenUpdates: true)
        }

        store.shareItem = ImageSharingView.Item(image: image)
    }
}
