import Playbook
import SwiftUI

@available(iOS 15.0, *)
internal struct CatalogDrawer: View {
    @EnvironmentObject
    private var catalogState: CatalogState

    var body: some View {
        ZStack {
            CatalogTop()
            Drawer(isCollapsed: $catalogState.isSearchPainCollapsed)
        }
    }
}

@available(iOS 15.0, *)
private struct Drawer: View {
    @Binding
    var isCollapsed: Bool

    var body: some View {
        GeometryReader { geometry in
            let drawerWidth =
                geometry.safeAreaInsets.leading
                + min(
                    geometry.size.width * 0.8,
                    max(geometry.size.width, geometry.size.height) * 0.5
                )

            ZStack {
                Color.black
                    .opacity(isCollapsed ? 0 : 0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isCollapsed = true
                    }

                HStack(spacing: 0) {
                    CatalogSearchPane()
                        .frame(width: drawerWidth)
                        .background {
                            Rectangle()
                                .ignoresSafeArea()
                                .shadow(radius: 10)
                        }

                    Spacer.zero
                }
                .offset(x: isCollapsed ? -geometry.size.width : 0)
            }
            .animation(.smooth(duration: 0.3), value: isCollapsed)
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}
