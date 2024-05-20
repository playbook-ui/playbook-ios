import SwiftUI
import SampleComponent

@main
struct SampleApp: App {
    var body: some Scene {
        WindowGroup {
            CategoryHome()
                .environmentObject(UserData())
        }
    }
}
