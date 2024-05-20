import SwiftUI

internal struct Separator: View {
    let height: CGFloat

    var body: some View {
        Rectangle()
            .fill(Color(.translucentFill))
            .frame(height: height)
            .padding(.leading, 16)
            .fixedSize(horizontal: false, vertical: true)
    }
}
