import SwiftUI

internal extension UIColor {
    static let primaryBlue = UIColor(hex: 0x048DFF)

    static let primaryBackground = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .light ? .white : UIColor(hex: 0x18242D)
    }

    static let secondaryBackground = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .light ? .white : UIColor(hex: 0x29373F)
    }

    static let scenarioBackground = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .light ? .white : .black
    }

    static let highlight = UIColor.systemYellow.withAlphaComponent(0.4)

    convenience init(hex: Int, alpha: CGFloat = 1) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255
        let blue = CGFloat((hex & 0x0000FF) >> 0) / 255

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    func circleImage(length: CGFloat) -> UIImage {
        let size = CGSize(width: length, height: length)
        return UIGraphicsImageRenderer(size: size).image { context in
            let rect = CGRect(origin: .zero, size: size)
            setFill()
            context.cgContext.fillEllipse(in: rect)
        }
    }
}

internal extension Image {
    enum SFSymbols: String {
        case book = "book"
        case multiply = "multiply"
        case chevronRight = "chevron.right"
        case bookmarkFill = "bookmark.fill"
        case circleFill = "circle.fill"
        case sidebarLeft = "sidebar.left"
        case rectangle = "rectangle"
        case squareAndArrowUp = "square.and.arrow.up"
        case docTextMagnifyingglass = "doc.text.magnifyingglass"
    }

    init(symbol: SFSymbols) {
        self.init(systemName: symbol.rawValue)
    }
}

internal extension Spacer {
    static var zero: Spacer {
        Spacer(minLength: 0)
    }

    static func fixed(length: CGFloat) -> some View {
        Spacer(minLength: length).fixedSize()
    }
}

internal extension EdgeInsets {
    static func only(
        top: CGFloat = 0,
        leading: CGFloat = 0,
        bottom: CGFloat = 0,
        trailing: CGFloat = 0
    ) -> EdgeInsets {
        EdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
    }
}

internal extension UIEdgeInsets {
    static func only(
        top: CGFloat = 0,
        left: CGFloat = 0,
        bottom: CGFloat = 0,
        right: CGFloat = 0
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
}
