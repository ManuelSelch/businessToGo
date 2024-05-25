import Foundation
import ComposableArchitecture

@Reducer
struct IntegrationsFeature {
    
    @Dependency(\.integrations) var integrations
    
    @ObservableState
    struct State: Equatable {
        @Shared var customers: [KimaiCustomer]
        @Shared var projects: [KimaiProject]
        @Shared var taigaProjects: [TaigaProject]
        @Shared var integrations: [Integration]
    }
    
    enum Action {
        case onConnect(_ kimai: Int, _ taiga: Int)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch(action){
        case let .onConnect(kimai, taiga):
            integrations.setIntegration(kimai, taiga)
            state.integrations = integrations.get()
            return .none
        }
    }
}
