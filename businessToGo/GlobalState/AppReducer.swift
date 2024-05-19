import Foundation
import Combine
import Log
import Redux

extension AppModule: Reducer {
    
    static func reduce(_ state: inout State, _ action: Action, _ env: Dependency) -> AnyPublisher<Action, Error>  {
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
                .map { .log($0) }
                .eraseToAnyPublisher()
        
        case .login(let action):
            let effect = LoginModule.reduce(&state.login, action, LoginModule.Dependency(management: env.management, keychain: env.keychain))
            
            if(state.login.current == nil){
                state.tab = .login
            } else {
                state.tab = .report
            }
            
            return effect
                .map { .login($0) }
                .eraseToAnyPublisher()
        
        case .management(let action):
            return ManagementModule.reduce(&state.management, action, env.management)
                .map { .management($0) }
                .eraseToAnyPublisher()
        
        case .settings(let action):
            return SettingsState.reduce(&state.settings, action, env.settings)
                .map { .settings($0) }
                .eraseToAnyPublisher()
        }
        
        return Empty().eraseToAnyPublisher()
    }
    
   
    
}

