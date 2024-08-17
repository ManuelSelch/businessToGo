import SwiftUI
import Redux

import LoginApp
import LoginUI

struct LoginContainer: View {
    var store: Store<LoginComponent.State, LoginComponent.Action>
    var route: LoginFeature.Route
    
    var body: some View {
        switch(route){
        case .accounts:
            AccountsView(
                accounts: store.state.accounts,
                
                createAccountTapped: { store.send(.createTapped) },
                assistantTapped: { store.send(.assistantTapped) },
                loginTapped: { store.send(.loginTapped($0.identifier)) },
                deleteTapped: { store.send(.deleteTapped($0.identifier)) },
                editTapped: { store.send(.editTapped($0.identifier)) },
                resetTapped: { store.send(.resetTapped) }
            )
            .onAppear {
                store.send(.onAppear)
            }
        case .account(let id):
            if let account = store.state.accounts.first(where: {$0.identifier == id}) {
                AccountView(
                    account: account,
                    
                    kimaiAccountTapped: { store.send(.kimaiAccountTapped) },
                    taigaAccountTapped: { store.send(.taigaAccountTapped) },
                    nameSaveTapped: { store.send(.nameSaveTapped($0)) }
                )
            } else {
                Text("error: account not found")
            }
        case .kimai(let id):
            if let account = store.state.accounts.first(where: {$0.identifier == id}) {
                KimaiLoginView(
                    account: account,
                    saveTapped: { store.send(.accountSaveTapped($0)) },
                    logoutTapped: { store.send(.kimaiLogoutTapped) }
                )
            } else {
                Text("error: account not found")
            }
        case .taiga(let id):
            if let account = store.state.accounts.first(where: {$0.identifier == id}) {
                TaigaLoginView(
                    account: account,
                    saveTapped: { store.send(.accountSaveTapped($0)) },
                    logoutTapped: { store.send(.taigaLogoutTapped) }
                )
            } else {
                Text("error: account not found")
            }
        }
    }
}
