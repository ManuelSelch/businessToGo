import Foundation
import OfflineSync

struct KimaiCustomer: TableProtocol {
    var id: Int
    var name: String
    var number: String
}

extension KimaiCustomer {
    init() {
        id = 0
        name = ""
        number = ""
    }
    
    static let new = KimaiCustomer(id: -1, name: "", number: "")
}
