import Foundation
import Combine

extension AppState {
    
    static func reduce(_ state: inout AppState, _ action: AppAction) -> AnyPublisher<AppAction, Error>  {
        switch action {
        
        case .menu(let action):
            switch(action){
            case .navigate(let scene):
                state.scene = scene
            case .resetDatabase:
                Env.reset()
            }
        
        case .log(let action):
            return LogState.reduce(&state.log, action)
                .map { AppAction.log($0) }
                .eraseToAnyPublisher()
        
        case .login(let action):
            return LoginState.reduce(&state.login, action)
        
        case .kimai(let action):
            return KimaiState.reduce(&state.kimai, action)
                .map { AppAction.kimai($0) }
                .eraseToAnyPublisher()
        
        case .taiga(let action):
            return TaigaState.reduce(&state.taiga, action)
                .map { AppAction.taiga($0) }
                .eraseToAnyPublisher()
        
        }
        
        return Empty().eraseToAnyPublisher()
        
    }
    
   
    
}

