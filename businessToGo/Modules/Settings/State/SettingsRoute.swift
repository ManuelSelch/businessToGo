import Foundation
import ComposableArchitecture
import SwiftUI
import PulseUI

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
                // router: { store.send(.route($0)) },
                navigate: { store.send(.settings(.route(.push($0)))) },
                logout: {
                    store.send(.login(.logout))
                    // store.send(.route(.dismissSheet))
                }
            )
            
        case .integrations:
            IntegrationsView(
                customers: store.management.kimai.customers.records,
                projects: store.management.kimai.projects.records,
                taigaProjects: store.management.taiga.projects.records,
                integrations: store.management.integrations,
                onConnect: { store.send(.management(.connect($0, $1))) }
            )
        case .debug:
            ConsoleView(store: .shared)
            /*
            DebugView(
                current: store.login.current,
                state: store.state,
                onUpdateLog: { store.send(.log(.setLog($0))) },
                onReset: {
                    store.send(.management(.resetDatabase))
                    store.send(.login(.logout))
                    // store.send(.route(.dismissSheet))
                }
            )
             */
        }
    }
}
