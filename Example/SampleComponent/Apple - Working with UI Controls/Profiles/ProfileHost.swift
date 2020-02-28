/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that hosts the profile viewer and editor.
*/

import SwiftUI

public struct ProfileHost: View {
    @Environment(\.editMode) private var mode
    @EnvironmentObject private var userData: UserData
    @State private var draftProfile = Profile.default()
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                if self.mode?.wrappedValue == .active {
                    Button("Cancel") {
                        self.draftProfile = self.userData.profile
                        self.mode?.animation().wrappedValue = .inactive
                    }
                }
                
                Spacer()
                
                EditButton()
            }
            if self.mode?.wrappedValue == .inactive {
                ProfileSummary(profile: userData.profile)
            } else {
                ProfileEditor(profile: $draftProfile)
                    .onAppear {
                        self.draftProfile = self.userData.profile
                }
                .onDisappear {
                    self.userData.profile = self.draftProfile
                }
            }
        }
        .padding()
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
    }

    public init() {}
}

internal struct ProfileHost_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHost().environmentObject(UserData())
    }
}
