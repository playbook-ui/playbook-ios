import Playbook
import SwiftUI

@available(iOS 15.0, *)
internal struct PlaybookGalleryContent: View {
    let title: String?

    @EnvironmentObject
    private var searchState: SearchState
    @EnvironmentObject
    private var galleryState: GalleryState
    @EnvironmentObject
    private var imageLoader: ImageLoader
    @FocusState
    private var isFocused

    var body: some View {
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

                    if searchState.result.categories.isEmpty {
                        UnavailableView(
                            symbol: .magnifyingglass,
                            description: "No Result for \"\(searchState.query)\""
                        )
                    }
                    else {
                        ForEach(searchState.result.categories, id: \.category) { data in
                            GalleryCategoryRow(data: data) { selected in
                                galleryState.selected = SelectData(
                                    category: selected.category,
                                    scenario: selected.scenario
                                )
                            }
                        }
                    }

                    Spacer.fixed(length: 24)
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
                Color(.background)
                    .ignoresSafeArea()
            }
            .ignoresSafeArea(.keyboard)
            .sheet(item: $galleryState.selected) { data in
                GalleryDetail(data: data)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Menu {
                            Button("Clear Thumbnail Cache") {
                                galleryState.clearImageCache()
                            }
                        } label: {
                            Image(symbol: .ellipsisCircle)
                                .imageStyle(font: .subheadline)
                        }

                        ColorSchemePicker(colorScheme: $galleryState.colorScheme)
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
        .preferredColorScheme(galleryState.colorScheme)
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
