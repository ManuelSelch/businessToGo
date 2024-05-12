import Foundation

enum ManagementAction {
    case sync
    case connect(_ kimaiProject: Int, _ taigaProject: Int)
    
    case kimai(KimaiAction)
    case taiga(TaigaAction)
    
    case resetDatabase
}
