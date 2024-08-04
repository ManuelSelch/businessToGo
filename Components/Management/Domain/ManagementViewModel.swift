import Foundation
import Redux

import KimaiApp
import TaigaApp
import IntegrationApp

import TaigaCore
import KimaiCore

extension ManagementContainer: ViewModel {
    typealias DState = AppFeature.State
    typealias DAction = AppFeature.Action
    
    struct State: ViewState {
        var kimai: KimaiFeature.State
        var taiga: TaigaFeature.State
        var integration: IntegrationFeature.State
        
        static func from(_ state: AppFeature.State) -> Self {
            return State(
                kimai: state.kimai,
                taiga: state.taiga,
                integration: state.integration
            )
        }
    }
    
    enum Action: ViewAction {
        case sync
        case playTapped(KimaiTimesheet)
        case stopTapped(KimaiTimesheet)
        case kimai(KimaiContainer.UIAction)
        
        
        var lifted: AppFeature.Action {
            switch self {
            case .sync: return .sync
            case let .playTapped(timesheet): return .component(.management(.playTapped(timesheet)))
                
            case var .stopTapped(timesheet):
                timesheet.end = "\(Date.now)"
                return .kimai(.timesheet(.save(timesheet)))
                
            case let .kimai(action):
                return .component(.management(.kimai(action)))
            }
        }
    }
    
    enum UIAction: Equatable, Codable {
        case playTapped(KimaiTimesheet)
        case kimai(KimaiContainer.UIAction)
    }
    
    enum Route: Identifiable, Hashable, Codable, Equatable  {
        case kimai(KimaiContainer.Route)
        case taiga(TaigaRoute)
        case assistant
        
        var id: Self {self}
        
        var title: String {
            switch self {
            case let .kimai(route): return route.title
            case .taiga: return "Taiga"
            case .assistant: return "Assistant"
            }
        }
    }
}
