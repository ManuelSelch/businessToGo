import SwiftUI
import Redux

struct SettingsContainer: View {
    @ObservedObject var store: StoreOf<SettingsFeature>
    
    @State var projectView: KimaiProject?

    var body: some View {
        RouterView(store: store.lift(\.router, SettingsFeature.Action.router)) { route in
            VStack {
                switch(route) {
                case .settings:
                    SettingsView(
                        integrationsTapped: { store.send(.settings(.integrationsTapped)) },
                        debugTapped: { store.send(.settings(.debugTapped)) },
                        introTapped: { store.send(.settings(.introTapped)) },
                        logoutTapped: { store.send(.settings(.logoutTapped)) }
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
                        isDebug: store.binding(for: \.isDebug, action: SettingsFeature.Action.isDebugChanged),
                        resetTapped: { store.send(.resetTapped) },
                        logTapped: { store.send(.settings(.logTapped)) }
                    )
                case .log:
                    LogView()
                }
            }
        }
    }
}
