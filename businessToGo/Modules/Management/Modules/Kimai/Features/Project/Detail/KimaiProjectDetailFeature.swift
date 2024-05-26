import Foundation
import ComposableArchitecture

@Reducer
struct KimaiProjectDetailFeature {
    @ObservableState
    struct State: Equatable {
        var project: KimaiProject
        var customer: KimaiCustomer?
        
        @Shared var activities: [KimaiActivity]
        @Shared var timesheets: [KimaiTimesheet]
        @Shared var users: [KimaiUser]
    }
    
    enum Action {
        
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        return .none
    }
}

