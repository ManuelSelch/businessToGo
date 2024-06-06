import Foundation
import Combine
import Redux
import Dependencies

import TaigaCore
import KimaiCore
import IntegrationsCore

public struct ManagementFeature: Reducer {
    @Dependency(\.database) var database
    @Dependency(\.integrations) var integrations
    
    public init() {}
    
    public struct State: Equatable, Codable {
        public init() {}
        
        var router: RouterFeature<Route>.State = .init(root: .kimai(.customersList))
        
        var kimai: KimaiFeature.State = .init()
        var taiga: TaigaFeature.State = .init()
        var integrations: [Integration] = []
    }
    
    public enum Action: Codable {
        case router(RouterFeature<Route>.Action)
        
        case sync
        case connect(_ kimaiProject: Int, _ taigaProject: Int)
        case playTapped(KimaiTimesheet)
        case timesheetTapped(KimaiTimesheet)
        case stopTapped(KimaiTimesheet)
         
        
        case kimai(KimaiFeature.Action)
        case taiga(TaigaFeature.Action)
        
        case resetDatabase
    }
    
    public enum Route: Identifiable, Hashable, Codable {
        case kimai(KimaiFeature.Route)
        case taiga(TaigaFeature.Route)
        case assistant
        
        public var id: Self {self}
    }

}



