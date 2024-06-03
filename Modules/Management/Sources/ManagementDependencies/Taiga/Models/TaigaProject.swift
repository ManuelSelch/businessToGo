import Foundation
import OfflineSync

public struct TaigaProject: TableProtocol, Codable, Identifiable, Equatable, Hashable {
    public var id: Int
    public var is_backlog_activated: Bool
    public var logo_big_url: String?
    public var name: String
    public var description: String
    public var total_story_points: Double?
    public var total_milestones: Int?
}

extension TaigaProject {
    public init() {
        id = 0
        is_backlog_activated = false
        logo_big_url = ""
        name = ""
        description = ""
        total_story_points = 0
        total_milestones = 0
    }
    
    public static let sample = Self(
        id: 1,
        is_backlog_activated: true,
        name: "Sample Project",
        description: "Sample Project Description"
    )
    
}

struct TaigaOwner: Codable, Equatable {
    public var big_photo: String?
    public var full_name_display: String
    public var gravatar_id: String
    public var id: Int
    public var is_active: Bool
    public var photo: String?
    public var username: String
}
