/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing the details for a hike.
*/

import SwiftUI

public struct HikeDetail: View {
    public let hike: Hike
    @State private var dataToShow = \Hike.Observation.elevation
    
    public var buttons = [
        ("Elevation", \Hike.Observation.elevation),
        ("Heart Rate", \Hike.Observation.heartRate),
        ("Pace", \Hike.Observation.pace),
    ]
    
    public var body: some View {
        return VStack {
            HikeGraph(hike: hike, path: dataToShow)
                .frame(height: 200, alignment: .center)
            
            HStack(spacing: 25) {
                ForEach(buttons, id: \.0) { value in
                    Button(action: {
                        self.dataToShow = value.1
                    }) {
                        Text(verbatim: value.0)
                            .font(.system(size: 15))
                            .foregroundColor(value.1 == self.dataToShow
                                ? Color.gray
                                : Color.accentColor)
                            .animation(nil)
                    }
                }
            }
        }
    }

    public init(hike: Hike) {
        self.hike = hike
    }
}

internal struct HikeDetail_Previews: PreviewProvider {
    static var previews: some View {
        HikeDetail(hike: hikeData[0])
    }
}
