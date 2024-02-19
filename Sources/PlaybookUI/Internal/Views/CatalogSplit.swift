import Playbook
import SwiftUI

@available(iOS 15.0, *)
internal struct CatalogSplit: View {
    @EnvironmentObject
    private var catalogState: CatalogState

    var body: some View {
        GeometryReader { geometry in
            let sidebarWidth = geometry.size.width * 0.4

            ZStack(alignment: .leading) {
                HStack(spacing: 0) {
                    CatalogSearchPane()
                    Divider()
                        .ignoresSafeArea()
                }
                .frame(width: sidebarWidth)
                .offset(x: catalogState.isSearchPainCollapsed ? -sidebarWidth / 2 : 0)

                HStack(spacing: 0) {
                    Spacer.fixed(length: catalogState.isSearchPainCollapsed ? 0 : sidebarWidth)
                    CatalogTop()
                        .transformEnvironment(\.horizontalSizeClass) { sizeClass in
                            if !catalogState.isSearchPainCollapsed {
                                sizeClass = .compact
                            }
                        }
                }
            }
        }
        .animation(.smooth(duration: 0.3), value: catalogState.isSearchPainCollapsed)
    }
}
