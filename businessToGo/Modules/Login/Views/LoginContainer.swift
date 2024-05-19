import SwiftUI
import Redux

struct LoginContainer: View {
    @ObservedObject var store: StoreOf<LoginModule>
    
    var body: some View {
        switch(store.state.scene){
        case .accounts:
            AccountsView(
                store: store
            )
        case .account(let account):
            AccountView(
                store: store,
                account: account
            )
        case .kimai(let account):
            KimaiLoginView(
                store: store,
                account: account
            )
        case .taiga(let account):
            TaigaLoginView(
                store: store,
                account: account
            )
        }
    }
}
