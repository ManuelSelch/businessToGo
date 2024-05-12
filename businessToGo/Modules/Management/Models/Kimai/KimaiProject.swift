import Foundation
import OfflineSync

struct KimaiProject: TableProtocol {
    var id: Int
    var customer: Int
    var name: String
    
    
    
}


extension KimaiProject {
    init(){
        id = 0
        customer = 0
        name = ""
    }
    
    static let new = KimaiProject(id: -1, customer: 0, name: "")
}
