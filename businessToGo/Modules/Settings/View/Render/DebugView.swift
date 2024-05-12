import SwiftUI

struct DebugView: View {
    @State var isLog: Bool = false
    var current: Account?
    var onUpdateLog: (Bool) -> ()
    var onReset: () -> ()
    
    var body: some View {
        List {
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
            
            Section("Account"){
                Text(current?.name ?? "--")
                    .bold()
                    .foregroundStyle(Color.theme)
                Text("Kimai: " + (current?.kimai?.username ?? "--"))
                    .font(.footnote)
                Text("Taiga: " + (current?.taiga?.username ?? "--"))
                    .font(.footnote)
            }
        }
        .padding()
    }
}

