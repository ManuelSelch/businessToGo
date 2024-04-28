import Foundation

struct AppState: Equatable {
    var log: LogState
    
    var login: LoginState
    var management: ManagementState
}

extension AppState {
    init(){
        log = LogState()
        
        login = LoginState()
        management = ManagementState()
    }
}
