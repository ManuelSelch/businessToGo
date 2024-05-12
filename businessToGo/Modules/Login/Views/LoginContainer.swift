import SwiftUI
import Redux

struct LoginContainer: View {
    @EnvironmentObject var store: Store<LoginState, LoginAction, Environment>
    
    var body: some View {
        switch(store.state.scene){
        case .accounts:
            AccountsView()
        case .account(let account):
            AccountView(account: account)
        case .kimai(let account):
            KimaiLoginView(account: account)
        case .taiga(let account):
            TaigaLoginView(account: account)
        }
    }
}
