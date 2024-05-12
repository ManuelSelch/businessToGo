import SwiftUI
import Combine
import Redux
import Log

@main
struct businessToGoApp: App {
    var body: some Scene {
        WindowGroup {
            BusinessToGoView()
                .scrollContentBackground(.hidden)
        }
    }
}

struct BusinessToGoView: View {
    let store = Store(
        initialState: AppState(),
        reducer: AppState.reduce,
        dependencies: Environment(),
        middlewares: [
            { state, action, env in
                switch(action){
                    case .log(_): return Empty().eraseToAnyPublisher()
                    default:
                    return LogMiddleware().handle(state.log, action)
                            .map { .log($0) }
                            .eraseToAnyPublisher()
                }
            }
        ],
        errorAction: { error in
            return .log(.error("\(error)"))
        }
    )
    
    @State var showSidebar = false
    
    var body: some View {
        VStack(spacing: 0) {
            Header(
                showSidebar: $showSidebar
            )
            
            ZStack {
                AppTabView()
                
                VStack {
                    Spacer()
                    LogView()
                        .environmentObject(store.lift(\.log, AppAction.log, store.dependencies.log))
                }
                
                Sidebar(showSidebar: $showSidebar)
            }
            
        }
        .environmentObject(store)
        .environmentObject(store.dependencies.router)
    }
}

struct AppTabView: View {
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject var store: Store<AppState, AppAction, Environment>
    
    var body: some View {
        if(router.tab == .login){
            AppScreen.login.createView(store, router)
        }else {
            TabView(selection: $router.tab) {
                createTab(.management)
                createTab(.kimaiSettings)
            }
        }
    }
    
    @ViewBuilder
    func createTab(_ tab: AppScreen) -> some View {
        tab.createView(store, router)
            .tag(tab)
            .tabItem {tab.label }
    }
}


