import SwiftUI
import Redux

struct SettingsView: View {
    
    // var router: (RouteModule<AppRoute>.Action) -> ()
    var navigate: (SettingsRoute) -> ()
    var logout: () -> ()
    
    var body: some View {
        VStack {
            List {
                Button("Integrations", action: { navigate(.integrations) })
                Button("Debug", action: { navigate(.debug) })
               
                
                // Button("Intro", action: { router(.presentSheet(.intro)) }) // todo: navigate
                
                Button("Logout", action: logout)
                    .tint(Color.red)
                
            }
            .tint(Color.theme)
        }
    }
}

