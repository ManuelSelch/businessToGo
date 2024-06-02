import SwiftUI
import Log
import Redux

struct AppContainer: View {
    @ObservedObject var store: StoreOf<AppFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            AppHeader(
                title: "Hello World 02",
                settingsTapped: { store.send(.settingsTapped) }
            )
            
            if(store.state.tab == .login) {
                LoginContainer(
                    store: store.lift(\.login, AppFeature.Action.login)
                )
            } else {
                TabView(selection:
                    store.binding(for: \.tab, action: AppFeature.Action.tabSelected)
                ){
                    AppRoute.management.view(store)
                        .tabItem { Label("Projekte", systemImage: "shippingbox.fill") }
                        .tag(AppRoute.management)
                    
                    AppRoute.report.view(store)
                        .tabItem { Label("Reports", systemImage: "chart.bar.xaxis.ascending") }
                        .tag(AppRoute.report)
                }
            }
            
        }
        
        
        .sheet(item: store.binding(for: \.sheet, action: AppFeature.Action.sheetSelected)) { route in
            route.view(store)
        }
         
        
        .onAppear {
            store.send(.intro(.load))
        }
    }
}
