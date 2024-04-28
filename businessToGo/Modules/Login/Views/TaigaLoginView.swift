import SwiftUI
// import Redux

struct TaigaLoginView: View {
    @EnvironmentObject private var store: Store<LoginState, LoginAction>
    
    @State private var username: String
    @State private var password: String
    
    public init(){
        self.username = ""
        self.password = ""
    }
    
    public var body: some View {
        VStack {
            ZStack {
                Text("Taiga Login")
                    .font(.title)
                
                HStack {
                    Button(action : {
                        store.send(.navigate(.accounts))
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
            
            

            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                store.send(.check(username, password))
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
    }
}

