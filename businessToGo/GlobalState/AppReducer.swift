import Foundation
import Combine
import Log

extension AppState {
    
    static func reduce(_ state: inout AppState, _ action: AppAction, _ env: AppDependency) -> AnyPublisher<AppAction, Error>  {
        switch action {
        case .route(let action):
            switch(action){
            case .push(_): break
            case .pop: break
            case .set(_): break
                
            case .presentSheet(let route):
                state.sheet = route
            case .dismissSheet:
                state.sheet = nil
            }
        
        case .tab(let tab):
            state.tab = tab
            
        case .log(let action):
            return LogState.reduce(&state.log, action, env.log)
                .map { AppAction.log($0) }
                .eraseToAnyPublisher()
        
        case .login(let action):
            let effect = LoginState.reduce(&state.login, action, env)
            if(state.login.current == nil){
                state.tab = .login
            } else {
                state.tab = .management
            }
            return effect
        
        case .management(let action):
            return ManagementState.reduce(&state.management, action, env.management)
                .map { AppAction.management($0) }
                .eraseToAnyPublisher()
        
        case .settings(let action):
            return SettingsState.reduce(&state.settings, action, env.settings)
                .map { .settings($0) }
                .eraseToAnyPublisher()
        }
        
        return Empty().eraseToAnyPublisher()
    }
    
   
    
}

