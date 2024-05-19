import Foundation
import OfflineSync

struct KimaiProject: TableProtocol, Hashable {
    var id: Int
    var customer: Int
    var name: String
    var globalActivities: Bool
    var color: String?
    var visible: Bool
}


extension KimaiProject {
    init(){
        id = -1
        customer = 0
        name = ""
        globalActivities = true
        color = nil
        visible = true
    }
    
    static let new = KimaiProject()
}
