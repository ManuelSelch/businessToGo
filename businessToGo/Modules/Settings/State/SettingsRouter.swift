import Foundation
import Redux

class SettingsRouter: Router {
    @Published var routes: [SettingsRoute] = []
    
    var title: String {
        switch(routes.last){
        case .debug: return "Debug"
        case .integrations: return "Integrations"
        case .none: return "Einstellungen"
        }
    }
}

enum SettingsRoute {
    case integrations
    case debug
}
