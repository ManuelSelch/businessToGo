import SwiftUI
import ComposableArchitecture

struct KimaiLoginView: View {
    let store: StoreOf<LoginModule>
    
    @State private var server: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    
    let account: Account
    
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
                    account.kimai = AccountData(username, password, server)
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

