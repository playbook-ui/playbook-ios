import SwiftUI

internal struct CatalogBarItem: View {
    var image: Image
    var insets: EdgeInsets
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            image
                .padding(8)
                .imageScale(.large)
                .foregroundColor(Color(.label))
                .padding(insets)
        }
    }
}
