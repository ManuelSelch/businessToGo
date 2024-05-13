import Foundation
import OfflineSync

struct KimaiCustomer: TableProtocol {
    var id: Int
    var name: String
    var number: String?
    var color: String?
}

extension KimaiCustomer {
    init() {
        id = -1
        name = ""
        number = ""
        color = ""
    }
    
    static let new = KimaiCustomer()
}
