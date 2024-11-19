import Foundation
import Log

enum RouteAction<Route: Codable>: Codable {
    case push(Route)
    case set([Route])
    case pop
    
    case presentSheet(Route)
    case dismissSheet
}

