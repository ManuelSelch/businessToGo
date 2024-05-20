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
        case route(RouteModule<AppRoute>.Action)
        case tab(AppRoute)
        
        case log(LogAction)
        case login(LoginModule.Action)
        case management(ManagementModule.Action)
        case settings(SettingsAction)
    }
    
    

    struct Dependency {
        // MARK: - modules
        var log: Log.LogDependency
        var management: ManagementModule.Dependency
        var settings: SettingsDependency
        
        // MARK: - services
        var keychain: KeychainService<Account>
        
        static let live = Dependency(
            log: .init(), management: .live, settings: .init(), keychain: .init("de.selch.businessToGo")
        )
        
        static let mock = Dependency(
            log: .init(), management: .mock, settings: .init(), keychain: .init("de.selch.businessToGo")
        )
    }


}
