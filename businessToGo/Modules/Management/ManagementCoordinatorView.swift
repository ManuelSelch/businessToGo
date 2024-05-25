import SwiftUI
import ComposableArchitecture
import TCACoordinators

struct ManagementCoordinatorView: View {
    @Bindable var store: StoreOf<ManagementCoordinator>
    
    var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            VStack {
                switch(screen.case) {
                case let .kimai(store):
                    KimaiCoordinatorView(store: store)
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ManagementHeaderView(
                        selectedTeam: $store.kimai.selectedTeam.sending(\.kimai.teamSelected),
                        route: store.routes.last?.screen, // todo: pass current route
                        projects: store.kimai.projects.records,
                        teams: store.kimai.teams.records,
                        syncTapped: {},
                        projectTapped: { _ in },
                        playTapped: { store.send(.playTapped($0)) }
                    )
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

