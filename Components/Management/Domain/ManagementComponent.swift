import Foundation
import Redux

import KimaiApp
import IntegrationApp

import KimaiCore

struct ManagementComponent: ViewModel {
    typealias DState = AppFeature.State
    typealias DAction = AppFeature.Action
    
    struct State: ViewState {
        var kimai: KimaiFeature.State
        var integration: IntegrationFeature.State
        
        static func from(_ state: AppFeature.State) -> Self {
            return State(
                kimai: state.kimai,
                integration: state.integration
            )
        }
    }
    
    enum Action: ViewAction {
        case sync
        case playTapped(KimaiTimesheet)
        case stopTapped(KimaiTimesheet)
        case timesheetEditTapped(KimaiTimesheet)
        case teamSelected(Int?)
        case projectTapped(Int)
        case settingsTapped
        
        
        var lifted: AppFeature.Action {
            switch self {
            case .sync: return .sync
            case let .playTapped(timesheet): return .component(.management(.playTapped(timesheet)))
            case let .timesheetEditTapped(timesheet): return .component(.kimai(.timesheetEditTapped(timesheet)))
            case let .teamSelected(id): return .kimai(.customer(.teamSelected(id)))
            case let .projectTapped(id): return .component(.kimai(.projectTapped(id)))
            case .settingsTapped: return .component(.management(.settingsTapped))
                
            case var .stopTapped(timesheet):
                timesheet.end = "\(Date.now)"
                return .kimai(.timesheet(.save(timesheet)))
            }
        }
    }
    
    enum UIAction: Equatable, Codable {
        case playTapped(KimaiTimesheet)
        case settingsTapped
    }
    
    enum Route: Identifiable, Hashable, Codable, Equatable  {
        case kimai(KimaiComponent.Route)
        case assistant
        
        var id: Self {self}
        
        var title: String {
            switch self {
            case let .kimai(route): return route.title
            case .assistant: return "Assistant"
            }
        }
    }
}
