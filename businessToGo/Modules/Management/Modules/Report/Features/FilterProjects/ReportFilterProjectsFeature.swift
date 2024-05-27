import Foundation
import ComposableArchitecture

@Reducer
struct ReportFilterProjectsFeature {
    @ObservableState
    struct State: Equatable {
        @Shared var selectedProject: Int?
        
        @Shared var customers: [KimaiCustomer]
        @Shared var projects: [KimaiProject]
    }
    
    enum Action {
        case projectSelected(Int?)
        case delegate(Delegate)
    }
    
    enum Delegate {
        case selectProject(Int?)
        case dismiss
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch(action) {
        case let .projectSelected(project):
            return .run { send in
                await send(.delegate(.selectProject(project)))
                await send(.delegate(.dismiss))
            }
        case .delegate:
            return .none
        }
    }
}
