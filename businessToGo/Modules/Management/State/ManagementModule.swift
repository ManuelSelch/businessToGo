import Foundation
import Redux

struct ManagementModule {
    struct State: Equatable, Codable {
        var routes: [ManagementRoute]
        var sheet: ManagementRoute?
        
        var kimai: KimaiModule.State
        var taiga: TaigaModule.State
        var integrations: [Integration]
        
        init(){
            routes = []
            kimai = .init()
            taiga = .init()
            integrations = []
        }
    }
    
    enum Action {
        case route(RouteAction<ManagementRoute>)
        case sync
        case connect(_ kimaiProject: Int, _ taigaProject: Int)
        
        case kimai(KimaiModule.Action)
        case taiga(TaigaModule.Action)
        
        case resetDatabase
    }
}
