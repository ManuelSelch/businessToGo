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
                        logTapped: { store.send(.settings(.logTapped)) },
                        introTapped: { store.send(.settings(.introTapped)) },
                        logoutTapped: { store.send(.settings(.logoutTapped)) }
                    )
                case .integrations:
                    IntegrationsView( // TODO: pass kimai & taiga parameters
                        customers: [],
                        projects: [],
                        taigaProjects: [],
                        integrations: [],
                        
                        onConnect: { store.send(.onConnect($0, $1)) }
                    )
                case .debug:
                    DebugView(
                        account: store.state.account,
                        resetTapped: { store.send(.resetTapped) }
                    )
                case .log:
                    LogView()
                }
            }
        }
    }
}
