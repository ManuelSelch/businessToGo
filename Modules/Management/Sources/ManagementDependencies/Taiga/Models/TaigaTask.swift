import Foundation
import OfflineSync

public struct TaigaTask: TableProtocol, Decodable, Identifiable, Equatable {
    public var id: Int
    public var subject: String
    public var user_story: Int
}

extension TaigaTask {
    public init(){
        id = 0
        subject = ""
        user_story = 0
    }
    
    public static let sample = Self(
        id: 1,
        subject: "Sample Task",
        user_story: 1
    )
}
