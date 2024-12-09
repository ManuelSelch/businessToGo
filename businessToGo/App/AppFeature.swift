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
    @ObservedDependency(\.router) var router
    
    struct State: Codable, Equatable {
        var login: LoginFeature.State = .init()
        var kimai: KimaiFeature.State = .init()
        var integration: IntegrationFeature.State = .init()
        var report: ReportFeature.State = .init()
        var intro: IntroFeature.State = .init()
        var debug: DebugFeature.State = .init()
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
        
        case popupCloseTapped
        
        case setState(State)
    }
    
    func reduce(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch action {
        case .sync:
            if let account = state.login.accounts.first(where: {$0.identifier == state.login.accountId}) {
                return loginKimai(account, &state)
            }
        
        case .settingsTapped:
            router.showSheet(
                .settings(.settings)
            )
        
        case let .user(.delegate(delegate)):
            switch(delegate){
            case .showAssistant:
                router.showRoot(.management(.assistant))
                
            case let .onLogin(account):
                router.showTab(.today, route: .today(.today))
                return loginKimai(account, &state)
            }
            
        case let .user(action):
            switch(action) {
            case .reset, .logout:
                state.kimai = .init()
                state.integration = .init()
                router.showRoot(.login(.accounts))
            default: break
            }
            return LoginFeature().lift(&state.login, action, toParent: Action.user)
            
        
        case let .kimai(.delegate(action)):
            switch(action) {
            case let .popup(route):
                router.showPopup(.management(.kimai(.popup(route))))
            case .dismissPopup:
                router.dismiss()
            }

        case let .kimai(action):
            return KimaiFeature().lift(&state.kimai, action, toParent: Action.kimai)
            
        case let .integration(action):
            return IntegrationFeature().lift(&state.integration, action, toParent: Action.integration)

        case let .report(action):
            return ReportFeature().lift(&state.report, action, toParent: Action.report)
        
        case .intro(.delegate(.showIntro)):
            router.showSheet(.intro)
            
        case let .intro(action):
            return IntroFeature().lift(&state.intro, action, toParent: Action.intro)
            
        case let .debug(action):
            return DebugFeature().lift(&state.debug, action, toParent: Action.debug)
            
        case .popupCloseTapped:
            router.dismiss()
            
        case let .setState(newState):
            state = newState
        }
        
        return .none
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
