import SwiftUI
import Redux

struct KimaiSettingsContainer: View {
    @EnvironmentObject var store: Store<ManagementState, ManagementAction>
    
    var body: some View {
        KimaiIntegrationsView(
            customers: Env.kimai.customers.get(),
            projects: Env.kimai.projects.get(),
            taigaProjects: Env.taiga.projects.get(),
            integrations: Env.integrations.get(),
            onConnect: connect
        )
    }
    
    func connect(_ kimai: Int, _ taiga: Int){
        store.send(.kimai(.connect(kimai, taiga)))
    }
}
