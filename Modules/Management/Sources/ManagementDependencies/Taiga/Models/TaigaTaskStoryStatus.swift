import Foundation
import OfflineSync


public struct TaigaTaskStoryStatus: TableProtocol, Decodable, Identifiable, Equatable {
    // var color: String
    public var id: Int
    public var is_archived: Bool
    public var is_closed: Bool
    public var name: String
    // var order: Int
    public var project: Int
    // var slug: String
    // var wip_limit: Int?
}

extension TaigaTaskStoryStatus {
    public init(){
        id = 0
        is_archived = false
        is_closed = false
        name = ""
        project = 0
    }
    
    public static let sample = Self(
        id: 1,
        is_archived: false,
        is_closed: false,
        name: "Sample Status",
        project: 1
    )
}
