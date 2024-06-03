import Foundation
import OfflineSync

public struct KimaiProject: TableProtocol, Hashable {
    public var id: Int
    public var customer: Int
    public var name: String
    public var globalActivities: Bool
    public var color: String?
    public var visible: Bool
}


extension KimaiProject {
    public init(){
        id = -1
        customer = 0
        name = ""
        globalActivities = true
        color = nil
        visible = true
    }
    
    public static let new = KimaiProject()
    public static let sample = KimaiProject(
        id: 1,
        customer: 1,
        name: "Projekt 1",
        globalActivities: false,
        visible: true
    )
}
