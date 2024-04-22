import Foundation

struct KimaiProject: TableProtocol {
    var id: Int
    var customer: Int
    var name: String
    
    init(){
        id = 0
        customer = 0
        name = ""
    }
    
}
