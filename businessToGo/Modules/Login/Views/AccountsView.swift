import SwiftUI
import Redux

struct AccountsView: View {
    @EnvironmentObject var store: Store<LoginState, LoginAction>
    
    var body: some View {
        VStack {
            Button(action: {
                store.send(.navigate(.kimai))
            }) {
                HStack {
                    StatusImage(store.state.account.kimai)
                    Text("Kimai")
                }
            }
            
            Button(action: {
                store.send(.navigate(.taiga))
            }) {
                HStack {
                    StatusImage(store.state.account.taiga)
                    Text("Taiga")
                }
            }
            
            Spacer()
            
            Button(action: {
                store.send(.deleteAccount)
            }) {
                Text("Reset")
                    .foregroundStyle(Color.red)
            }
            
            
        }.onAppear {
            store.send(.loadStoredAccount)
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
