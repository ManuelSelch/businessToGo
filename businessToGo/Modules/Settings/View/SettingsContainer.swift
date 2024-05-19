import SwiftUI
import Redux

struct SettingsContainer: View {
    @ObservedObject var store: Store<AppState, AppAction, AppDependency>
    
    @State var projectView: KimaiProject?

    var body: some View {
        NavigationStack(
            path:  Binding(
                get: { store.state.settings.routes },
                set: { store.send(.settings(.route(.set($0)))) }
            )
        ){
            SettingsView(
                navigate: { store.send(.settings(.route(.push($0)))) },
                logout: {
                    store.send(.login(.logout))
                    store.send(.route(.dismissSheet))
                }
            )
                .navigationDestination(for: SettingsRoute.self){ route in
                    switch(route){
                    case .integrations:
                        IntegrationsView(
                            customers: store.state.management.kimai.customers,
                            projects: store.state.management.kimai.projects,
                            taigaProjects: store.state.management.taiga.projects,
                            integrations: store.state.management.integrations,
                            onConnect: { store.send(.management(.connect($0, $1))) }
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
                                store.send(.login(.logout))
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
        
        .edgesIgnoringSafeArea(.bottom)
        .frame(maxWidth: .infinity)
    }
}
