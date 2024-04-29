import SwiftUI
import Redux

struct ManagementContainer: View {
    @EnvironmentObject var router: ManagementRouter
    @EnvironmentObject var store: Store<ManagementState, ManagementAction, ManagementDependency>
    
    var body: some View {
        NavigationStack(path: $router.routes) {
            kimai(.customers)
                .navigationDestination(for: ManagementRoute.self) { route in
                    switch route {
                    case .kimai(let route): kimai(route)
                    case .taiga(let route): taiga(route)
                    }
                }
        }
        
    }
}

extension ManagementContainer {
    @ViewBuilder func kimai(_ route: KimaiRoute) -> some View {
        KimaiContainer(route: route, showTaigaProject: showTaigaProject)
            .environmentObject(store.lift(\.kimai, ManagementAction.kimai, store.dependencies))
            .toolbar {
                
                
                Button(action: {
                    sync()
                }){
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.system(size: 15))
                        .foregroundColor(Color.theme)
                }
                
                Spacer()
            }
    }
    
    @ViewBuilder func taiga(_ route: TaigaScreen) -> some View {
        TaigaContainer(route: route)
            .environmentObject(store.lift(\.taiga, ManagementAction.taiga, store.dependencies))
    }
}

extension ManagementContainer {
    func sync(){
        store.send(.sync)
    }
    
    func showTaigaProject(_ kimaiProject: Int){
        if let integration = store.state.integrations.first(where: {$0.id == kimaiProject})
        {
            router.navigate(.taiga(.project(integration.taigaProjectId)))
        }
    }
}
