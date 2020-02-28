/*
See LICENSE folder for this sample’s licensing information.

Abstract:
An object that models a user profile.
*/
import Foundation

public struct Profile {
    public var username: String
    public var prefersNotifications: Bool
    public var seasonalPhoto: Season
    public var goalDate: Date

    public static func `default`(goalDate: Date = Date()) -> Profile {
        Profile(
            username: "g_kumar",
            prefersNotifications: true,
            seasonalPhoto: .winter,
            goalDate: goalDate
        )
    }

    public init(
        username: String,
        prefersNotifications: Bool = true,
        seasonalPhoto: Season = .winter,
        goalDate: Date
    ) {
        self.username = username
        self.prefersNotifications = prefersNotifications
        self.seasonalPhoto = seasonalPhoto
        self.goalDate = goalDate
    }
    
    public enum Season: String, CaseIterable {
        case spring = "🌷"
        case summer = "🌞"
        case autumn = "🍂"
        case winter = "☃️"
    }
}
