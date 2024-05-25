import Foundation
import ComposableArchitecture

@Reducer
struct KimaiProjectsListFeature {
    @ObservableState
    struct State: Equatable {
        var customer: Int
        @Shared var timesheets: [KimaiTimesheet]
        @Shared var projects: RequestModule<KimaiProject, KimaiRequest>.State
    }
    
    enum Action {
        case projectTapped(Int)
        case projectEditTapped(KimaiProject)
        
        case delegate(Delegate)
    }
    
    enum Delegate {
        case showProject(Int)
        case editProject(KimaiProject)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch(action) {
        case let .projectTapped(id):
            return .send(.delegate(.showProject(id)))
        case let .projectEditTapped(project):
            return .send(.delegate(.editProject(project)))
            
        case .delegate:
            return .none
        }
    }
}
