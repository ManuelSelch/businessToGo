import Foundation
import ComposableArchitecture

struct KimaiCustomerFeature: Reducer {
    @ObservableState
    struct State: Equatable {
        var customer: KimaiCustomer
        @Shared var teams: [KimaiTeam]
    }
    
    enum Action {
        case saveTapped
        case delegate(Delegate)
    }
    
    enum Delegate {
        case dismiss
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch(action){
        case .saveTapped:
            return .send(.delegate(.dismiss))
        case .delegate:
            return .none
        }
    }
}
