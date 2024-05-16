import Playbook
import SwiftUI

@available(iOS 15.0, *)
internal struct CatalogDrawer: View {
    var body: some View {
        ZStack {
            CatalogTop()
            Drawer()
        }
    }
}

@available(iOS 15.0, *)
private struct Drawer: View {
    @EnvironmentObject
    private var catalogState: CatalogState

    var body: some View {
        let isCollapsed = catalogState.isSearchPainCollapsed

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
                        catalogState.isSearchPainCollapsed = true
                    }

                HStack(spacing: 0) {
                    CatalogSearchPane { data in
                        catalogState.selected = data
                        catalogState.isSearchPainCollapsed = true
                    }
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
