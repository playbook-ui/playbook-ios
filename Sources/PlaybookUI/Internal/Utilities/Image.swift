import SwiftUI

internal extension Image {
    enum SFSymbols: String {
        case xmark
        case xmarkCircleFill = "xmark.circle.fill"
        case ellipsisCircle = "ellipsis.circle"
        case magnifyingglass
        case sunMax = "sun.max"
        case moon
        case docTextMagnifyingglass = "doc.text.magnifyingglass"
        case chevronRight = "chevron.right"
        case circleFill = "circle.fill"
        case sidebarLeft = "sidebar.left"
    }

    init(symbol: SFSymbols) {
        self.init(systemName: symbol.rawValue)
    }
}
