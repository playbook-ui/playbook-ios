import SwiftUI

@available(iOS 15.0, *)
internal struct Counter: View {
    let count: Int
    let total: Int

    var body: some View {
        HStack(spacing: 0) {
            Spacer.zero

            Text("\(count) / \(total)")
                .textStyle(
                    font: .caption.monospacedDigit(),
                    color: Color(.secondaryLabel)
                )
        }
        .padding(.horizontal, 24)
    }
}
