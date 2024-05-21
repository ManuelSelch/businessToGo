import Foundation
import Redux
import SwiftUI

enum SettingsRoute: Codable, Hashable, Identifiable {
    case settings
    case integrations
    case debug
    
    var id: Self {self}
}

extension SettingsRoute {
    @ViewBuilder func createView(_ store: StoreOf<AppModule>) -> some View {
        switch self {
        case .settings:
            SettingsView(
                router: { store.send(.route($0)) },
                navigate: { store.send(.settings(.route(.push($0)))) },
                logout: {
                    store.send(.login(.logout))
                    store.send(.route(.dismissSheet))
                }
            )
            
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
                current: store.state.login.current,
                state: store.state,
                onUpdateLog: { store.send(.log(.setLog($0))) },
                onReset: {
                    store.send(.management(.resetDatabase))
                    store.send(.login(.logout))
                    store.send(.route(.dismissSheet))
                }
            )
        }
    }
}
