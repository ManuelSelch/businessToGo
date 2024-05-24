import SwiftUI
import ComposableArchitecture

struct TaigaLoginView: View {
    var store: StoreOf<LoginModule>
    
    @State private var server: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    
    let account: Account
    
    public var body: some View {
        VStack {
            ZStack {
                Text("Taiga Login")
                    .font(.title)
                
                HStack {
                    Button(action : {
                        store.send(.navigate(.account(account)))
                    }){
                        Image(systemName: "arrow.left")
                            .font(.system(size: 25))
                            .foregroundColor(Color.blackWhite)
                    }
                    Spacer()
                }
                
            }
            
            if store.state.loginStatus == .loading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
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
                store.send(.login(account))
            }) {
                Text("Login")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            
            switch(store.state.loginStatus){
            case .error(let msg):
                Text(msg)
                    .foregroundColor(.red)
            default: EmptyView()
            }
            
        }
        .padding()
        .onAppear {
            self.username = account.taiga?.username ?? ""
            self.password = account.taiga?.password ?? ""
            self.server = account.taiga?.server ?? ""
        }
    }
}

