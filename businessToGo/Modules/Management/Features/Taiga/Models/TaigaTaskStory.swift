import Foundation
import OfflineSync

struct TaigaTaskStory: TableProtocol, Identifiable, Decodable, Equatable {
    var id: Int
    var version: Int
    var subject: String
    var status: Int
    var milestone: Int?
}

extension TaigaTaskStory {
    init(){
        id = 0
        version = 0
        subject = ""
        status = 0
        milestone = 0
    }
    
    static let sample = Self(
        id: 1,
        version: 1,
        subject: "Subject",
        status: 1
    )
}
