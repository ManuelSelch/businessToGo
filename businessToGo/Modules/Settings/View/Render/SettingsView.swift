import SwiftUI

struct SettingsView: View {
    
    var navigate: (SettingsRoute) -> ()
    var logout: () -> ()
    
    var body: some View {
        VStack {
            List {
                Button(action: {
                    navigate(.kimaiCustomers)
                }){
                    Text("Kunden")
                }
                
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
                
                Button(action: {
                    navigate(.kimaiProjects)
                }){
                    Text("Projekte")
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

