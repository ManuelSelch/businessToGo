import SwiftUI

import CommonUI
import LoginCore

public struct DebugView: View {
    let account: Account?
    @Binding var isRemoteLog: Bool
    @Binding var isMock: Bool
    
    let resetTapped: () -> ()
    let logTapped: () -> ()
    
    public init(account: Account?, isRemoteLog: Binding<Bool>, isMock: Binding<Bool>, resetTapped: @escaping () -> Void, logTapped: @escaping () -> Void) {
        self.account = account
        
        self._isRemoteLog = isRemoteLog
        self._isMock = isMock
        
        self.resetTapped = resetTapped
        self.logTapped = logTapped
    }
    
    public var body: some View {
        List {
            Section("General") {
                
                Button("Reset Database", action: resetTapped)
                    .foregroundStyle(Color.red)
                
                Toggle("Remote Log", isOn: $isRemoteLog)
                
                Button("Local Logs", action: logTapped)
                    .foregroundStyle(Color.theme)
                
                Toggle("Mocks", isOn: $isMock)
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
            
        }
        .listStyle(SidebarListStyle())
        .padding()
    }
}

