import Foundation
import OfflineSync

struct TaigaMilestone: TableProtocol, Identifiable, Decodable, Equatable {
    var id: Int
    
    var closed: Bool
    var closed_points: Double?
    var name: String
    var project: Int
    var total_points: Double?
}

extension TaigaMilestone {
    init(){
        id = 0
        closed = false
        closed_points = 0
        name = ""
        project = 0
        total_points = 0
    }
    
    static let sample = Self(
        id: 1,
        closed: false,
        name: "Sample Milestone",
        project: 1
    )
}
