import Foundation
import Redux

import KimaiCore

struct TodayComponent: ViewModel {
    typealias DState = AppFeature.State
    typealias DAction = AppFeature.Action
    
    struct State: ViewState {
        var customers: [KimaiCustomer]
        var projects: [KimaiProject]
        var activities: [KimaiActivity]
        var timesheets: [KimaiTimesheet]
        
        static func from(_ state: AppFeature.State) -> State {
            return State(
                customers: state.kimai.customers,
                projects: state.kimai.projects,
                activities: state.kimai.activities,
                timesheets: state.kimai.timesheets.filter({ $0.getBeginDate()?.isWeekOfYear(of: Date.today) ?? false })
            )
        }
    }
    
    enum Action: ViewAction {
        case customerTapped(Int)
        case projectTapped(Int)
        case timesheetSaveTapped(KimaiTimesheet)
        
        var lifted: AppFeature.Action {
            switch self {
            case let .customerTapped(customer): return .component(.today(.customerTapped(customer)))
            case let .projectTapped(project): return .component(.today(.projectTapped(project)))
            case let .timesheetSaveTapped(timesheet): return .component(.today(.timesheetSaveTapped(timesheet)))
            }
        }
    }
    
    enum Route: Equatable, Codable, Hashable {
        case today
        case projects(for: Int)
        case timesheet(for: Int)
    }
    
    enum UIAction: Equatable, Codable {
        case customerTapped(Int)
        case projectTapped(Int)
        case timesheetSaveTapped(KimaiTimesheet)
    }
    
    
    
    static func reduce(_ state: inout AppFeature.State, _ action: UIAction) -> Effect<AppFeature.Action> {
        switch(action) {
        case let .customerTapped(customer):
            state.router.presentSheet(.today(.projects(for: customer)))
            
        case let .projectTapped(project):
            state.router.push(.today(.timesheet(for: project)))
            
        case let .timesheetSaveTapped(timesheet):
            state.router.dismiss()
            return .send(.kimai(.timesheet(.save(timesheet))))
        }
        return .none
    }
}
