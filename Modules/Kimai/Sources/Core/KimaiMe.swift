import Foundation
import OfflineSyncCore

public struct KimaiMe: TableProtocol, Hashable {
    public var id: Int
    public var username: String
    public var alias: String?
    public var language: String
    public var roles: [String]
    public var color: String?
}

extension KimaiMe {
    public init() {
        id = -1
        username = ""
        alias = nil
        language = ""
        roles = []
        color = nil
    }
    
    static let new = KimaiMe()
}
