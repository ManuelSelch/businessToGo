import SwiftUI
import ComposableArchitecture

struct DebugView: View {
    let store: StoreOf<DebugFeature>
    
    @State var isLog: Bool = false
    
    
    var body: some View {
        List {
            Section("General") {
                
                Button(action: {
                    store.send(.resetTapped)
                }){
                    Text("Reset Database")
                        .foregroundStyle(Color.red)
                }
            }
            
            Section("Account"){
                Text(store.current?.name ?? "--")
                    .bold()
                    .foregroundStyle(Color.theme)
                Text("Kimai: " + (store.current?.kimai?.username ?? "--"))
                    .font(.footnote)
                Text("Taiga: " + (store.current?.taiga?.username ?? "--"))
                    .font(.footnote)
            }
            
          
            
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
            
            
            
            
            
          
            
        }
        .listStyle(SidebarListStyle())
        .padding()
    }
}

