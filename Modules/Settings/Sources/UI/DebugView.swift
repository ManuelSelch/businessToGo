import SwiftUI

import CommonUI
import LoginCore

public struct DebugView: View {
    let account: Account?
    @Binding var isLocalLog: Bool
    @Binding var isRemoteLog: Bool
    
    let resetTapped: () -> ()
    let logTapped: () -> ()
    
    public init(account: Account?, isLocalLog: Binding<Bool>, isRemoteLog: Binding<Bool>, resetTapped: @escaping () -> Void, logTapped: @escaping () -> Void) {
        self.account = account
        self._isLocalLog = isLocalLog
        self._isRemoteLog = isRemoteLog
        self.resetTapped = resetTapped
        self.logTapped = logTapped
    }
    
    public var body: some View {
        List {
            Section("General") {
                
                Button(action: {
                    resetTapped()
                }){
                    Text("Reset Database")
                        .foregroundStyle(Color.red)
                }
                
                Toggle("Remote Log", isOn: $isRemoteLog)
                Toggle("Local Log", isOn: $isLocalLog)
                if(isLocalLog) {
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

