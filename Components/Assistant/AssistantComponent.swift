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
        case test

        var lifted: AppFeature.Action {
            return .sync
        }
    }
 
    
}
