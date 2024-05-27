import Foundation
import ComposableArchitecture

@Reducer
struct ReportFilterFeature {
    @ObservableState
    struct State: Equatable {
        @Shared var selectedProject: Int?
        
        @Shared var customers: [KimaiCustomer]
        @Shared var projects: [KimaiProject]
    }
    
    enum Action {
        case filterProjectsTapped
        
        case delegate(Delegate)
    }
    
    enum Delegate {
        case showFilterProjects
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch(action) {
        case .filterProjectsTapped:
            return .send(.delegate(.showFilterProjects))
        case .delegate:
            return .none
        }
    }
}
