import SwiftUI
import Redux

struct SettingsContainer: View {
    @EnvironmentObject var router: SettingsRouter
    @EnvironmentObject var store: Store<AppState, AppAction, Environment>
    
    @State var projectView: KimaiProject?

    var body: some View {
        NavigationStack(path: $router.routes){
            SettingsView(
                navigate: navigate,
                logout: { store.send(.login(.logout)) }
            )
                .navigationDestination(for: SettingsRoute.self){ route in
                    switch(route){
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
                            state: store.state,
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
        .sheet(item: $projectView){ project in
            KimaiProjectSheet(
                project: project,
                customers: store.state.management.kimai.customers,
                onSave: { project in
                    if(project.id == KimaiProject.new.id){
                        store.send(.management(.kimai(.projects(.create(project)))))
                    }else {
                        store.send(.management(.kimai(.projects(.update(project)))))
                    }
                    projectView = nil
                }
            )
        }
    }
    
    func navigate(_ route: SettingsRoute){
        router.navigate(route)
    }
    
    func connect(_ kimai: Int, _ taiga: Int){
        store.send(.management(.connect(kimai, taiga)))
    }
}
