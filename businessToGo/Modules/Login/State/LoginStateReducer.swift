import Foundation
import Combine

extension LoginState {
    public static func reduce(_ state: inout LoginState, _ action: LoginAction, _ env: Environment) -> AnyPublisher<AppAction, Error>  {
        switch(action){
            case .navigate(let scene):
                state.scene = scene
            
            
            case .check(let username, let password):
                switch(state.scene){
                    case .kimai:
                        return env.management.kimai.login(username, password)
                            .flatMap { result in
                                if(result){
                                    let account = AccountData(username, password)
                                    return env.just(AppAction.login(.saveAccountData(account)))
                                }else{
                                    return env.just(AppAction.login(.status(.error("login failed"))))
                                }
                            }
                            .replaceError(with: .login(.status(.error("login failed"))))
                            .setFailureType(to: Error.self)
                            .eraseToAnyPublisher()
                    case .taiga:
                        return env.management.taiga.login(username, password)
                            .flatMap { user in
                                env.management.taiga.setToken(user.auth_token)
                                
                                let account = AccountData(username, password)
                                return env.just(AppAction.login(.saveAccountData(account)))
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
            
                _ = env.keychain.saveAccount(state.account)
                
                state.scene = .accounts
          
            case .loadStoredAccount:
                return env.keychain.getAccount()
                    .map { .login(.setAccount($0)) }
                    .eraseToAnyPublisher()
                
            case .setAccount(let account): //todo: refactor :-)
                state.account = account
                
                return Publishers.MergeMany(
                    kimaiLogin(account.kimai, env),
                    taigaLogin(account.taiga, env),
                    loginFinished(account, env.router)
                ).eraseToAnyPublisher()
                 
            
            case .setTaigaToken(let token):
                env.management.taiga.setToken(token)
            return env.just(.management(.taiga(.sync)))
            
            case .status(let status):
                state.loginStatus = status
            
            case .deleteAccount:
                return env.keychain.removeAccount()
                .map { .login(.setAccount($0)) }
                .eraseToAnyPublisher()
        }
        
        return Empty().eraseToAnyPublisher()
    }
    
    private static func kimaiLogin(_ account: AccountData?, _ env: Environment) -> AnyPublisher<AppAction, Error> {
        if let kimai = account {
            return env.management.kimai.login(kimai.username, kimai.password)
                .flatMap { result in
                    return env.just(AppAction.management(.kimai(.loginSuccess)))
                }
                .replaceError(with: .login(.status(.error("login failed"))))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return Empty().eraseToAnyPublisher()
        }
    }
    
    private static func taigaLogin(_ account: AccountData?, _ env: Environment) -> AnyPublisher<AppAction, Error> {
        if let taiga = account {
            return env.management.taiga.login(taiga.username, taiga.password)
                .map { AppAction.login(.setTaigaToken($0.auth_token)) }
                .eraseToAnyPublisher()
        } else{
            return Empty().eraseToAnyPublisher()
        }
    }
    
    private static func loginFinished(_ account: Account, _ router: AppRouter) -> AnyPublisher<AppAction, Error> {
        if(account.kimai != nil && account.taiga != nil) {
            router.tab = .management
            return Empty().eraseToAnyPublisher()
        } else{
            return Empty().eraseToAnyPublisher()
        }
    }
}
