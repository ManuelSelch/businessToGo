import Foundation
import ComposableArchitecture

@Reducer
struct KimaiProjectDetailFeature {
    @ObservableState
    struct State: Equatable {
        var project: KimaiProject
        var customer: KimaiCustomer?
        
        @Shared var activities: [KimaiActivity]
        @Shared var timesheets: RequestModule<KimaiTimesheet, KimaiRequest>.State
        @Shared var users: [KimaiUser]
    }
    
    enum Action {
        case deleteTapped(KimaiTimesheet)
        case editTapped(KimaiTimesheet)
        
        case delegate(Delegate)
    }
    
    enum Delegate {
        case delete(KimaiTimesheet)
        case edit(KimaiTimesheet)
    }
    
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch(action) {
        case let .deleteTapped(timesheet):
            return .send(.delegate(.delete(timesheet)))
        case let .editTapped(timesheeet):
            return .send(.delegate(.edit(timesheeet)))
        
        case .delegate:
            return .none
        }
    }
}

