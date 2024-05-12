import SwiftUI
import Redux

struct SettingsContainer: View {
    @EnvironmentObject var router: SettingsRouter
    @EnvironmentObject var store: Store<AppState, AppAction, Environment>
    
    var body: some View {
        NavigationStack(path: $router.routes){
            SettingsView(
                navigate: navigate,
                logout: { store.send(.login(.logout)) }
            )
                .navigationDestination(for: SettingsRoute.self){ route in
                    switch(route){
                    case .kimaiCustomers:
                        CustomerSettingsView(
                            customer: store.state.management.kimai.customers
                        )
                    case .integrations:
                        IntegrationsView(
                            customers: store.state.management.kimai.customers,
                            projects: store.state.management.kimai.projects,
                            taigaProjects: store.state.management.taiga.projects,
                            integrations: store.state.management.integrations,
                            onConnect: connect
                        )
                    case .debug:
                        DebugView(
                            isLog: store.state.log.isLog,
                            current: store.state.login.current,
                            onUpdateLog: { isLog in
                                store.send(.log(.setLog(isLog)))
                            },
                            onReset: {
                                store.send(.management(.resetDatabase))
                                store.dependencies.router.tab = .management
                                store.dependencies.router.management.routes = []
                            }
                        )
                    }
                }
        }
        .tint(Color.theme)
    }
    
    func navigate(_ route: SettingsRoute){
        router.navigate(route)
    }
    
    func connect(_ kimai: Int, _ taiga: Int){
        store.send(.management(.connect(kimai, taiga)))
    }
}
