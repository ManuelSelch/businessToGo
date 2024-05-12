import Foundation
import Combine
import OfflineSync

extension LoginState {
    public static func reduce(_ state: inout LoginState, _ action: LoginAction, _ env: Environment) -> AnyPublisher<LoginAction, Error>  {
        switch(action){
            case .navigate(let scene):
                state.scene = scene
                
            case .logout:
                state.scene = .accounts
                state.current = nil
                env.keychain.logout()
                env.router.tab = .login
                env.router.management.routes = []
                env.router.settings.routes = []
            
            case .reset:
                do {
                    try env.keychain.removeAccounts()
                    state.accounts = []
                } catch {
                    return Fail(error: error).eraseToAnyPublisher()
                }
            
            case .loadAccounts:
                do {
                    state.accounts = try env.keychain.getAccounts()
                    if(state.accounts.isEmpty){
                        state.accounts.append(Account.demo)
                        try env.keychain.saveAccount(Account.demo)
                    }
                    if(state.current == nil){
                        if let account = try env.keychain.getCurrentAccount(state.accounts) {
                            return env.just(.login(account))
                        }
                    }
                } catch {
                    return Fail(error: error).eraseToAnyPublisher()
                }
            
            case .login(let account):
                switch(state.scene){
                    case .kimai:
                        return loginKimai(account, env) // -> saveAccount
                    case .taiga:
                        return loginTaiga(account, env) // -> saveAccount
                    case .accounts:
                        state.current = account
                        env.router.tab = .management
                        env.management.changeDB("businessToGo_\(account.identifier)")
                        env.keychain.login(account)
                        return Publishers.Merge(
                            loginKimai(account, env), loginTaiga(account, env)
                        ).eraseToAnyPublisher()
                    
                default: break
                }
            
            case .createAccount:
                let id = state.accounts.count
                let account = Account(id: id)
                state.scene = .account(account)
            
            case .saveAccount(let account):
                state.scene = .account(account)
                try? env.keychain.saveAccount(account)
            
            case .status(let status):
                state.loginStatus = status
            
            case .deleteAccount(let account):
                do {
                    try env.keychain.removeAccount(account)
                    state.accounts.removeAll(where: { $0.identifier == account.identifier })
                } catch {
                    return Fail(error: error).eraseToAnyPublisher()
                }
        }
        
        return Empty().eraseToAnyPublisher()
    }
    
    
    static func loginKimai(_ account: Account, _ env: Environment) -> AnyPublisher<LoginAction, Error> {
        return Future<LoginAction, Error> { promise in
            Task {
                do {
                    guard let kimai = account.kimai else { promise(.failure(ServiceError.unknown("kimai account not found"))); return }
                    let success = try await env.management.kimai.login(kimai)
                    
                    if(success){
                        promise(.success(.saveAccount(account)))
                    }else {
                        promise(.failure(ServiceError.unknown("kimai login failed")))
                    }
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
        
        
    }
    
    static func loginTaiga(_ account: Account, _ env: Environment) -> AnyPublisher<LoginAction, Error> {
        return Future<LoginAction, Error> { promise in
            Task {
                do {
                    guard let taiga = account.taiga else { promise(.failure(ServiceError.unknown("taiga account not found"))); return }
                    let user = try await env.management.taiga.login(taiga)
                    env.management.taiga.setToken(user.auth_token)
                    
                    promise(.success(.saveAccount(account)))
                } catch {
                    return promise(.failure(error))
                }
            }
        
        }.eraseToAnyPublisher()
    }
}
