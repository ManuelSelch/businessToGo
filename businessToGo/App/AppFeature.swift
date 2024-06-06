import Foundation
import Log
import Redux
import Combine

import Login
import Intro
import Report
import Management
import Settings


enum AppRoute: Identifiable, Codable, Equatable {
    case login
    
    case management
    case report
    
    case intro
    case settings
    
    var id: Self {self}
}


struct AppFeature: Reducer {
    
    struct State: Codable, Equatable {
        var tab: AppRoute = .login
        var sheet: AppRoute?
        
        var log: LogFeature.State = .init()
        var login: LoginFeature.State = .init()
        var management: ManagementFeature.State = .init()
        var report: ReportFeature.State = .init()
        var intro: IntroFeature.State = .init()
        
        var settings: SettingsFeature.State = .init()
    }
    
    enum Action: Codable {
        case tabSelected(AppRoute)
        case sheetSelected(AppRoute?)
        case settingsTapped
        
        case log(LogFeature.Action)
        case login(LoginFeature.Action)
        case management(ManagementFeature.Action)
        case report(ReportFeature.Action)
        case settings(SettingsFeature.Action)
        case intro(IntroFeature.Action)
        
        case setState(State)
    }
    
    func reduce(_ state: inout State, _ action: Action) -> AnyPublisher<Action, Error> {
        switch action {
            
        case .tabSelected(let tab):
            state.tab = tab
            return .none
        
        case .sheetSelected(let sheet):
            state.sheet = sheet
            return .none
        
        case .settingsTapped:
            state.sheet = .settings
            return .none
            
        case .log(let action):
            return LogFeature().reduce(&state.log, action)
                .map { .log($0) }
                .eraseToAnyPublisher()
        
        case let .login(.delegate(delegate)):
            switch(delegate){
            case .showLogin:
                state.tab = .login
                return .none
            case .showHome:
                state.tab = .report
                return .none
            case .showAssistant:
                // TODO: state.management.router.presentCover(.assistant)
                state.tab = .management
                return .none
            case .syncKimai:
                return .send(.management(.sync))
            case .syncTaiga:
                return .send(.management(.sync))
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
        
        case let .report(action):
            return ReportFeature().reduce(&state.report, action)
                .map { .report($0) }
                .eraseToAnyPublisher()
            
        case let .setState(newState):
            state = newState
            return .none
            
        case let .login(action):
            return LoginFeature().reduce(&state.login, action)
                .map { .login($0) }
                .eraseToAnyPublisher()
            
        case let .management(action):
            return ManagementFeature().reduce(&state.management, action)
                .map { .management($0) }
                .eraseToAnyPublisher()
            
        
        case let .settings(action):
            return SettingsFeature().reduce(&state.settings, action)
                .map { .settings($0) }
                .eraseToAnyPublisher()
            
        case let .intro(action):
            return IntroFeature().reduce(&state.intro, action)
                .map { .intro($0) }
                .eraseToAnyPublisher()
            
        
            
        }
    }
    
    

}
