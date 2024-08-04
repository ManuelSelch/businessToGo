import Foundation
import Combine
import Redux
import Dependencies

import LoginApp
import LoginCore
import Intro
import Report
import DebugApp

import KimaiApp
import TaigaApp
import IntegrationApp

import LoginService

struct AppFeature: Reducer {
    @Dependency(\.keychain) var keychain
    @Dependency(\.kimai) var kimai
    @Dependency(\.taiga) var taiga
    
    struct State: Codable, Equatable {
        var router: AppRouterFeature<AppFeature.Route, AppFeature.TabRoute>.State = .init(
            screen: .root, routers: [
                .root: .init(root: .login(.accounts)),
                .tab(.management): .init(root: .management(.kimai(.customersList))),
                .tab(.report): .init(root: .report(.reports))
            ]
        )
        
        var login: LoginFeature.State = .init()
        var kimai: KimaiFeature.State = .init()
        var taiga: TaigaFeature.State = .init()
        var integration: IntegrationFeature.State = .init()
        var report: ReportFeature.State = .init()
        var intro: IntroFeature.State = .init()
        var debug: DebugFeature.State = .init()
        
        var title: String {
            switch router.currentRouter.currentRoute {
            case let .management(route): return route.title
            case .login: return "Login"
            case .settings: return "Settings"
            case .intro: return "Intro"
            case .report: return "Report"
            }
        }
    }
    
   
    enum Action: Codable, Equatable {
        case sync
        case settingsTapped
        
        case login(LoginFeature.Action)
        case kimai(KimaiFeature.Action)
        case taiga(TaigaFeature.Action)
        case integration(IntegrationFeature.Action)
        case report(ReportFeature.Action)
        case intro(IntroFeature.Action)
        case debug(DebugFeature.Action)
        
        case router(AppRouterFeature<AppFeature.Route, AppFeature.TabRoute>.Action)
        case component(ComponentAction)
        
        case setState(State)
    }
    
    enum ComponentAction: Codable, Equatable {
        case settings(SettingsContainer.UIAction)
        case management(ManagementContainer.UIAction)
        case report(ReportContainer.UIAction)
    }
    
    
    enum FakeNavigationAction: Equatable, Codable {
        case push(AppFeature.Route)
    }

    
    func reduce(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch action {
        case .sync:
            return .merge([.send(.kimai(.sync)), .send(.taiga(.sync))])
        
        case .settingsTapped:
            state.router.presentSheet(
                .settings(.settings)
            )
        
        case let .login(.delegate(delegate)):
            switch(delegate){
            case .showAssistant:
                state.router.presentTabScreen(.management, route: .management(.assistant))
                state.router.push(.management(.assistant))
                
            case let .syncKimai(account):
                return loginKimai(account)
            case let .syncTaiga(account):
                return loginTaiga(account)
            case let .onLogin(account):
                state.router.presentTabScreen(.report, route: .report(.reports))
                return .merge([
                    loginKimai(account),
                    loginTaiga(account)
                ])
            }
            
        case let .login(action):
            switch(action) {
            case .resetTapped, .logoutTapped:
                state.router.presentRootScreen(.login(.accounts))
            default: break
            }
            return LoginFeature().lift(&state.login, action, toParent: Action.login)
            
        

        case let .kimai(action):
            return KimaiFeature().lift(&state.kimai, action, toParent: Action.kimai)
        
        case let .taiga(action):
            return TaigaFeature().lift(&state.taiga, action, toParent: Action.taiga)
            
        case let .integration(action):
            return IntegrationFeature().lift(&state.integration, action, toParent: Action.integration)

        case let .report(action):
            return ReportFeature().lift(&state.report, action, toParent: Action.report)
        
        case .intro(.delegate(.showIntro)):
            state.router.presentSheet(.intro)
            
        case let .intro(action):
            return IntroFeature().lift(&state.intro, action, toParent: Action.intro)
            
        case let .debug(action):
            return DebugFeature().lift(&state.debug, action, toParent: Action.debug)
            
            
        case let .router(action):
            return AppRouterFeature<AppFeature.Route, AppFeature.TabRoute>().lift(&state.router, action, toParent: Action.router)
            
        case let .component(action):
            return reduce(&state, action)
            
        case let .setState(newState):
            state = newState
        }
        
        return .none
    }
    
    func reduce(_ state: inout State, _ action: ComponentAction) -> Effect<Action> {
        switch(action) {
        case let .settings(action):
            return SettingsContainer.reduce(&state, action)
        case let .management(action):
            return ManagementContainer.reduce(&state, action)
        case let .report(action):
            return ReportContainer.reduce(&state, action)
        }
    }
    
    
    func loginKimai(_ account: Account) -> AnyPublisher<Action, Error> {
        guard let kimai = account.kimai else {
            // read offline data
            return .send(.kimai(.sync))
        }
        
        return .run { send in
            if let success = try? await self.kimai.login(server: kimai.server) {
                if(success){
                    self.kimai.setAuth(username: kimai.username, password: kimai.password)
                    try? keychain.saveAccount(account)
                    send(.success(.kimai(.sync)))
                }
            }
        }
    }
    
    func loginTaiga(_ account: Account) -> AnyPublisher<Action, Error> {
        guard let taiga = account.taiga else {
            return .send(.taiga(.sync))
        }
        
        return .run { send in
            if let user = try? await self.taiga.login(username: taiga.username, password: taiga.password, server: taiga.server) {
                self.taiga.setAuth(user.auth_token)
                try? keychain.saveAccount(account)
                
                send(.success(.taiga(.sync)))
            }
        }
    }

    

}
