import Foundation
import OfflineSync

public struct KimaiUser: TableProtocol {
    public var id: Int
    public var username: String
}


extension KimaiUser {
    public init() {
        id = -1
        username = ""
    }
    
    
    static let new = KimaiUser()
    static let sample = Self(id: 1, username: "Sample User")
}
