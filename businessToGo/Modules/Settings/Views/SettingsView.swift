import SwiftUI

struct SettingsView: View {
    
    let integrationsTapped: () -> ()
    let debugTapped: () -> ()
    let introTapped: () -> ()
    let logoutTapped: () -> ()
    
    var body: some View {
        VStack {
            List {
                Button("Integrations", action: { integrationsTapped() })
                Button("Debug", action: { debugTapped() })
                Button("Intro", action: { introTapped() })
                
                Button("Logout", action: { logoutTapped() })
                    .tint(Color.red)
                
            }
            .tint(Color.theme)
        }
    }
}

