import SwiftUI
import ComposableArchitecture

struct AccountView: View {
    let store: StoreOf<LoginModule>
    let account: Account
    @State var name = ""
    
    
    var body: some View {
        VStack {
            HStack {
                Button(action : {
                    store.send(.backTapped)
                }){
                    Image(systemName: "arrow.left")
                        .padding()
                        .font(.system(size: 20))

                }
                Spacer()
            }
            
            TextField("Workspace", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            
            HStack {
                Spacer()
                VStack {
                    Button(action: {
                        store.send(.navigate(.kimai(account)))
                    }) {
                        HStack {
                            StatusImage(account.kimai)
                            Text("Kimai")
                        }
                    }
                    
                    Button(action: {
                        store.send(.navigate(.taiga(account)))
                    }) {
                        HStack {
                            StatusImage(account.taiga)
                            Text("Taiga")
                        }
                    }
                    
                    Spacer()
                    
                    
                }
                Spacer()
            }
        }
        .background(Color.background)
        .onAppear {
            self.name = account.name
        }
        .onChange(of: name){
            store.send(.nameChanged(name))
        }
    }
    
    struct StatusImage: View {
        var account: AccountData?
        
        init(_ account: AccountData?) {
            self.account = account
        }
        
        var body: some View {
            VStack {
                if account != nil {
                    Image(systemName: "checkmark.circle")
                }else {
                    Image(systemName: "xmark.circle")
                }
            }
            .padding()
            .font(.system(size: 20))
            
        }
    }
}
