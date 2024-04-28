import Foundation
import Combine

extension AppState {
    
    static func reduce(_ state: inout AppState, _ action: AppAction) -> AnyPublisher<AppAction, Error>  {
        switch action {
        
        case .menu(let action):
            switch(action){
            case .logout:
                return Env.just(.login(.deleteAccount))
            case .resetDatabase:
                Env.reset()
            }
        
        case .log(let action):
            return LogState.reduce(&state.log, action)
                .map { AppAction.log($0) }
                .eraseToAnyPublisher()
        
        case .login(let action):
            return LoginState.reduce(&state.login, action)
        
        case .management(let action):
            return ManagementState.reduce(&state.management, action)
                .map { AppAction.management($0) }
                .eraseToAnyPublisher()
        
        }
        
        return Empty().eraseToAnyPublisher()
        
    }
    
   
    
}

