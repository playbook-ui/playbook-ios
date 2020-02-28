/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The model for a hike.
*/

import SwiftUI

public struct Hike: Codable, Hashable, Identifiable {
    public var name: String
    public var id: Int
    public var distance: Double
    public var difficulty: Int
    public var observations: [Observation]

    public static var formatter = LengthFormatter()
    
    public var distanceText: String {
        return Hike.formatter
            .string(fromValue: distance, unit: .kilometer)
    }

    public struct Observation: Codable, Hashable {
        public var distanceFromStart: Double
        
        public var elevation: Range<Double>
        public var pace: Range<Double>
        public var heartRate: Range<Double>

        public init(
            distanceFromStart: Double,
            elevation: Range<Double>,
            pace: Range<Double>,
            heartRate: Range<Double>
        ) {
            self.distanceFromStart = distanceFromStart
            self.elevation = elevation
            self.pace = pace
            self.heartRate = heartRate
        }
    }

    public init(
        name: String,
        id: Int,
        distance: Double,
        difficulty: Int,
        observations: [Observation]
    ) {
        self.name = name
        self.id = id
        self.distance = distance
        self.difficulty = difficulty
        self.observations = observations
    }
}
