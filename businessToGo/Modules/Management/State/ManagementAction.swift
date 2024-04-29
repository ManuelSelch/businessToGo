import Foundation

enum ManagementAction {
    case sync
    
    case kimai(KimaiAction)
    case taiga(TaigaAction)
}
