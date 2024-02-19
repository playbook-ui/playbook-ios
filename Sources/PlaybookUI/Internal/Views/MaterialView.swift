import SwiftUI

@available(iOS 15.0, *)
internal struct MaterialView: View {
    var body: some View {
        Rectangle()
            .fill(Material.bar)
            .ignoresSafeArea()
    }
}
