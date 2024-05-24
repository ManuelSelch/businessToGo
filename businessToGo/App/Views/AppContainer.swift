import SwiftUI
import ComposableArchitecture
import Log
import TCACoordinators

struct AppContainer: View {
    @Bindable var store: StoreOf<AppModule>
    
    var body: some View {
        VStack(spacing: 0) {
            Header(
                title: "Hello World",
                settingsTapped: { store.send(.sheetSelected(.settings)) }
            )
            
            if(store.tab == .login) {
                LoginContainer(
                    store: store.scope(state: \.login, action: \.login)
                )
            } else {
                
                TabView(selection: $store.tab.sending(\.tabSelected)){
                    AppRoute.management.view(store)
                        .tabItem { Label("Projekte", systemImage: "shippingbox.fill") }
                        .tag(AppRoute.management)
                    
                    AppRoute.report.view(store)
                        .tabItem { Label("Reports", systemImage: "chart.bar.xaxis.ascending") }
                        .tag(AppRoute.report)
                }
            }
            
        }
        .sheet(item: $store.sheet.sending(\.sheetSelected)) { route in
            route.view(store)
        }
        
        .onAppear {
            store.send(.intro(.load))
        }
    }
}
