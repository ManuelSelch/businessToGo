import SwiftUI

struct KimaiLoginView: View {
    
    let account: Account
    
    let backTapped: () -> ()
    let loginTapped: (Account) -> ()
    
    @State private var server: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    
    public var body: some View {
        HStack {
            Spacer()
            
            VStack {
                Spacer()
                
                ZStack {
                    Text("Kimai Login")
                        .font(.title)
                    
                    HStack {
                        Button(action : {
                            backTapped()
                        }){
                            Image(systemName: "arrow.left")
                                .font(.system(size: 25))
                                .foregroundColor(Color.blackWhite)
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

