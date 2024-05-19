import Foundation
import Redux

class SettingsRouter: Router, Codable {
    var routes: [SettingsRoute] = []
    var isSidebar = false
    
    var title: String {
        switch(routes.last){
        case .debug: return "Debug"
        case .integrations: return "Integrations"
        case .none: return "Einstellungen"
        }
    }
}

enum SettingsRoute: Codable {
    case integrations
    case debug
}
