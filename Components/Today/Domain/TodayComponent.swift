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
        case timesheetSaveTapped(KimaiTimesheet)
        
        var lifted: AppFeature.Action {
            switch self {
            case let .timesheetSaveTapped(timesheet): return .kimai(.timesheet(.save(timesheet)))
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
}
