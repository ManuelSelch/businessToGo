import Foundation
import OfflineSync

struct KimaiTeam: TableProtocol {
    var id: Int
    var name: String
    var color: String?
}

extension KimaiTeam {
    init() {
        id = -1
        name = ""
        color = ""
    }
    
    static let new = KimaiTeam()
}
