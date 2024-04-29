import SwiftUI
import Redux

struct LoginView: View {
    @EnvironmentObject var store: Store<LoginState, LoginAction, Environment>
    
    var body: some View {
        switch(store.state.scene){
        case .accounts:
            AccountsView()
        case .kimai:
            KimaiLoginView()
        case .taiga:
            TaigaLoginView()
        }
    }
}
