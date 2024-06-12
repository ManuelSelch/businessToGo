import SwiftUI
import Redux

import LoginUI

public struct LoginContainer: View {
    @ObservedObject var store: StoreOf<LoginFeature>
    
    public init(store: StoreOf<LoginFeature>) {
        self.store = store
    }
    
    public var body: some View {
        switch(store.state.scene){
        case .accounts:
            AccountsView(
                accounts: store.state.accounts,
                
                createAccountTapped: { store.send(.createAccountTapped) },
                assistantTapped: { store.send(.assistantTapped) },
                loginTapped: { store.send(.loginTapped($0)) },
                deleteTapped: { store.send(.deleteTapped($0)) },
                editTapped: { store.send(.editTapped($0)) },
                resetTapped: { store.send(.resetTapped) }
            )
            .onAppear {
                store.send(.onAppear)
            }
        case .account(let account):
            AccountView(
                account: account,
                
                backTapped: { store.send(.backTapped) },
                kimaiAccountTapped: { store.send(.kimaiAccountTapped($0)) },
                taigaAccountTapped: { store.send(.taigaAccountTapped($0)) },
                nameChanged: { store.send(.nameChanged($0)) }
            )
        case .kimai(let account):
            KimaiLoginView(
                account: account,
                
                backTapped: { store.send(.backTapped) },
                loginTapped: { store.send(.loginTapped($0)) }
            )
        case .taiga(let account):
            TaigaLoginView(
                account: account,
                
                backTapped: { store.send(.backTapped) },
                loginTapped: { store.send(.loginTapped($0)) }
            )
        }
    }
}
