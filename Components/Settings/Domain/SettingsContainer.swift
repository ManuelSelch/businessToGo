import SwiftUI
import Redux

struct SettingsContainer: View {
    var store: ViewStore
    let route: Route
    
    var body: some View {
        VStack {
            switch(route) {
            case .settings:
                SettingsView(
                    integrationsTapped: { store.send(.integrationsTapped) },
                    debugTapped: { store.send(.debugTapped) },
                    introTapped: { store.send(.introTapped) },
                    logoutTapped: { store.send(.logoutTapped) }
                )
            case .integrations:
                IntegrationsView(
                    customers: store.state.customers,
                    projects: store.state.projects,
                    taigaProjects: store.state.taigaProjects,
                    integrations: store.state.integrations,
                    
                    onConnect: { store.send(.onConnect($0, $1)) }
                )
            case .debug:
                DebugView(
                    account: store.state.account,
                    
                    isLocalLog: store.binding(for: \.isLocalLog, action: Action.onLocalLogChanged),
                    isRemoteLog: store.binding(for: \.isRemoteLog, action: Action.onRemoteLogChanged),
                    isMock: store.binding(for: \.isMock, action: Action.onMockChanged),
                    
                    resetTapped: { store.send(.resetTapped) },
                    logTapped: { store.send(.logTapped) }
                )
            case .log:
                LogView()
            }
        }
    }
}

