import Foundation
import Redux

class SettingsRouter: Router {
    @Published var routes: [SettingsRoute] = []
}

enum SettingsRoute {
    case integrations
    case debug
}
