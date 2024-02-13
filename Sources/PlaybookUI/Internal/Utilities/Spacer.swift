import SwiftUI

internal extension Spacer {
    static var zero: Spacer {
        Spacer(minLength: 0)
    }

    static func fixed(length: CGFloat) -> some View {
        Spacer(minLength: length).fixedSize()
    }
}
