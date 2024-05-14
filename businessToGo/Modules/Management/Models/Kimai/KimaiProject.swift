import Foundation
import OfflineSync

struct KimaiProject: TableProtocol {
    var id: Int
    var customer: Int
    var name: String
    var globalActivities: Bool
    var color: String?
}


extension KimaiProject {
    init(){
        id = -1
        customer = 0
        name = ""
        globalActivities = true
        color = nil
    }
    
    static let new = KimaiProject()
}
