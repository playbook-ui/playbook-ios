/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The model for an individual landmark.
*/

import SwiftUI
import CoreLocation

public struct Landmark: Hashable, Codable, Identifiable {
    public var id: Int
    public var name: String
    fileprivate var imageName: String
    fileprivate var coordinates: Coordinates
    public var state: String
    public var park: String
    public var category: Category
    public var isFavorite: Bool
    public var isFeatured: Bool

    public var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }

    public enum Category: String, CaseIterable, Codable, Hashable {
        case featured = "Featured"
        case lakes = "Lakes"
        case rivers = "Rivers"
        case mountains = "Mountains"
    }

    public init(
        id: Int,
        name: String,
        imageName: String,
        coordinates: Coordinates,
        state: String,
        park: String,
        category: Category,
        isFavorite: Bool,
        isFeatured: Bool
    ) {
        self.id = id
        self.name = name
        self.imageName = imageName
        self.coordinates = coordinates
        self.state = state
        self.park = park
        self.category = category
        self.isFavorite = isFavorite
        self.isFeatured = isFeatured
    }
}

extension Landmark {
    public var image: Image {
        ImageStore.shared.image(name: imageName)
    }
}

public struct Coordinates: Hashable, Codable {
    public var latitude: Double
    public var longitude: Double

    public init(
        latitude: Double,
        longitude: Double
    ) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
