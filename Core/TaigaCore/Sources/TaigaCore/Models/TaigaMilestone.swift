import Foundation
import OfflineSync

public struct TaigaMilestone: TableProtocol, Identifiable, Decodable, Equatable {
    public var id: Int
    
    public var closed: Bool
    public var closed_points: Double?
    public var name: String
    public var project: Int
    public var total_points: Double?
}

extension TaigaMilestone {
    public init(){
        id = 0
        closed = false
        closed_points = 0
        name = ""
        project = 0
        total_points = 0
    }
    
    public static let sample = Self(
        id: 1,
        closed: false,
        name: "Sample Milestone",
        project: 1
    )
}
