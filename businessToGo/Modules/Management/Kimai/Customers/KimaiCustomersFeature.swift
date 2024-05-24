import Foundation
import ComposableArchitecture

@Reducer
struct KimaiCustomersFeature {    
    @ObservableState
    struct State: Equatable {
        @Shared var customers: RequestModule<KimaiCustomer, KimaiRequest>.State
    }
    
    enum Action {
        case customerTapped(Int)
        case customerEditTapped(KimaiCustomer)
        
        case delegate(Delegate)
    }
    
    enum Delegate {
        case showProject(of: Int)
        case editCustomer(KimaiCustomer)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch(action){
            case let .customerTapped(id):
                return .send(.delegate(.showProject(of: id)))
            case let .customerEditTapped(customer):
                return .send(.delegate(.editCustomer(customer)))
                
            case .delegate:
                return .none
            }
        }
    }
}
