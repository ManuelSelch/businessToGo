import Foundation
import ComposableArchitecture

@Reducer
struct KimaiCustomersListFeature {    
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        @Shared var customers: RequestModule<KimaiCustomer, KimaiRequest>.State
    }
    
    enum Action {
        case customerTapped(Int)
        case customerEditTapped(KimaiCustomer)
        
        case delegate(Delegate)
        case alert(PresentationAction<Alert>)
        
        @CasePathable
        enum Alert: Equatable {
            case deleteConfirmed(KimaiCustomer)
        }
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
                state.alert = AlertState {
                    TextState("Alert!")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("Cancel")
                    }
                    ButtonState(action: .deleteConfirmed(customer)) {
                        TextState("Increment")
                    }
                } message: {
                    TextState("This is an alert")
                }
                return .none
        
            case let .alert(.presented(.deleteConfirmed(customer))):
                return .send(.delegate(.editCustomer(customer)))
            
                
            case .delegate, .alert:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
    
}
