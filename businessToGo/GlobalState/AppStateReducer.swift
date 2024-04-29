import Foundation
import Combine
import Log

extension AppState {
    
    static func reduce(_ state: inout AppState, _ action: AppAction, _ env: Environment) -> AnyPublisher<AppAction, Error>  {
        switch action {
        
        case .menu(let action):
            switch(action){
            case .logout:
                return env.just(.login(.deleteAccount))
            case .resetDatabase:
                env.reset()
            }
        
        case .log(let action):
            return LogState.reduce(&state.log, action, Log.Dependency())
                .map { AppAction.log($0) }
                .eraseToAnyPublisher()
        
        case .login(let action):
            return LoginState.reduce(&state.login, action, env)
        
        case .management(let action):
            return ManagementState.reduce(&state.management, action, env.management)
                .map { AppAction.management($0) }
                .eraseToAnyPublisher()
        
        }
        
        return Empty().eraseToAnyPublisher()
        
    }
    
   
    
}

