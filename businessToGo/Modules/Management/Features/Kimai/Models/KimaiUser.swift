import Foundation
import OfflineSync

struct KimaiUser: TableProtocol {
    var id: Int
    var username: String
}


extension KimaiUser {
    init() {
        id = -1
        username = ""
    }
    
    
    static let new = KimaiUser()
    static let sample = Self(id: 1, username: "Sample User")
}