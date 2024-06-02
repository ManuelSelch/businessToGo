import Foundation
import OfflineSync

struct TaigaTask: TableProtocol, Decodable, Identifiable, Equatable {
    var id: Int
    var subject: String
    var user_story: Int
}

extension TaigaTask {
    init(){
        id = 0
        subject = ""
        user_story = 0
    }
    
    static let sample = Self(
        id: 1,
        subject: "Sample Task",
        user_story: 1
    )
}
