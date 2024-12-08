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
        case stopTapped(KimaiTimesheet)
        case teamSelected(Int?)
        
        var lifted: AppFeature.Action {
            switch self {
            case .sync: return .sync
            case let .teamSelected(id): return .kimai(.customer(.teamSelected(id)))
                
            case var .stopTapped(timesheet):
                timesheet.end = "\(Date.now)"
                return .kimai(.timesheet(.save(timesheet)))
            }
        }
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
