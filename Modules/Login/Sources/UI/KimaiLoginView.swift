import SwiftUI

import CommonUI
import LoginCore

public struct KimaiLoginView: View {
    
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
                Text("Kimai Login")
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
                account.kimai = AccountData(username, password, server)
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
            self.username = account.kimai?.username ?? ""
            self.password = account.kimai?.password ?? ""
            self.server = account.kimai?.server ?? ""
        }
    }
}

