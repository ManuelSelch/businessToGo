import SwiftUI

struct SettingsView: View {
    
    var navigate: (SettingsRoute) -> ()
    var logout: () -> ()
    
    var body: some View {
        VStack {
            List {
                Button(action: {
                    navigate(.integrations)
                }){
                    Text("Integrations")
                }
                
                Button(action: {
                    navigate(.debug)
                }){
                    Text("Debug")
                }
                
            }
            .tint(Color.theme)
            
            Spacer()
            
            Button(action: {
                logout()
            }){
                Text("Logout")
                    .tint(Color.red)
            }
        }
    }
}

