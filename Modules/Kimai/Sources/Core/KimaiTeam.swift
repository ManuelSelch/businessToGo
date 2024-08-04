import Foundation
import OfflineSync

public struct KimaiTeam: TableProtocol, Hashable {
    public var id: Int
    public var name: String
    public var color: String?
}

extension KimaiTeam {
    public init() {
        id = -1
        name = ""
        color = ""
    }
    
    public static let new = KimaiTeam()
}
