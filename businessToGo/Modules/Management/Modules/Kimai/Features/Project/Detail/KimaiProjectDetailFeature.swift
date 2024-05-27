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
        
        var timesheetsFeature: KimaiTimesheetsListFeature.State!
        
        init(
            project: KimaiProject,
            customer: KimaiCustomer?,
            activities: Shared<[KimaiActivity]>,
            timesheets: Shared<RequestModule<KimaiTimesheet, KimaiRequest>.State>,
            users: Shared<[KimaiUser]>
        )
        {
            self.project = project
            self.customer = customer
            
            self._activities = activities
            self._timesheets = timesheets
            self._users = users
            
            self.timesheetsFeature = .init(
                project: project,
                timesheets: $timesheets,
                activities: $activities
            )
        }
    }
    
    enum Action {
        case timesheetsFeature(KimaiTimesheetsListFeature.Action)
        case delegate(Delegate)
    }
    
    enum Delegate {
        case delete(KimaiTimesheet)
        case edit(KimaiTimesheet)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.timesheetsFeature, action: \.timesheetsFeature) {
            KimaiTimesheetsListFeature()
        }
        Reduce { state, action in
            switch(action) {
            case let .timesheetsFeature(.delegate(delegate)):
                switch(delegate) {
                case let .delete(timesheet):
                    return .send(.delegate(.delete(timesheet)))
                case let .edit(timesheet):
                    return .send(.delegate(.edit(timesheet)))
                }
            case .delegate, .timesheetsFeature:
                return .none
            }
        }
    }
}

