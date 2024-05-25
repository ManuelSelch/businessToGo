import SwiftUI
import ComposableArchitecture

struct SettingsView: View {
    let store: StoreOf<SettingsFeature>
    
    var body: some View {
        VStack {
            List {
                Button("Integrations", action: { store.send(.integrationsTapped) })
                Button("Debug", action: { store.send(.debugTapped) })
                Button("Log", action: { store.send(.logTapped) })
                Button("Intro", action: { store.send(.introTapped) })
                
                Button("Logout", action: { store.send(.logoutTapped) })
                    .tint(Color.red)
                
            }
            .tint(Color.theme)
        }
    }
}

