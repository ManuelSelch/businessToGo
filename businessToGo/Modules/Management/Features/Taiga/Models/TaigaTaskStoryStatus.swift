import Foundation
import OfflineSync


struct TaigaTaskStoryStatus: TableProtocol, Decodable, Identifiable, Equatable {
    // var color: String
    var id: Int
    var is_archived: Bool
    var is_closed: Bool
    var name: String
    // var order: Int
    var project: Int
    // var slug: String
    // var wip_limit: Int?
}

extension TaigaTaskStoryStatus {
    init(){
        id = 0
        is_archived = false
        is_closed = false
        name = ""
        project = 0
    }
    
    static let sample = Self(
        id: 1,
        is_archived: false,
        is_closed: false,
        name: "Sample Status",
        project: 1
    )
}
