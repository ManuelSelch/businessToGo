import SwiftUI
import Redux

struct KimaiSettingsContainer: View {
    @EnvironmentObject var store: Store<ManagementState, ManagementAction, ManagementDependency>
    
    var body: some View {
        KimaiIntegrationsView(
            customers: store.state.kimai.customers,
            projects: store.state.kimai.projects,
            taigaProjects: store.state.taiga.projects,
            integrations: store.state.integrations,
            onConnect: connect
        )
    }
    
    func connect(_ kimai: Int, _ taiga: Int){
        store.send(.kimai(.connect(kimai, taiga)))
    }
}
