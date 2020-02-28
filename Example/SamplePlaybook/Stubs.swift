import Foundation
import SampleComponent

extension UserData {
    static var stub: UserData {
        UserData(profile: .stub)
    }
}

extension Profile {
    static var stub: Profile {
        let unixEpoch = Date(timeIntervalSince1970: 0)
        return .default(goalDate: unixEpoch)
    }
}
