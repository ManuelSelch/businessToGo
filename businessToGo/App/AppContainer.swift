import SwiftUI
import Log
import Redux

struct AppContainer: View {
    @ObservedObject var store: StoreOf<AppFeature>
    
    var title: String {
        switch(store.state.tab) {
        case .login:
            return "Login"
        case .management:
            return store.state.management.title
        case .report:
            return "Reports"
        case .settings:
            return "Settings"
        case .intro:
            return "Intro"
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            AppHeader(
                title: store.state.title,
                settingsTapped: { store.send(.settingsTapped) }
            )
            
            if(store.state.tab == .login) {
                AppRoute.login.view(store)
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
