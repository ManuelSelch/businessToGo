import Foundation
import Combine

extension LoginState {
    public static func reduce(_ state: inout LoginState, _ action: LoginAction) -> AnyPublisher<AppAction, Error>  {
        switch(action){
            case .navigate(let scene):
                state.scene = scene
            
            
            case .check(let username, let password):
                switch(state.scene){
                    case .kimai:
                        return Env.kimai.login(username, password)
                            .flatMap { result in
                                if(result){
                                    let account = AccountData(username, password)
                                    return Env.just(AppAction.login(.saveAccountData(account)))
                                }else{
                                    return Env.just(AppAction.login(.status(.error("login failed"))))
                                }
                            }
                            .replaceError(with: .login(.status(.error("login failed"))))
                            .setFailureType(to: Error.self)
                            .eraseToAnyPublisher()
                    case .taiga:
                        return Env.taiga.login(username, password)
                            .flatMap { user in
                                Env.taiga.setToken(user.auth_token)
                                
                                let account = AccountData(username, password)
                                return Env.just(AppAction.login(.saveAccountData(account)))
                            }
                            .replaceError(with: .login(.status(.error("login failed"))))
                            .setFailureType(to: Error.self)
                            .eraseToAnyPublisher()
                    default: break
                }
                
                
            case .saveAccountData(let account):
                switch(state.scene){
                case .kimai:
                    state.account.kimai = account
                case .taiga:
                    state.account.taiga = account
                default: break
                }
            
                _ = Env.keychain.saveAccount(state.account)
                
                state.scene = .accounts
          
            case .loadStoredAccount:
                return Env.keychain.getAccount()
                    .map { .login(.setAccount($0)) }
                    .eraseToAnyPublisher()
                
            case .setAccount(let account): //todo: refactor :-)
                state.account = account
                
                return Publishers.MergeMany(
                    kimaiLogin(account.kimai),
                    taigaLogin(account.taiga),
                    loginFinished(account)
                ).eraseToAnyPublisher()
                 
            
            case .setTaigaToken(let token):
                Env.taiga.setToken(token)
                return Env.just(.taiga(.sync))
            
            case .status(let status):
                state.loginStatus = status
            
            case .deleteAccount:
                return Env.keychain.removeAccount()
                .map { .login(.setAccount($0)) }
                .eraseToAnyPublisher()
        }
        
        return Empty().eraseToAnyPublisher()
    }
    
    private static func kimaiLogin(_ account: AccountData?) -> AnyPublisher<AppAction, Error> {
        if let kimai = account {
            return Env.kimai.login(kimai.username, kimai.password)
                .flatMap { result in
                    return Env.just(AppAction.kimai(.loginSuccess))
                }
                .replaceError(with: .login(.status(.error("login failed"))))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return Empty().eraseToAnyPublisher()
        }
    }
    
    private static func taigaLogin(_ account: AccountData?) -> AnyPublisher<AppAction, Error> {
        if let taiga = account {
            return Env.taiga.login(taiga.username, taiga.password)
                .map { AppAction.login(.setTaigaToken($0.auth_token)) }
                .eraseToAnyPublisher()
        } else{
            return Empty().eraseToAnyPublisher()
        }
    }
    
    private static func loginFinished(_ account: Account) -> AnyPublisher<AppAction, Error> {
        if(account.kimai != nil && account.taiga != nil) {
            return Env.just(.menu(.navigate(.kimai)))
        } else{
            return Empty().eraseToAnyPublisher()
        }
    }
}
