import SwiftUI

@available(iOS 15, *)
internal struct HighlightText: View {
    let content: String
    let range: Range<String.Index>?

    var body: some View {
        if let range {
            Text(attributedContent(range: range))
        }
        else {
            Text(content)
        }
    }
}

@available(iOS 15, *)
private extension HighlightText {
    func attributedContent(range: Range<String.Index>) -> AttributedString {
        var attributed = AttributedString(content)
        let nsRange = NSRange(range, in: content)

        if let attributedRange = Range<AttributedString.Index>(nsRange, in: attributed) {
            attributed[attributedRange].foregroundColor = .init(uiColor: .highlight)
        }

        return attributed
    }
}
