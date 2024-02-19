import Playbook
import SwiftUI

@available(iOS 15.0, *)
public struct PlaybookGallery: View {
    private let title: String?

    @StateObject
    private var searchState: SearchState
    @StateObject
    private var galleryState = GalleryState()
    @StateObject
    private var imageLoader = ImageLoader()
    @FocusState
    private var isFocused

    public init(
        title: String? = nil,
        playbook: Playbook = .default
    ) {
        self.title = title
        self._searchState = StateObject(wrappedValue: SearchState(playbook: playbook))
    }

    public var body: some View {
        NavigationView {
            List {
                Group {
                    Spacer.fixed(length: 16)
                    SearchBar(text: $searchState.query)
                        .focused($isFocused)

                    Counter(
                        count: searchState.result.count,
                        total: searchState.result.total
                    )
                    .onDisappear {
                        isFocused = false
                    }

                    if searchState.result.kinds.isEmpty {
                        UnavailableView(
                            symbol: .magnifyingglass,
                            description: "No Result for \"\(searchState.query)\""
                        )
                    }
                    else {
                        ForEach(searchState.result.kinds, id: \.kind) { data in
                            GalleryKindRow(data: data) { selected in
                                galleryState.selected = SelectData(
                                    kind: selected.kind,
                                    scenario: selected.scenario
                                )
                            }
                        }
                    }

                    Rectangle()
                        .fill(.clear)
                        .frame(height: 24)
                        .frame(maxWidth: .infinity)
                        .contextMenu {
                            Button {
                                galleryState.clearImageCache()
                            } label: {
                                Text("Clear image cache")
                            }
                        }
                }
                .listRowSpacing(.zero)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .transition(.identity)
            }
            .listStyle(.plain)
            .environment(\.defaultMinListRowHeight, 0)
            .navigationTitleIfPresent(title)
            .background {
                Color(.primaryBackground)
                    .ignoresSafeArea()
            }
            .ignoresSafeArea(.keyboard)
            .sheet(item: $galleryState.selected) { data in
                GalleryDetail(data: data)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ColorSchemePicker(colorScheme: $galleryState.colorScheme)
                }
            }
        }
        .navigationViewStyle(.stack)
        .preferredColorScheme(galleryState.colorScheme)
        .environmentObject(imageLoader)
    }
}

@available(iOS 14.0, *)
private extension View {
    @ViewBuilder
    func navigationTitleIfPresent<S: StringProtocol>(_ title: S?) -> some View {
        if let title {
            navigationTitle(title)
        }
        else {
            self
        }
    }
}
