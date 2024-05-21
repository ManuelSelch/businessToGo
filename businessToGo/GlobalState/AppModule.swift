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
        var settings: SettingsModule.State = .init()
        var intro: IntroModule.State = .init()
    }
    
    enum Action {
        case route(RouteModule<AppRoute>.Action)
        case tab(AppRoute)
        
        case log(LogAction)
        case login(LoginModule.Action)
        case management(ManagementModule.Action)
        case settings(SettingsModule.Action)
        case intro(IntroModule.Action)
    }
    
    

    struct Dependency {
        var test: String = "a"
        
        // MARK: - modules
        var log: Log.LogDependency
        var management: ManagementModule.Dependency
        var settings: SettingsModule.Dependency
        
        // MARK: - services
        var keychain: KeychainService<Account>
        
        static let live = Dependency(
            log: .init(), management: .live, settings: .init(), keychain: .init("de.selch.businessToGo")
        )
        
        static let mock = Dependency(
            log: .init(), management: .mock, settings: .init(), keychain: .init("de.selch.businessToGo")
        )
        
        mutating func changeTest(){
            test = "b"
        }
    }


}
