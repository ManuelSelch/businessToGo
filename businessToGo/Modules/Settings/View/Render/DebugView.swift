import SwiftUI
import Redux

struct DebugView: View {
    @State var isLog: Bool = false
    let current: Account?
    let state: AppModule.State
    
    var onUpdateLog: (Bool) -> ()
    var onReset: () -> ()
    
    
    var body: some View {
        List {
            Section("General") {
                Toggle(isOn: $isLog) {
                    Text("Log")
                }
                .onChange(of: isLog){
                    onUpdateLog(isLog)
                }
                
                Button(action: {
                    onReset()
                }){
                    Text("Reset Database")
                        .foregroundStyle(Color.red)
                }
            }
            
            Section("Account"){
                Text(current?.name ?? "--")
                    .bold()
                    .foregroundStyle(Color.theme)
                Text("Kimai: " + (current?.kimai?.username ?? "--"))
                    .font(.footnote)
                Text("Taiga: " + (current?.taiga?.username ?? "--"))
                    .font(.footnote)
            }
            
          
            
            Section("State") {
                if let data = try? JSONEncoder().encode(state),
                   let json = String(data: data, encoding: .utf8) {
                    DebugJsonView(json)
                }
            }
            
          
            
        }
        .listStyle(SidebarListStyle())
        .padding()
    }
}

