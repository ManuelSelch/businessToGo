import Foundation
import OfflineSync

struct KimaiProject: TableProtocol {
    var id: Int
    var customer: Int
    var name: String
    var globalActivities: Bool
    
    
}


extension KimaiProject {
    init(){
        id = -1
        customer = 0
        name = ""
        globalActivities = false
    }
    
    static let new = KimaiProject()
}
