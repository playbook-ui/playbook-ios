/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A single line in the graph.
*/

import SwiftUI

public struct GraphCapsule: View {
    public var index: Int
    public var height: CGFloat
    public var range: Range<Double>
    public var overallRange: Range<Double>
    public var color: Color
    
    private var heightRatio: CGFloat {
        max(CGFloat(magnitude(of: range) / magnitude(of: overallRange)), 0.15)
    }
    
    private var offsetRatio: CGFloat {
        CGFloat((range.lowerBound - overallRange.lowerBound) / magnitude(of: overallRange))
    }
    
    private var animation: Animation {
        Animation.spring(dampingFraction: 0.5)
        	.speed(2)
         	.delay(0.03 * Double(index))
    }
    
    public var body: some View {
        Capsule()
            .fill(color)
            .frame(height: height * heightRatio, alignment: .bottom)
            .offset(x: 0, y: height * -offsetRatio)
            .animation(animation)
    }

    public init(
        index: Int,
        height: CGFloat,
        range: Range<Double>,
        overallRange: Range<Double>,
        color: Color
    ) {
        self.index = index
        self.height = height
        self.range = range
        self.overallRange = overallRange
        self.color = color
    }
}

internal struct GraphCapsule_Previews: PreviewProvider {
    static var previews: some View {
        GraphCapsule(
            index: 0,
            height: 150,
            range: 10..<50,
            overallRange: 0..<100,
            color: .gray
        )
    }
}
