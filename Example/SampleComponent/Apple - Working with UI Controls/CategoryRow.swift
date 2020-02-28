/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing a scrollable list of landmarks.
*/

import SwiftUI

public struct CategoryRow: View {
    public var categoryName: String
    public var items: [Landmark]
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text(self.categoryName)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(self.items) { landmark in
                        NavigationLink(
                            destination: LandmarkDetail(
                                landmark: landmark
                            )
                        ) {
                            CategoryItem(landmark: landmark)
                        }
                    }
                }
            }
            .frame(height: 185)
        }
    }

    public init(
        categoryName: String,
        items: [Landmark]
    ) {
        self.categoryName = categoryName
        self.items = items
    }
}

public struct CategoryItem: View {
    public var landmark: Landmark
    public var body: some View {
        VStack(alignment: .leading) {
            landmark.image
                .renderingMode(.original)
                .resizable()
                .frame(width: 155, height: 155)
                .cornerRadius(5)
            Text(landmark.name)
                .foregroundColor(.primary)
                .font(.caption)
        }
        .padding(.leading, 15)
    }

    public init(landmark: Landmark) {
        self.landmark = landmark
    }
}

internal struct CategoryRow_Previews: PreviewProvider {
    static var previews: some View {
        CategoryRow(
            categoryName: landmarkData[0].category.rawValue,
            items: Array(landmarkData.prefix(4))
        )
        .environmentObject(UserData())
    }
}
