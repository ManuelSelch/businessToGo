import SwiftUI

import CommonUI
import LoginCore

public struct TaigaLoginView: View {
    
    let account: Account
    
    let saveTapped: (Account) -> ()
    let logoutTapped: () -> ()
    
    @State private var server: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    
    public init(
        account: Account,
        saveTapped: @escaping (Account) -> Void,
        logoutTapped: @escaping () -> Void
    ) {
        self.account = account
        self.saveTapped = saveTapped
        self.logoutTapped = logoutTapped
    }
    
    public var body: some View {
        VStack {            
            Text("Taiga Login")
                .bold()
            
            TextField("Server", text: $server)
                .keyboardType(.URL)
                .textContentType(.URL)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                var account = account
                account.taiga = AccountData(username, password, server)
                saveTapped(account)
            }) {
                Text("Save")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            
            if(account.taiga != nil) {
                Button(action: logoutTapped) {
                    Text("Logout")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            
            
            Spacer()
        }
        .padding()
        .onAppear {
            self.username = account.taiga?.username ?? ""
            self.password = account.taiga?.password ?? ""
            self.server = account.taiga?.server ?? ""
        }
    }
}

