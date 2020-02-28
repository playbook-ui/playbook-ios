/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that shows a badge for hiking.
*/

import SwiftUI

public struct HikeBadge: View {
    public var name: String
    public var body: some View {
        VStack(alignment: .center) {
            Badge()
                .frame(width: 300, height: 300)
                .scaleEffect(1.0 / 3.0)
                .frame(width: 100, height: 100)
            Text(name)
                .font(.caption)
                .accessibility(label: Text("Badge for \(name)."))
        }
    }

    public init(name: String) {
        self.name = name
    }
}

internal struct HikeBadge_Previews: PreviewProvider {
    static var previews: some View {
        HikeBadge(name: "Preview Testing")
    }
}
