/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that displays a badge.
*/

import SwiftUI

public struct Badge: View {
    public static let rotationCount = 8
    
    public var badgeSymbols: some View {
        ForEach(0..<Badge.rotationCount) { i in
            RotatedBadgeSymbol(
                angle: .degrees(Double(i) / Double(Badge.rotationCount)) * 360.0)
        }
        .opacity(0.5)
    }
    
    public var body: some View {
        ZStack {
            BadgeBackground()
            
            GeometryReader { geometry in
                self.badgeSymbols
                .scaleEffect(1.0 / 4.0, anchor: .top)
                .position(x: geometry.size.width / 2.0, y: (3.0 / 4.0) * geometry.size.height)
            }
        }
        .scaledToFit()
    }

    public init() {}
}

internal struct Badge_Previews: PreviewProvider {
    static var previews: some View {
        Badge()
    }
}
