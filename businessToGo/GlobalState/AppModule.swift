import Foundation
import Log
import Redux
import Login

struct AppModule {
    struct State: Codable {
        var tab: AppRoute = .login
        var sheet: AppRoute?
        
        var log: LogState = .init()
        var login: LoginModule.State = .init()
        var management: ManagementModule.State = .init()
        var settings: SettingsState = .init()
    }
    
    enum Action {
        case route(RouteAction<AppRoute>)
        case tab(AppRoute)
        
        case log(LogAction)
        case login(LoginModule.Action)
        case management(ManagementModule.Action)
        case settings(SettingsAction)
    }
    
    

    struct Dependency {
        // MARK: - modules
        var log: Log.LogDependency = .init()
        var management: ManagementModule.Dependency = .init()
        var settings: SettingsDependency = .init()
        
        // MARK: - services
        var keychain: KeychainService<Account> = .init("de.selch.businessToGo")
    }


}
