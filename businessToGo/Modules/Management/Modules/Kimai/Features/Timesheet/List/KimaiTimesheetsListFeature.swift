import Foundation
import ComposableArchitecture
import OfflineSync

@Reducer
struct KimaiTimesheetsListFeature {
    @ObservableState
    struct State: Equatable {
        var project: KimaiProject
        
        @Shared var timesheets: RequestModule<KimaiTimesheet, KimaiRequest>.State
        @Shared var activities: [KimaiActivity]
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
        switch(action){
        case let .deleteTapped(timesheet):
            return .send(.delegate(.delete(timesheet)))
        case let .editTapped(timesheeet):
            return .send(.delegate(.edit(timesheeet)))
        case .delegate:
            return .none
        }
    }
}
