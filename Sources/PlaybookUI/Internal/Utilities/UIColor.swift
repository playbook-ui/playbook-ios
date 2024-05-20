import UIKit

internal extension UIColor {
    static let primaryBlue = UIColor(hex: 0x048DFF)
    static let highlight = UIColor.systemYellow
    static let translucentFill = UIColor.secondarySystemFill
    static let background = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .light ? .white : .black
    }
}

private extension UIColor {
    convenience init(hex: Int) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255
        let blue = CGFloat((hex & 0x0000FF) >> 0) / 255

        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}
