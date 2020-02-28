import SwiftUI

internal struct Counter: View, Equatable {
    var numerator: Int
    var denominator: Int

    var body: some View {
        HStack(spacing: 0) {
            Spacer.zero

            Text("\(numerator) / \(denominator)")
                .font(Font.subheadline.monospacedDigit())
                .foregroundColor(Color(.label))
        }
            .padding(.top, 8)
            .padding(.horizontal, 24)
            .animation(nil, value: self)
    }
}
