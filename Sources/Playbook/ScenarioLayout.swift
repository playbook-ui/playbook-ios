import UIKit

/// Represents how the component should be laid out.
public struct ScenarioLayout: Equatable {
    /// A sizing strategy for the horizontal or vertical dimensions.
    public enum Sizing: Equatable, ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {
        /// Compresses to the intrinsic size of the component.
        case compressed

        /// Fill to the size of the canvas on which to layout the component.
        case fill

        /// Layout with given fixed size.
        /// Note: There are cases that to compressed to
        ///       the size of the canvas on which to layout it when it can't be displayed
        ///       on the UI.
        case fixed(CGFloat)

        /// Creates a `fixed` sizing with the specified value converted to a `CGFloat`.
        ///
        /// - Parameters:
        ///   - value: The actual value of `fixed` sizing.
        public init(integerLiteral value: Int) {
            self = .fixed(CGFloat(value))
        }

        /// Creates a `fixed` sizing with the specified value converted to a `CGFloat`.
        /// - Parameters:
        ///   - value: The actual value of `fixed` sizing.
        public init(floatLiteral value: Float) {
            self = .fixed(CGFloat(value))
        }
    }

    /// A horizontal sizing strategy.
    public var h: Sizing

    /// A vertical sizing strategy.
    public var v: Sizing

    /// Compresses both the horizontal and vertical to the intrinsic size of the component.
    public static let compressed = ScenarioLayout(h: .compressed, v: .compressed)

    /// Fill both the horizontal and vertical to the size of the canvas on
    /// which to layout the component.
    public static let fill = ScenarioLayout(h: .fill, v: .fill)

    /// Fill the horizontal to the size of the canvas on which to layout the component
    /// and compresses the vertical to the intrinsic size of the component.
    public static let fillH = ScenarioLayout(h: .fill, v: .compressed)

    /// Fill the vetical to the size of the canvas on which to layout the component
    /// and compresses the horizontal to the intrinsic size of the component.
    public static let fillV = ScenarioLayout(h: .compressed, v: .fill)

    /// Layout both the vertical and horizontal with given fixed width and height.
    ///
    /// Note: There are cases that to compressed to
    ///       the size of the canvas on which to layout it when it can't be displayed
    ///       on the user interface.
    public static func fixed(width: CGFloat, height: CGFloat) -> ScenarioLayout {
        ScenarioLayout(h: .fixed(width), v: .fixed(height))
    }

    /// Layout both the vertical and horizontal with given fixed length.
    ///
    /// Note: There are cases that to compressed to
    ///       the size of the canvas on which to layout it when it can't be displayed
    ///       on the user interface.
    public static func fixed(length: CGFloat) -> ScenarioLayout {
        .fixed(width: length, height: length)
    }

    /// Layout the horizontal with given fixed width and compresses the vertical
    /// to the intrinsic size of the component.
    ///
    /// Note: There are cases that to compressed to
    ///       the size of the canvas on which to layout it when it can't be displayed
    ///       on the user interface.
    public static func fixedH(_ width: CGFloat) -> ScenarioLayout {
        ScenarioLayout(h: .fixed(width), v: .compressed)
    }

    /// Layout the vertical with given fixed height and compresses the horizontal
    /// to the intrinsic size of the component.
    ///
    /// Note: There are cases that to compressed to
    ///       the size of the canvas on which to layout it when it can't be displayed
    ///       on the user interface.
    public static func fixedV(_ height: CGFloat) -> ScenarioLayout {
        ScenarioLayout(h: .compressed, v: .fixed(height))
    }

    /// Layout the vertical and horizontal sizes according to the specified strategies.
    ///
    /// - Parameters:
    ///   - h: A horizontal sizing strategy.
    ///   - v: A vertical sizing strategy.
    public static func sizing(h: Sizing, v: Sizing) -> ScenarioLayout {
        ScenarioLayout(h: h, v: v)
    }

    private init(h: Sizing, v: Sizing) {
        self.h = h
        self.v = v
    }
}
