import Foundation
import OfflineSync

public struct TaigaUserAuthDetail: TableProtocol, Decodable, Equatable {
    // var accepted_terms: Bool
    public var auth_token: String
    // var big_photo: String
    // var bio: String
    // var color: String
    public var email: String
    // var full_name: String
    // var full_name_display: String
    public var id: Int
    // var is_active: Bool
    // var lang: String
    // var photo: String
    // var read_new_terms: Bool
    // var refresh: String
    // var roles: [String]
    // var theme: String
    // var timezone: String
    // var total_private_projects: Int
    // var total_public_projects: Int
    public var username: String
    public var uuid: String
    
    public init(){
        id = 0
        auth_token = ""
        email = ""
        // roles = []
        username = ""
        uuid = ""
    }
}
