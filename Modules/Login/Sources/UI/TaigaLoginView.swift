import SwiftUI

import CommonUI
import LoginCore

public struct TaigaLoginView: View {
    
    let account: Account
    
    let backTapped: () -> ()
    let loginTapped: (Account) -> ()
    
    @State private var server: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    
    public init(account: Account, backTapped: @escaping () -> Void, loginTapped: @escaping (Account) -> Void) {
        self.account = account
        self.backTapped = backTapped
        self.loginTapped = loginTapped
    }
    
    public var body: some View {
        VStack {            
            ZStack {
                Text("Taiga Login")
                    .bold()
                
                HStack {
                    Button(action : {
                        backTapped()
                    }){
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20))
                    }
                    Spacer()
                }
                
            }
            
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
                loginTapped(account)
            }) {
                Text("Login")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
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

