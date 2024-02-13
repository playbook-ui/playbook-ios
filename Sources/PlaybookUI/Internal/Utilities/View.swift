import SwiftUI

@available(iOS 15.0, *)
internal extension View {
    func textStyle(
        font: Font,
        color: Color = Color(.label),
        alignment: TextAlignment = .leading,
        lineLimit: Int? = nil
    ) -> some View {
        foregroundStyle(color)
            .font(font)
            .multilineTextAlignment(alignment)
            .lineLimit(lineLimit)
            .dynamicTypeSize(.large)
    }

    func imageStyle(
        font: Font,
        color: Color = Color(.label)
    ) -> some View {
        foregroundStyle(color)
            .font(font)
            .dynamicTypeSize(.large)
    }
}
