import Foundation
import Combine
import Redux


struct ManagementFeature: Reducer {
    @Dependency(\.database) var database
    @Dependency(\.integrations) var integrations
    
    struct State: Equatable, Codable {
        var router: RouterFeature<Route>.State = .init(root: .kimai(.customersList))
        
        var kimai: KimaiFeature.State = .init()
        var taiga: TaigaFeature.State = .init()
        var integrations: [Integration] = []
    }
    
    enum Action: Codable {
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
    
    enum Route: Identifiable, Hashable, Codable {
        case kimai(KimaiFeature.Route)
        case taiga(TaigaFeature.Route)
        case assistant
        
        var id: Self {self}
    }

}



