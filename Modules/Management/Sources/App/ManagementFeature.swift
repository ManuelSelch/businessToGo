import Foundation
import Combine
import Redux
import Dependencies

import ManagementCore
import ManagementServices
import KimaiCore
import KimaiApp
import TaigaCore
import TaigaApp

public struct ManagementFeature: Reducer {
    @Dependency(\.database) var database
    @Dependency(\.integrations) var integrations
    
    public init() {}
    
    public struct State: Equatable, Codable {
        public init() {}
        
        public var router: RouterFeature<ManagementRoute>.State = .init(root: .kimai(.customersList))
        
        var kimai: KimaiFeature.State = .init()
        var taiga: TaigaFeature.State = .init()
        var integrations: [Integration] = []
        
        public var title: String {
            switch(router.currentRoute) {
            case .assistant:
                return "Setup"
            case let .kimai(route):
                return kimai.title(route)
            case let .taiga(route):
                return taiga.title(route)
            }
        }
    }
    
    public enum Action: Codable, Equatable {
        case sync
        case internalAction(InternalAction)
    }
    
    public struct InternalAction: Codable, Equatable {
        enum Action: Codable, Equatable {
            case connect(_ kimaiProject: Int, _ taigaProject: Int)
            case playTapped(KimaiTimesheet)
            case timesheetTapped(KimaiTimesheet)
            case stopTapped(KimaiTimesheet)
             
            
            case kimai(KimaiFeature.Action)
            case taiga(TaigaFeature.Action)
            
            case resetDatabase
            
            case router(RouterFeature<ManagementRoute>.Action)
        }
        
        let action: Action
        
        init(_ action: Action) {
            self.action = action
        }
    }
}


extension ManagementFeature.Action {
    static func intern(_ action: ManagementFeature.InternalAction.Action) -> ManagementFeature.Action {
        return .internalAction(.init(action))
    }
}

