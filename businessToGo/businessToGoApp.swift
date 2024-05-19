import SwiftUI
import Combine
import Redux
import Log

@main
struct businessToGoApp: App {
    @StateObject var store = Store(
        initialState: AppState(),
        reducer: AppState.reduce,
        dependencies: AppDependency(),
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
    
    var body: some Scene {
        WindowGroup {
            BusinessToGoView(store: store)
                .scrollContentBackground(.hidden)
        }
    }
}

struct BusinessToGoView: View {
    @ObservedObject var store: Store<AppState, AppAction, AppDependency>
    
    var body: some View {
        VStack(spacing: 0) {
            Header(
                store: store
            )
            
            ZStack {
                AppTabView(store: store)
                
                VStack {
                    Spacer()
                    LogView()
                        .environmentObject(store.lift(\.log, AppAction.log, store.dependencies.log))
                }
            }
            
        }
        .sheet(
            item: Binding(
                get: { store.state.sheet },
                set: {
                    if let route = $0 {
                        store.send(.route(.presentSheet(route)))
                    } else {
                        store.send(.route(.dismissSheet))
                    }
                }
            )
        ){ route in
            route.createView(store)
        }
    }
}

struct AppTabView: View {
    @ObservedObject var store: Store<AppState, AppAction, AppDependency>
    
    var body: some View {
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
    }
    
    @ViewBuilder
    func createTab(_ tab: AppRoute) -> some View {
        tab.createView(store)
            .tag(tab)
            .tabItem {tab.label }
    }
}


