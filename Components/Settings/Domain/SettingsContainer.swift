import SwiftUI
import Redux
import Dependencies

struct SettingsContainer: View {
    @Dependency(\.router)  var router
    var store: ViewStoreOf<SettingsComponent>
    let route: SettingsComponent.Route
    
    var body: some View {
        VStack {
            switch(route) {
            case .settings:
                SettingsView(
                    integrationsTapped: { router.push(.settings(.integrations)) },
                    debugTapped: { router.push(.settings(.debug)) },
                    introTapped: { router.push(.intro) },
                    logoutTapped: { router.dismiss(); store.send(.logoutTapped) }
                )
            case .integrations:
                IntegrationsView(
                    customers: store.state.customers,
                    projects: store.state.projects,
                    integrations: store.state.integrations,
                    
                    onConnect: { store.send(.onConnect($0, $1)) }
                )
            case .debug:
                DebugView(
                    account: store.state.account,
                    
                    isRemoteLog: store.binding(for: \.isRemoteLog, action: SettingsComponent.Action.onRemoteLogChanged),
                    isMock: store.binding(for: \.isMock, action: SettingsComponent.Action.onMockChanged),
                    
                    resetTapped: { store.send(.resetTapped) },
                    logTapped: { router.push(.settings(.log)) }
                )
            case .log:
                LogView()
            }
        }
    }
}

