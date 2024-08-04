import Foundation
import OfflineSync

public struct TaigaTaskStory: TableProtocol, Hashable {
    public var id: Int
    public var version: Int
    public var subject: String
    public var status: Int
    public var milestone: Int?
}

extension TaigaTaskStory {
    public init(){
        id = 0
        version = 0
        subject = ""
        status = 0
        milestone = 0
    }
    
    public static let sample = Self(
        id: 1,
        version: 1,
        subject: "Subject",
        status: 1
    )
}
