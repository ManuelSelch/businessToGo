import SwiftUI

import AppCore

struct TaigaLoginView: View {
    
    let account: Account
    
    let backTapped: () -> ()
    let loginTapped: (Account) -> ()
    
    @State private var server: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    
    public var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                Text("Taiga Login")
                    .font(.title)
                
                HStack {
                    Button(action : {
                        backTapped()
                    }){
                        Image(systemName: "arrow.left")
                            .font(.system(size: 25))
                            .foregroundColor(Color.contrast)
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

