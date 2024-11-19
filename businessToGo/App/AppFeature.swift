import Foundation
import Combine
import Redux
import Dependencies

import LoginApp
import LoginCore
import Intro
import DebugApp

import KimaiApp
import IntegrationApp

import LoginService

struct AppFeature: Reducer {
    @Dependency(\.keychain) var keychain
    @Dependency(\.kimai) var kimai
    
    struct State: Codable, Equatable {
        var router: AppRouterFeature<AppFeature.Route, AppFeature.TabRoute>.State = .init(
            screen: .root, 
            routers: [
                .root: .init(root: .login(.accounts)),
                .tab(.today): .init(root: .today(.today)),
                .tab(.management): .init(root: .management(.kimai(.customersList))),
                .tab(.report): .init(root: .report(.reports))
            ]
        )
        
        var login: LoginFeature.State = .init()
        var kimai: KimaiFeature.State = .init()
        var integration: IntegrationFeature.State = .init()
        var report: ReportFeature.State = .init()
        var intro: IntroFeature.State = .init()
        var debug: DebugFeature.State = .init()
        
        var title: String {
            switch router.currentRouter.currentRoute {
            case .today: return "Today"
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
        
        case user(LoginFeature.Action)
        case kimai(KimaiFeature.Action)
        case integration(IntegrationFeature.Action)
        case report(ReportFeature.Action)
        case intro(IntroFeature.Action)
        case debug(DebugFeature.Action)
        
        case router(AppRouterFeature<AppFeature.Route, AppFeature.TabRoute>.Action)
        case component(ComponentAction)
        
        case popupCloseTapped
        
        case setState(State)
    }
    
    enum ComponentAction: Codable, Equatable {
        case settings(SettingsComponent.UIAction)
        
        case management(ManagementComponent.UIAction)
        case kimai(KimaiComponent.UIAction)
        case assistant(AssistantComponent.UIAction)
        
        case report(ReportComponent.UIAction)
        case login(LoginComponent.UIAction)
        case today(TodayComponent.UIAction)
    }
    
    func reduce(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch action {
        case .sync:
            if let account = state.login.accounts.first(where: {$0.identifier == state.login.accountId}) {
                return loginKimai(account, &state)
            }
        
        case .settingsTapped:
            state.router.presentSheet(
                .settings(.settings)
            )
        
        case let .user(.delegate(delegate)):
            switch(delegate){
            case .showAssistant:
                state.router.presentRootScreen(.management(.assistant))
                
            case let .onLogin(account):
                state.router.presentTabScreen(.today, route: .today(.today))
                return loginKimai(account, &state)
            }
            
        case let .user(action):
            switch(action) {
            case .reset, .logout:
                state.kimai = .init()
                state.integration = .init()
                state.router.presentRootScreen(.login(.accounts))
            default: break
            }
            return LoginFeature().lift(&state.login, action, toParent: Action.user)
            
        
        case let .kimai(.delegate(action)):
            switch(action) {
            case let .popup(route):
                state.router.presentPopup(.management(.kimai(.popup(route))))
            case .dismissPopup:
                state.router.dismiss()
            }

        case let .kimai(action):
            return KimaiFeature().lift(&state.kimai, action, toParent: Action.kimai)
            
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
            
        case .popupCloseTapped:
            state.router.dismiss()
            
        case let .setState(newState):
            state = newState
        }
        
        return .none
    }
    
    func reduce(_ state: inout State, _ action: ComponentAction) -> Effect<Action> {
        switch(action) {
        case let .settings(action):
            return SettingsComponent.reduce(&state, action)
            
        case let .management(action):
            return ManagementComponent.reduce(&state, action)
        case let .kimai(action):
            return KimaiComponent.reduce(&state, action)
        case let .assistant(action):
            return AssistantComponent.reduce(&state, action)
            
        case let .report(action):
            return ReportComponent.reduce(&state, action)
        case let .login(action):
            return LoginComponent.reduce(&state, action)
        case let .today(action):
            return TodayComponent.reduce(&state, action)
        }
    }
    
    
    func loginKimai(_ account: Account, _ state: inout State) -> Effect<Action> {
        guard let kimai = account.kimai else {
            KimaiFeature().fetchOffline(&state.kimai)
            return .none
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
    
   
    

}
