import Foundation
import Redux

class SettingsRouter: Router {
    @Published var routes: [SettingsRoute] = []
}

enum SettingsRoute {
    case kimaiCustomers
    case integrations
    case debug
    
    case kimaiProjects
}
