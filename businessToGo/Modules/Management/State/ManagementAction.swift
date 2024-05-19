import Foundation

enum ManagementAction {
    case route(RouteAction<ManagementRoute>)
    case sync
    case connect(_ kimaiProject: Int, _ taigaProject: Int)
    
    case kimai(KimaiAction)
    case taiga(TaigaAction)
    
    case resetDatabase
}
