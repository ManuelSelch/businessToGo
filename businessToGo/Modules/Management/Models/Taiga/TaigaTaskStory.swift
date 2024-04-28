import Foundation

struct TaigaTaskStory: TableProtocol, Identifiable, Decodable, Equatable {
    var id: Int
    var version: Int
    var subject: String
    var status: Int
    var milestone: Int?
    
    init(){
        id = 0
        version = 0
        subject = ""
        status = 0
        milestone = 0
    }
}

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
    
    init(){
        id = 0
        is_archived = false
        is_closed = false
        name = ""
        project = 0
    }
}
