import Foundation

struct AppState {
    var scene: AppScreen
    var log: LogState
    
    var login: LoginState
    
    var kimai: KimaiState
    var taiga: TaigaState
}

enum AppScreen {
    case login
    
    case kimai
    case taiga
}

extension AppState {
    init(){
        scene = .login
        log = LogState()
        
        login = LoginState()
        kimai = KimaiState()
        taiga = TaigaState()
    }
}
