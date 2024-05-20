import SwiftUI

internal extension UIImage {
    // Drawn with SwiftDraw: https://github.com/swhitty/SwiftDraw
    static let logoMark = {
        let size = CGSize(width: 142.0, height: 103.0)
        return UIGraphicsImageRenderer(size: size).image { ctx in
            let ctx = ctx.cgContext
            ctx.saveGState()

            let path = CGMutablePath()
            path.move(to: CGPoint(x: 141.03, y: 2.28))
            path.addCurve(
                to: CGPoint(x: 139.21, y: 0.15),
                control1: CGPoint(x: 141.79, y: 1.21),
                control2: CGPoint(x: 140.73, y: 0.15)
            )
            path.addLine(to: CGPoint(x: 88.2, y: 0.15))
            path.addLine(to: CGPoint(x: 87.9, y: 0.15))
            path.addCurve(
                to: CGPoint(x: 85.47, y: 1.37),
                control1: CGPoint(x: 86.84, y: 0.15),
                control2: CGPoint(x: 85.92, y: 0.61)
            )
            path.addLine(to: CGPoint(x: 16.4, y: 100.95))
            path.addCurve(
                to: CGPoint(x: 16.24, y: 101.41),
                control1: CGPoint(x: 16.24, y: 101.11),
                control2: CGPoint(x: 16.24, y: 101.26)
            )
            path.addCurve(
                to: CGPoint(x: 17.46, y: 102.32),
                control1: CGPoint(x: 16.24, y: 101.86),
                control2: CGPoint(x: 16.85, y: 102.32)
            )
            path.addLine(to: CGPoint(x: 17.76, y: 102.32))
            path.addLine(to: CGPoint(x: 22.01, y: 102.32))
            path.addLine(to: CGPoint(x: 138.75, y: 102.47))
            path.addCurve(
                to: CGPoint(x: 140.58, y: 100.35),
                control1: CGPoint(x: 140.27, y: 102.47),
                control2: CGPoint(x: 141.34, y: 101.26)
            )
            path.addLine(to: CGPoint(x: 107.48, y: 52.07))
            path.addCurve(
                to: CGPoint(x: 107.48, y: 50.7),
                control1: CGPoint(x: 107.18, y: 51.62),
                control2: CGPoint(x: 107.18, y: 51.16)
            )
            path.addLine(to: CGPoint(x: 141.03, y: 2.28))
            path.closeSubpath()
            ctx.addPath(path)
            ctx.clip()
            ctx.setAlpha(1)

            let rgb = CGColorSpaceCreateDeviceRGB()
            let color1 = CGColor(colorSpace: rgb, components: [0.004, 0.525, 1, 1])!
            let color2 = CGColor(colorSpace: rgb, components: [0.376, 0.871, 0.996, 1])!
            var locations: [CGFloat] = [0.0, 0.9387]
            let gradient = CGGradient(
                colorsSpace: rgb,
                colors: [color1, color2] as CFArray,
                locations: &locations
            )!
            ctx.drawLinearGradient(
                gradient,
                start: CGPoint(x: 16.39, y: 51.21),
                end: CGPoint(x: 136.7, y: 51.21),
                options: [.drawsAfterEndLocation, .drawsBeforeStartLocation]
            )
            ctx.restoreGState()
            ctx.saveGState()

            let path1 = CGMutablePath()
            path1.move(to: CGPoint(x: 69.98, y: 0.15))
            path1.addLine(to: CGPoint(x: 2.58, y: 0))
            path1.addCurve(
                to: CGPoint(x: 0.15, y: 1.82),
                control1: CGPoint(x: 1.21, y: 0),
                control2: CGPoint(x: 0.15, y: 0.76)
            )
            path1.addLine(to: CGPoint(x: 0, y: 100.5))
            path1.addCurve(
                to: CGPoint(x: 4.71, y: 101.26),
                control1: CGPoint(x: 0, y: 102.32),
                control2: CGPoint(x: 3.49, y: 102.93)
            )
            path1.addLine(to: CGPoint(x: 72.41, y: 2.73))
            path1.addCurve(
                to: CGPoint(x: 69.98, y: 0.15),
                control1: CGPoint(x: 73.02, y: 1.52),
                control2: CGPoint(x: 71.96, y: 0.15)
            )
            path1.closeSubpath()
            ctx.addPath(path1)
            ctx.clip()
            ctx.setAlpha(1)

            var locations1: [CGFloat] = [0.0619712, 0.9387]
            let gradient1 = CGGradient(
                colorsSpace: rgb,
                colors: [color1, color2] as CFArray,
                locations: &locations1
            )!
            ctx.drawLinearGradient(
                gradient1,
                start: CGPoint(x: -0.18, y: 51.1),
                end: CGPoint(x: 72.53, y: 51.1),
                options: [.drawsAfterEndLocation, .drawsBeforeStartLocation]
            )
            ctx.restoreGState()
        }
    }()
}
