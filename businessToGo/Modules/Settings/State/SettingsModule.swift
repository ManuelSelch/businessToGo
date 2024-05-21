import Foundation
import Redux

struct SettingsModule {
    struct State: Codable {
        var router: RouteModule<SettingsRoute>.State = .init()
    }
    
    enum Action {
        case route(RouteModule<SettingsRoute>.Action)
    }
    
    struct Dependency {
        
    }
    
   
}
