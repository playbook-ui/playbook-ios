import PlaybookUI
import SwiftUI

struct PlaybookView: View {
    enum Tab {
        case catalog
        case gallery
    }

    @State
    var tab = Tab.gallery

    var body: some View {
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
            .edgesIgnoringSafeArea(.top)
    }
}

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        Playbook.default.add(AllScenarios.self)

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: PlaybookView())

        self.window = window
        window.makeKeyAndVisible()
    }
}
