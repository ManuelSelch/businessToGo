import Foundation
import Log
import Redux
import ComposableArchitecture
import Login
import Combine

enum AppRoute: Identifiable, Codable, Equatable {
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
        var intro: IntroModule.State = .init()
        
        var settings: SettingsCoordinator.State!
        
        
        init() {
            settings = .init(current: login.$current, kimai: management.$kimai, taiga: management.$taiga, integrations: management.$integrations)
        }
    }
    
    enum Action {
        case tabSelected(AppRoute)
        case sheetSelected(AppRoute?)
        case settingsTapped
        
        case log(LogModule.Action)
        case login(LoginModule.Action)
        case management(ManagementCoordinator.Action)
        case settings(SettingsCoordinator.Action)
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

 
    var body: some ReducerOf<AppModule> {
        Scope(state: \State.intro, action: /Action.intro) {
            IntroModule()
        }
        
        Scope(state: \State.login, action: /Action.login) {
            LoginModule()
        }
        
        Scope(state: \State.settings, action: /Action.settings) {
            SettingsCoordinator()
        }
        
        Scope(state: \State.management, action: /Action.management) {
            ManagementCoordinator()
        }
        
        Reduce { state, action in
            return reduceSelf(&state, action)
        }
    }
    
    func reduceSelf(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch action {
            
        case .tabSelected(let tab):
            state.tab = tab
            return .none
        
        case .sheetSelected(let sheet):
            state.sheet = sheet
            return .none
        
        case .settingsTapped:
            state.settings.routes.goBackToRoot()
            state.sheet = .settings
            return .none
            
        case .log(let action):
            return Effect.publisher {
                LogModule.reduce(&state.log, action, env.log)
                    .map { .log($0) }
                    .catch { _ in Empty() }
            }
        
        case let .login(.delegate(delegate)):
            switch(delegate){
            case .showLogin:
                state.tab = .login
                return .none
            case .showHome:
                state.tab = .report
                return .none
            case .showAssistant:
                state.management.routes.presentCover(
                    .assistant(.init(
                        customers: state.management.$kimai.customers.records.count,
                        projects: state.management.$kimai.projects.records.count,
                        activities: state.management.$kimai.activities.records.count,
                        timesheets: state.management.$kimai.timesheets.records.count
                    )), embedInNavigationView: true
                )
                state.tab = .management
                return .none
            case .syncKimai:
                return .send(.management(.kimai(.sync)))
            case .syncTaiga:
                return .send(.management(.taiga(.sync)))
            }
            
        case .intro(.delegate(.showIntro)):
            state.sheet = .intro
            return .none
        
        case let .settings(.delegate(delegate)) :
            switch(delegate) {
            case .showIntro:
                state.sheet = .intro
                return .none
            case .logout:
                return .send(.login(.logout))
            case .dismiss:
                state.sheet = nil
                return .none
            }
        
            
        case .login, .management, .settings, .intro:
            return .none
            
        }
    }
    
    
    

}
