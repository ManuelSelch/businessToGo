import Foundation
import Log


struct AppState: Codable {
    var tab: AppRoute
    var sheet: AppRoute?
    
    var log: LogState
    var login: LoginState
    var management: ManagementState
    var settings: SettingsState
}

extension AppState {
    init(){
        tab = .login
        
        log = .init()
        login = .init()
        management = .init()
        settings = .init()
    }
}
