import Foundation
import OfflineSync

struct TaigaUserAuthDetail: TableProtocol, Decodable, Equatable {
    // var accepted_terms: Bool
    var auth_token: String
    // var big_photo: String
    // var bio: String
    // var color: String
    var email: String
    // var full_name: String
    // var full_name_display: String
    var id: Int
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
    var username: String
    var uuid: String
    
    init(){
        id = 0
        auth_token = ""
        email = ""
        // roles = []
        username = ""
        uuid = ""
    }
}
