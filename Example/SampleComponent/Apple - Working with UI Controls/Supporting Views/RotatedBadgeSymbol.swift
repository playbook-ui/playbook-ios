/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that displays a rotated version of a badge symbol.
*/

import SwiftUI

public struct RotatedBadgeSymbol: View {
    public let angle: Angle
    
    public var body: some View {
        BadgeSymbol()
            .padding(-60)
            .rotationEffect(angle, anchor: .bottom)
    }

    public init(angle: Angle) {
        self.angle = angle
    }
}

internal struct RotatedBadgeSymbol_Previews: PreviewProvider {
    static var previews: some View {
        RotatedBadgeSymbol(angle: .init(degrees: 5))
    }
}
