import Foundation
import ComposableArchitecture

@Reducer
struct KimaiTimesheetSheetFeature {
    @ObservableState
    struct State: Equatable {
        var timesheet: KimaiTimesheet
        
        @Shared var customers: [KimaiCustomer]
        @Shared var projects: [KimaiProject]
        @Shared var activities: [KimaiActivity]
    }
    
    enum Action {
        case saveTapped(KimaiTimesheet)
        case delegate(Delegate)
    }
    
    enum Delegate {
        case create(KimaiTimesheet)
        case update(KimaiTimesheet)
        case dismiss
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch(action){
        case let .saveTapped(timesheet):
            return .run { send in
                if(timesheet.id == KimaiTimesheet.new.id) {
                    await send(.delegate(.create(timesheet)))
                } else {
                    await send(.delegate(.update(timesheet)))
                }
                await send(.delegate(.dismiss))
            }
        
        case .delegate:
            return .none
        }
    }
}
