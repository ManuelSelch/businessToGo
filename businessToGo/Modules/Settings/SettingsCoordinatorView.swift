import SwiftUI
import ComposableArchitecture
import TCACoordinators

struct SettingsCoordinatorView: View {
    let store: StoreOf<SettingsCoordinator>
    
    @State var projectView: KimaiProject?

    var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            switch(screen.case) {
            case let .settings(store):
                SettingsView(store: store)
            case let .integrations(store):
                IntegrationsView(store: store)
            case let .debug(store):
                DebugView(store: store)
            case let .log(store):
                LogView(store: store)
            }
        }
    }
}
