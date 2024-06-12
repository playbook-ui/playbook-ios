/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing the details for a landmark.
*/

import SwiftUI

public struct LandmarkDetail: View {
    @EnvironmentObject private var userData: UserData
    public var landmark: Landmark
    public var didFinishRendering: (() -> Void)?
    
    public var landmarkIndex: Int {
        userData.landmarks.firstIndex(where: { $0.id == landmark.id })!
    }
    
    public var body: some View {
        VStack {
            MapView(coordinate: landmark.locationCoordinate, didFinishRendering: didFinishRendering)
                .edgesIgnoringSafeArea(.top)
                .frame(height: 320)
            
            CircleImage(image: landmark.image)
                .offset(x: 0, y: -130)
                .padding(.bottom, -130)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(verbatim: landmark.name)
                        .font(.title)
                    
                    Button(action: {
                        self.userData.landmarks[self.landmarkIndex]
                            .isFavorite.toggle()
                    }) {
                        if self.userData.landmarks[self.landmarkIndex]
                            .isFavorite {
                            Image(systemName: "star.fill")
                                .foregroundColor(Color.yellow)
                        } else {
                            Image(systemName: "star")
                                .foregroundColor(Color.gray)
                        }
                    }
                }
                
                HStack(alignment: .top) {
                    Text(verbatim: landmark.park)
                        .font(.subheadline)
                    Spacer()
                    Text(verbatim: landmark.state)
                        .font(.subheadline)
                }
            }
            .padding()
            
            Spacer()
        }
        .background(
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
        )
    }

    public init(landmark: Landmark, didFinishRendering: (() -> Void)? = nil) {
        self.landmark = landmark
        self.didFinishRendering = didFinishRendering
    }
}

internal struct LandmarkDetail_Preview: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        return LandmarkDetail(landmark: userData.landmarks[0])
            .environmentObject(userData)
    }
}
