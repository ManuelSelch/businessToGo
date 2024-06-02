import SwiftUI
import Redux

struct AppTabView: View {
    let store: StoreOf<AppFeature>
    
    var body: some View {
        Text("TabView")
        /*
        switch(store.state.tab){
        case .login:
            AppRoute.login.createView(store)
        default:
            
            TabView(
                selection: Binding(
                    get: { store.state.tab },
                    set: { store.send(.tab($0)) }
                )
            ) {
                createTab(.management)
                createTab(.report)
            }
        }
         */
    }
    
    /*
    @ViewBuilder
    func createTab(_ tab: AppRoute) -> some View {
        tab.createView(store)
            .tag(tab)
            .tabItem {tab.label }
    }
     */
}


