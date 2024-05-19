import Foundation
import Log

enum RouteAction<Route: Codable>: Codable {
    case push(Route)
    case set([Route])
    case pop
    
    case presentSheet(Route)
    case dismissSheet
}

enum AppAction {
    case route(RouteAction<AppRoute>)
    case tab(AppRoute)
    
    case log(LogAction)
    
    case login(LoginAction)
    case management(ManagementAction)
    case settings(SettingsAction)
}
