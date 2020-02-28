import SwiftUI

internal struct ScenarioDisplayList: View {
    var data: SearchedListData
    var safeAreaInsets: EdgeInsets
    var onSelect: (SearchedData) -> Void

    @EnvironmentObject
    private var store: GalleryStore

    @Environment(\.galleryDependency)
    private var dependency

    private var serialDispatcher: SerialMainDispatcher

    init(
        data: SearchedListData,
        safeAreaInsets: EdgeInsets,
        serialDispatcher: SerialMainDispatcher,
        onSelect: @escaping (SearchedData) -> Void
    ) {
        self.data = data
        self.safeAreaInsets = safeAreaInsets
        self.serialDispatcher = serialDispatcher
        self.onSelect = onSelect
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(symbol: .bookmarkFill)
                    .imageScale(.medium)
                    .font(.system(size: 20))
                    .foregroundColor(Color(.primaryBlue))

                Text(data.kind.rawValue)
                    .foregroundColor(Color(.label))
                    .font(.system(size: 24))
                    .bold()
                    .background(Highlight(data.shouldHighlight))

                Spacer.zero
            }
                .padding(.horizontal, 24)
                .padding(.leading, safeAreaInsets.leading)
                .padding(.trailing, safeAreaInsets.trailing)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(data.scenarios) { data in
                        Button(
                            action: { self.onSelect(data) },
                            label: {
                                ScenarioDisplay(
                                    store: ScenarioDisplayStore(
                                        data: data,
                                        snapshotLoader: self.store.snapshotLoader,
                                        serialDispatcher: self.serialDispatcher,
                                        scheduler: self.dependency.scheduler
                                    )
                                )
                            }
                        )
                            .buttonStyle(ScaleButtonStyle())
                    }
                }
                    .padding(.horizontal, 24)
                    .padding(.leading, safeAreaInsets.leading)
                    .padding(.trailing, safeAreaInsets.trailing)
            }

            HorizontalSeparator()
        }
            .padding(.vertical, 8)
            .onDisappear(perform: serialDispatcher.cancel)
    }
}

private struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
