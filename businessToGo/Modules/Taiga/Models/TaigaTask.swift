import Foundation

struct TaigaTask: TableProtocol, Decodable, Identifiable, Equatable {
    var id: Int
    var subject: String
    var user_story: Int
    
    init(){
        id = 0
        subject = ""
        user_story = 0
    }
}
