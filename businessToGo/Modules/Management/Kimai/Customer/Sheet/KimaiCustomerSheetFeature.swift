import Foundation
import ComposableArchitecture

struct KimaiCustomerSheetFeature: Reducer {
    @ObservableState
    struct State: Equatable {
        var customer: KimaiCustomer
        @Shared var teams: [KimaiTeam]
    }
    
    enum Action {
        case saveTapped(KimaiCustomer)
        case delegate(Delegate)
    }
    
    enum Delegate {
        case update(KimaiCustomer)
        case create(KimaiCustomer)
        case dismiss
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch(action){
        case let .saveTapped(customer):
            return .run { send in
                if(customer.id == KimaiCustomer.new.id){
                    await send(.delegate(.create(customer)))
                } else {
                    await send(.delegate(.update(customer)))
                }
                await send(.delegate(.dismiss))
            }
        case .delegate:
            return .none
        }
    }
}
