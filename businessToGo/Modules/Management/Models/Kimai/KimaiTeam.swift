import Foundation
import OfflineSync

struct KimaiTeam: TableProtocol {
    var id: Int
    var name: String
    var color: String?
    
    init() {
        id = 0
        name = ""
        color = ""
    }
}
