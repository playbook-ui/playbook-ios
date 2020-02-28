import SwiftUI

internal struct HorizontalSeparator: View {
    var body: some View {
        Rectangle()
            .fill(Color(.quaternarySystemFill))
            .frame(height: 2)
            .fixedSize(horizontal: false, vertical: true)
    }
}
