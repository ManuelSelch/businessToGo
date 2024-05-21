import Foundation
import Redux

struct ManagementModule {
    struct State: Equatable, Codable {
        var router: RouteModule<ManagementRoute>.State = .init()
        
        var kimai: KimaiModule.State = .init()
        var taiga: TaigaModule.State = .init()
        var integrations: [Integration] = []
        
        var report: ReportModule.State = .init()
    }
    
    enum Action {
        case route(RouteModule<ManagementRoute>.Action)
        case sync
        case connect(_ kimaiProject: Int, _ taigaProject: Int)
        
        case kimai(KimaiModule.Action)
        case taiga(TaigaModule.Action)
        case report(ReportModule.Action)
        
        case resetDatabase
    }
}
