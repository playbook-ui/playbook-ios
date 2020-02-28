/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Size, position, and other information used to draw a badge.
*/

import SwiftUI

public struct HexagonParameters {
    public struct Segment {
        public let useWidth: (CGFloat, CGFloat, CGFloat)
        public let xFactors: (CGFloat, CGFloat, CGFloat)
        public let useHeight: (CGFloat, CGFloat, CGFloat)
        public let yFactors: (CGFloat, CGFloat, CGFloat)

        public init(
            useWidth: (CGFloat, CGFloat, CGFloat),
            xFactors: (CGFloat, CGFloat, CGFloat),
            useHeight: (CGFloat, CGFloat, CGFloat),
            yFactors: (CGFloat, CGFloat, CGFloat)
        ) {
            self.useWidth = useWidth
            self.xFactors = xFactors
            self.useHeight = useHeight
            self.yFactors = yFactors
        }
    }
    
    public static let adjustment: CGFloat = 0.085
    public static let points = [
        Segment(
            useWidth:  (1.00, 1.00, 1.00),
            xFactors:  (0.60, 0.40, 0.50),
            useHeight: (1.00, 1.00, 0.00),
            yFactors:  (0.05, 0.05, 0.00)
        ),
        Segment(
            useWidth:  (1.00, 1.00, 0.00),
            xFactors:  (0.05, 0.00, 0.00),
            useHeight: (1.00, 1.00, 1.00),
            yFactors:  (0.20 + adjustment, 0.30 + adjustment, 0.25 + adjustment)
        ),
        Segment(
            useWidth:  (1.00, 1.00, 0.00),
            xFactors:  (0.00, 0.05, 0.00),
            useHeight: (1.00, 1.00, 1.00),
            yFactors:  (0.70 - adjustment, 0.80 - adjustment, 0.75 - adjustment)
        ),
        Segment(
            useWidth:  (1.00, 1.00, 1.00),
            xFactors:  (0.40, 0.60, 0.50),
            useHeight: (1.00, 1.00, 1.00),
            yFactors:  (0.95, 0.95, 1.00)
        ),
        Segment(
            useWidth:  (1.00, 1.00, 1.00),
            xFactors:  (0.95, 1.00, 1.00),
            useHeight: (1.00, 1.00, 1.00),
            yFactors:  (0.80 - adjustment, 0.70 - adjustment, 0.75 - adjustment)
        ),
        Segment(
            useWidth:  (1.00, 1.00, 1.00),
            xFactors:  (1.00, 0.95, 1.00),
            useHeight: (1.00, 1.00, 1.00),
            yFactors:  (0.30 + adjustment, 0.20 + adjustment, 0.25 + adjustment)
        )
    ]

    public init() {}
}
