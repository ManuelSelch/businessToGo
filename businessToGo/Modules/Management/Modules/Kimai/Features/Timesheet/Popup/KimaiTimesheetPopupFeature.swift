import Foundation
import ComposableArchitecture

@Reducer
struct KimaiTimesheetPopupFeature {
    @ObservableState
    struct State {
        var timesheet: KimaiTimesheet
        var customer: KimaiCustomer
        var project: KimaiProject
        var activity: KimaiActivity
    }
    
    enum Action {
        case timesheetTapped
        case stopTapped
        case delegate(Delegate)
    }
    
    enum Delegate {
        case show(KimaiTimesheet)
        case stop(KimaiTimesheet)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch(action) {
        case .timesheetTapped:
            return .send(.delegate(.show(state.timesheet)))
        case .stopTapped:
            return .send(.delegate(.stop(state.timesheet)))
        case .delegate:
            return .none
        }
    }
}
