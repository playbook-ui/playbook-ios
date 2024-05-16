import PlaybookUI
import SwiftUI

@main
struct SamplePlaybookApp: App {
    enum Tab {
        case catalog
        case gallery
    }

    @State
    var tab = Tab.gallery

    init() {
        Playbook.default.add(AllScenarios.self)
    }

    var body: some Scene {
        WindowGroup {
            TabView(selection: $tab) {
                PlaybookGallery()
                    .tag(Tab.gallery)
                    .tabItem {
                        Image(systemName: "rectangle.grid.3x2")
                        Text("Gallery")
                    }

                PlaybookCatalog()
                    .tag(Tab.catalog)
                    .tabItem {
                        Image(systemName: "doc.text.magnifyingglass")
                        Text("Catalog")
                    }
            }
        }
    }
}
