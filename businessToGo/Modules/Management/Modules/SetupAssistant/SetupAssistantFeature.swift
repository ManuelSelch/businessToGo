import Foundation
import ComposableArchitecture

@Reducer
struct SetupAssistantFeature {
    @ObservableState
    struct State: Equatable {
        @SharedReader var customers: Int
        @SharedReader var projects: Int
        @SharedReader var activities: Int
        @SharedReader var timesheets: Int
        
        var currentStep: Int {
            if(customers == 0) {
                return 0
            } else if(projects == 0) {
                return 1
            } else if(activities == 0) {
                return 2
            } else if(timesheets == 0) {
                return 3
            } else {
                return 4
            }
        }
        
        var steps: [String] = [
            "Ersten Kunden anlegen",
            "Erstes Projekt anlegen anlegen",
            "Erste Tätigkeit anlegen",
            "Esten Timesheet Eintrag anlegen"
        ]
    }
    
    enum Action {
        case stepTapped
        
        case delegate(Delegate)
    }
    
    enum Delegate {
        case createCustomer
        case createProject
        case createActivity
        case createTimesheet
        
        case showHome
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch(action) {
        case .stepTapped:
            switch(state.currentStep) {
            case 0:
                return .send(.delegate(.createCustomer))
            case 1:
                return .send(.delegate(.createProject))
            case 2:
                return .send(.delegate(.createActivity))
            case 3:
                return .send(.delegate(.createTimesheet))
            default:
                return .none
            }
            
        case .delegate:
            return .none
        }
    }
}
