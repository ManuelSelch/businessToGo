import Foundation
import OfflineSync

struct TaigaProject: TableProtocol, Codable, Identifiable, Equatable, Hashable {
    var id: Int
    var is_backlog_activated: Bool
    var logo_big_url: String?
    var name: String
    var description: String
    var total_story_points: Double?
    var total_milestones: Int?
}

extension TaigaProject {
    init() {
        id = 0
        is_backlog_activated = false
        logo_big_url = ""
        name = ""
        description = ""
        total_story_points = 0
        total_milestones = 0
    }
    
    static let sample = Self(
        id: 1,
        is_backlog_activated: true,
        name: "Sample Project",
        description: "Sample Project Description"
    )
    
}

struct TaigaOwner: Codable, Equatable {
    var big_photo: String?
    var full_name_display: String
    var gravatar_id: String
    var id: Int
    var is_active: Bool
    var photo: String?
    var username: String
}
