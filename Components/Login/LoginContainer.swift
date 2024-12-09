import SwiftUI
import Redux
import Dependencies

import LoginApp
import LoginCore
import LoginUI

struct LoginContainer: View {
    @Dependency(\.router) var router
    var store: Store<LoginComponent.State, LoginComponent.Action>
    var route: LoginFeature.Route
    
    var body: some View {
        switch(route){
        case .accounts:
            AccountsView(
                accounts: store.state.accounts,
                
                createAccountTapped: {
                    let id = store.state.accounts.count
                    let account = Account(id: id)
                    router.push(.login(.account(account.identifier)))
                    store.send(.createTapped(account))
                },
                assistantTapped: { store.send(.assistantTapped) },
                loginTapped: { store.send(.loginTapped($0.identifier)) },
                deleteTapped: { store.send(.deleteTapped($0.identifier)) },
                editTapped: { router.push(.login(.account($0.identifier))) },
                resetTapped: { store.send(.resetTapped) }
            )
            .onAppear {
                store.send(.onAppear)
            }
        case .account(let id):
            if var account = store.state.accounts.first(where: {$0.identifier == id}) {
                AccountView(
                    account: account,
                    
                    kimaiAccountTapped: {
                        router.push(.login(.kimai(id)))
                    },
                    taigaAccountTapped: {
                        router.push(.login(.taiga(id)))
                    },
                    nameSaveTapped: {
                        account.name = $0
                        store.send(.accountSaveTapped(account))
                    }
                )
            } else {
                Text("error: account not found")
            }
        case .kimai(let id):
            if var account = store.state.accounts.first(where: {$0.identifier == id}) {
                KimaiLoginView(
                    account: account,
                    saveTapped: { router.dismiss(); store.send(.accountSaveTapped($0)) },
                    logoutTapped: {
                        router.dismiss()
                        account.kimai = nil
                        store.send(.accountSaveTapped(account))
                    }
                )
            } else {
                Text("error: account not found")
            }
        case .taiga(let id):
            if var account = store.state.accounts.first(where: {$0.identifier == id}) {
                TaigaLoginView(
                    account: account,
                    saveTapped: { store.send(.accountSaveTapped($0)) },
                    logoutTapped: {
                        router.dismiss()
                        account.taiga = nil
                        store.send(.accountSaveTapped(account))
                    }
                )
            } else {
                Text("error: account not found")
            }
        }
    }
}
