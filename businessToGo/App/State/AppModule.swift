import Foundation
import Log
import Redux
import ComposableArchitecture
import Login
import Combine
import TCACoordinators

enum AppRoute: Identifiable, Codable {
    case login
    
    case management
    case report
    
    case intro
    case settings
    
    var id: Self {self}
}



@Reducer
struct AppModule {
    
    var env = Dependency.live
    
    @ObservableState
    struct State {
        var tab: AppRoute = .login
        var sheet: AppRoute?
        
        var log: LogModule.State = .init()
        var login: LoginModule.State = .init()
        var management: ManagementCoordinator.State = .init()
        var settings: SettingsModule.State = .init()
        var intro: IntroModule.State = .init()
        
    }
    
    enum Action {
        case tabSelected(AppRoute)
        case sheetSelected(AppRoute?)
        
        case log(LogModule.Action)
        case login(LoginModule.Action)
        case management(ManagementCoordinator.Action)
        case settings(SettingsModule.Action)
        case intro(IntroModule.Action)
    }
    
    
    
    struct Dependency {
        var log: LogModule.Dependency
        var keychain: KeychainService<Account>
        
        static let live = Dependency(
            log: .init(),
            keychain: .live("de.selch.businessToGo")
        )
        
        static let mock = Dependency(
            log: .init(),
            keychain: .mock
        )
    }

 
    var body: some ReducerOf<Self> {
        Scope(state: \State.intro, action: /Action.intro) {
            IntroModule()
        }
        
        Scope(state: \State.login, action: /Action.login) {
            LoginModule()
        }
        
        Scope(state: \State.settings, action: /Action.settings) {
            SettingsModule()
        }
        
        Scope(state: \State.management, action: /Action.management) {
            ManagementCoordinator()
        }
        
        Reduce { state, action in
            
            switch action {
                
            case .tabSelected(let tab):
                state.tab = tab
                return .none
            
            case .sheetSelected(let sheet):
                state.sheet = sheet
                return .none
                
            case .log(let action):
                return Effect.publisher {
                    LogModule.reduce(&state.log, action, env.log)
                        .map { .log($0) }
                        .catch { _ in Empty() }
                }
            
            case let .login(.delegate(action)):
                switch(action){
                case .showLogin:
                    state.tab = .login
                    return .none
                case .showHome:
                    state.tab = .report
                    return .none
                case .syncKimai:
                    return .send(.management(.kimai(.sync)))
                case .syncTaiga:
                    return .send(.management(.taiga(.sync)))
                }
                
            case .intro(.delegate(.showIntro)):
                state.sheet = .intro
                return .none
                
            case .login, .management, .settings, .intro:
                return .none
                
            }
        }
    }
    
    
    

}
