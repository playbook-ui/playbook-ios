/*
See LICENSE folder for this sample’s licensing information.

Abstract:
An editable profile view.
*/

import SwiftUI

public struct ProfileEditor: View {
    @Binding private var profile: Profile
    
    public var dateRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .year, value: -1, to: profile.goalDate)!
        let max = Calendar.current.date(byAdding: .year, value: 1, to: profile.goalDate)!
        return min...max
    }
    
    public var body: some View {
        List {
            HStack {
                Text("Username").bold()
                Divider()
                TextField("Username", text: $profile.username)
            }
            
            Toggle(isOn: $profile.prefersNotifications) {
                Text("Enable Notifications")
            }
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Seasonal Photo").bold()
                
                Picker("Seasonal Photo", selection: $profile.seasonalPhoto) {
                    ForEach(Profile.Season.allCases, id: \.self) { season in
                        Text(season.rawValue).tag(season)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding(.top)
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Goal Date").bold()

                DatePicker(
                    selection: $profile.goalDate,
                    in: dateRange,
                    displayedComponents: .date,
                    label: { EmptyView() }
                )
            }
            .padding(.top)
        }
    }

    public init(profile: Binding<Profile>) {
        self._profile = profile
    }
}

internal struct ProfileEditor_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditor(profile: .constant(.default()))
    }
}
