import SwiftUI

public struct SettingsView: View {
    
    let integrationsTapped: () -> ()
    let debugTapped: () -> ()
    let introTapped: () -> ()
    let logoutTapped: () -> ()
    
    public init(integrationsTapped: @escaping () -> Void, debugTapped: @escaping () -> Void, introTapped: @escaping () -> Void, logoutTapped: @escaping () -> Void) {
        self.integrationsTapped = integrationsTapped
        self.debugTapped = debugTapped
        self.introTapped = introTapped
        self.logoutTapped = logoutTapped
    }
    
    public var body: some View {
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

