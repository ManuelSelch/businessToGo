import SwiftUI
import ComposableArchitecture
import TCACoordinators

struct ManagementCoordinatorView: View {
    let store: StoreOf<ManagementCoordinator>
    
    var body: some View {
        VStack {
            // TODO: add header
            // ManagementHeaderView(projects: <#T##[KimaiProject]#>, teams: <#T##[KimaiTeam]#>, router: <#T##(RouteModule<ManagementRoute>.Action) -> Void#>, onSync: <#T##() -> Void#>)
            TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
                switch(screen.case) {
                case let .kimai(store):
                    KimaiCoordinatorView(store: store)
                    
                }
            }
        }
    }
}

#Preview {
    ManagementCoordinatorView(
        store: .init(initialState: ManagementCoordinator.State()) {
            ManagementCoordinator()
        }
    
    )
}

