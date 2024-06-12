import SwiftUI
import Redux

import SettingsUI

public struct SettingsContainer: View {
    @ObservedObject var store: StoreOf<SettingsFeature>
    
    public init(store: StoreOf<SettingsFeature>) {
        self.store = store
    }

    public var body: some View {
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
                        isLocalLog: store.binding(for: \.isLocalLog, action: SettingsFeature.Action.onLocalLogChanged),
                        isRemoteLog: store.binding(for: \.isRemoteLog, action: SettingsFeature.Action.onRemoteLogChanged),
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
