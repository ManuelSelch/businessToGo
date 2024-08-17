import Foundation
import Redux

import KimaiCore

struct AssistantComponent: ViewModel {
    typealias DState = AppFeature.State
    typealias DAction = AppFeature.Action
    
    struct State: ViewState {
        var steps: [KimaiAssistantStep]
        var currentStep: KimaiAssistantStep?
        
        static func from(_ state: AppFeature.State) -> State {
            var currentStep: KimaiAssistantStep?
            
            if(state.kimai.customers.count == 0) {
                currentStep = .customer
            } else if(state.kimai.projects.count == 0) {
                currentStep = .project
            } else if(state.kimai.activities.count == 0) {
                currentStep = .activity
            } else if(state.kimai.timesheets.count == 0) {
                currentStep = .timesheet
            }
            
            return State(steps: KimaiAssistantStep.allCases, currentStep: currentStep)
        }
    }
    
    enum Action: ViewAction {
        case stepTapped(KimaiAssistantStep?)
        case dashboardTapped
        
        var lifted: AppFeature.Action {
            switch self {
            case let .stepTapped(step):
                return .component(.assistant(.stepTapped(step)))
            case .dashboardTapped:
                return .component(.assistant(.dashboardTapped))
            }
        }
    }
    
    enum UIAction: Equatable, Codable {
        case stepTapped(KimaiAssistantStep?)
        case dashboardTapped
    }
    
    static func reduce(_ state: inout AppFeature.State, _ action: UIAction) -> Effect<AppFeature.Action> {
        switch(action) {
        case let .stepTapped(step):
            switch(step) {
            case .customer:
                state.router.presentSheet(.management(.kimai(.customerSheet(.new))))
            case .project:
                state.router.presentSheet(.management(.kimai(.projectSheet(.new))))
            case .activity:
                state.router.presentSheet(.management(.kimai(.activitySheet(.new))))
            case .timesheet:
                state.router.presentSheet(.management(.kimai(.timesheetSheet(.new))))
            default:
                break
            }
        case .dashboardTapped:
            state.router.presentTabScreen(.management, route: .management(.kimai(.customersList)))
        }
        return .none
    }
}
