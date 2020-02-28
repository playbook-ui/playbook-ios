/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A model object that stores app data.
*/

import Combine
import SwiftUI

public final class UserData: ObservableObject {
    @Published public var showFavoritesOnly = false
    @Published public var landmarks = landmarkData
    @Published public var profile: Profile

    public init(profile: Profile = .default()) {
        self.profile = profile
    }
}
