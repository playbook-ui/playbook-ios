import SwiftUI

internal struct Highlight: View {
    var isHighlighted: Bool

    init(_ isHighlighted: Bool) {
        self.isHighlighted = isHighlighted
    }

    var body: some View {
        Group {
            if isHighlighted {
                Color(.highlight)
            }
        }
    }
}
