import SwiftUI

@available(iOS 15.0, *)
internal struct GalleryDetail: View {
    let data: SelectData

    @StateObject
    private var shareState = ShareState()

    var body: some View {
        ZStack {
            ScenarioContentView(
                scenario: data.scenario,
                additionalSafeAreaInsets: UIEdgeInsets(
                    top: 56,
                    left: .zero,
                    bottom: .zero,
                    right: .zero
                ),
                shareState: shareState
            )
            .ignoresSafeArea()
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            GalleryDetailTopBar(title: data.scenario.title.rawValue) {
                shareState.shareSnapshot()
            }
        }
        .background {
            Color(.background)
                .ignoresSafeArea()
        }
    }
}
