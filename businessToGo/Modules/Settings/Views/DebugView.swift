import SwiftUI

struct DebugView: View {
    let account: Account?
    @Binding var isDebug: Bool
    
    let resetTapped: () -> ()
    let logTapped: () -> ()
    
    var body: some View {
        List {
            Section("General") {
                
                Button(action: {
                    resetTapped()
                }){
                    Text("Reset Database")
                        .foregroundStyle(Color.red)
                }
                
                Toggle("Remote Debug", isOn: $isDebug)
                if(isDebug) {
                    Button("Logs", action: { logTapped() })
                        .foregroundStyle(Color.theme)
                }
            }
            
            Section("Account"){
                Text(account?.name ?? "--")
                    .bold()
                    .foregroundStyle(Color.theme)
                Text("Kimai: " + (account?.kimai?.username ?? "--"))
                    .font(.footnote)
                Text("Taiga: " + (account?.taiga?.username ?? "--"))
                    .font(.footnote)
            }
            
          
            /* TODO: display debug state
            Section("State") {
                if let data = try? JSONEncoder().encode(store.kimai),
                   let json = String(data: data, encoding: .utf8) {
                    DebugJsonView(json)
                }
                
                if let data = try? JSONEncoder().encode(store.taiga),
                   let json = String(data: data, encoding: .utf8) {
                    DebugJsonView(json)
                }
            }
            */
            
            
            
            
          
            
        }
        .listStyle(SidebarListStyle())
        .padding()
    }
}

