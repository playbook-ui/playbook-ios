import Playbook
import SampleComponent
import SwiftUI

struct SupportingViewsScenarios: ScenarioProvider {
    static func addScenarios(into playbook: Playbook) {
        playbook.addScenarios(of: "SupportingViews") {
            Scenario("Badge", layout: .fixed(width: 300, height: 300)) {
                Badge()
            }

            Scenario("CircleImage", layout: .compressed) {
                CircleImage(image: landmarkData[10].image).padding(20)
            }

            Scenario("MapView", layout: .fill) { context in
                MapView(coordinate: landmarkData[10].locationCoordinate) {
                    context.snapshotWaiter.fulfill()
                }
                    .edgesIgnoringSafeArea(.all)
                    .onAppear(perform: context.snapshotWaiter.wait)
            }

            Scenario("LandmarkRow", layout: .fixedH(300)) {
                VStack {
                    ForEach(landmarkData.prefix(5)) { landmark in
                        LandmarkRow(landmark: landmark)
                    }
                }
            }

            Scenario("HikeGraph", layout: .fixedH(300)) {
                VStack(spacing: 24) {
                    HikeGraph(
                        hike: hikeData[0],
                        path: \.elevation
                    )
                        .frame(height: 150)

                    HikeGraph(
                        hike: hikeData[0],
                        path: \.heartRate
                    )
                        .frame(height: 150)

                    HikeGraph(
                        hike: hikeData[0],
                        path: \.pace
                    )
                        .frame(height: 150)
                }
            }
        }
    }
}
