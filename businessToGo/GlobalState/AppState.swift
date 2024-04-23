import Foundation

struct AppState {
    var scene: AppScreen
    var log: LogState
    
    var login: LoginState
    
    var kimai: KimaiState
    var taiga: TaigaState
    
    var sceneTitle: String {
        switch(scene){
        case .login: return "Login"
        case .kimai:
            switch(kimai.scene){
            case .customers: return "Kunden"
            case .chart: return "Statistiken"
            case .customer(let id): return Env.kimai.customers.get(by: id)?.name ?? "Kunde"
            case .project(let id): return Env.kimai.projects.get(by: id)?.name ?? "Projekt"
            case .timesheet(_): return "Zeit"
            }
        case .taiga: return "Projekt"
        case .kimaiSettings: return "Einstellungen"
        }
    }
}

enum AppScreen {
    case login
    case kimai
    case taiga
    
    case kimaiSettings
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
