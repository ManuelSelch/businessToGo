import Foundation
import Combine
import OfflineSync
import Redux

extension LoginFeature {
    
    func reduce(_ state: inout State, _ action: Action) -> AnyPublisher<Action, Error> {
        switch(action){
                
            case .logout:
                state.scene = .accounts
                state.current = nil
                keychain.logout()
                return .send(.delegate(.showLogin))
            
            case .resetTapped:
                try? keychain.removeAccounts()
                state.accounts = []
            
            case .onAppear:
                state.accounts = (try? keychain.getAccounts()) ?? []
                if(state.current == nil){
                    if let account = try? keychain.getCurrentAccount(state.accounts) {
                        state.current = account
                        return login(account)
                    }
                }
            
            case .loginTapped(let account):
                switch(state.scene){
                    case .kimai:
                        return loginKimai(account) // -> saveAccount
                    case .taiga:
                        return loginTaiga(account) // -> saveAccount
                    case .accounts:
                        return login(account)
                    default: return .none
                }
            
            case .createAccountTapped:
                let id = state.accounts.count
                let account = Account(id: id)
                state.scene = .account(account)
            
            case .deleteTapped(let account):
                try? keychain.removeAccount(account)
                state.accounts.removeAll(where: { $0.identifier == account.identifier })
            
            case let .editTapped(account):
                state.scene = .account(account)
            
            case let .kimaiAccountTapped(account):
                state.scene = .kimai(account)
            
            case let .taigaAccountTapped(account):
                state.scene = .taiga(account)
            
            case let .nameChanged(name):
                switch(state.scene) {
                case var .account(account):
                    account.name = name
                    try? keychain.saveAccount(account)
                    return .none
                default:
                    return .none
                }
            
            case .backTapped:
                state.scene = .accounts
                
            
            case .assistantTapped:
                let demo = Account.demo
                try? keychain.saveAccount(demo)
                database.switchDB("businessToGo_\(demo.identifier).sqlite")
                keychain.login(demo)
                return .send(.delegate(.showAssistant))
            
            case .delegate:
                return .none
        }
        
        return .none
    }
    
    
    func login(_ account: Account) -> AnyPublisher<Action, Error> {
        database.switchDB("businessToGo_\(account.identifier).sqlite")
        keychain.login(account)
        
        return .merge([
            loginKimai(account),
            loginTaiga(account),
            .send(.delegate(.showHome))
        ])
    }
    
    func loginKimai(_ account: Account) -> AnyPublisher<Action, Error> {
        guard let kimai = account.kimai else {
            // read offline data
            return .send(.delegate(.syncKimai))
        }
        
        return .run { send in
            if let success = try? await self.kimai.login(kimai) {
                if(success){
                    self.kimai.setAuth(kimai)
                    try? keychain.saveAccount(account)
                    send(.success(.delegate(.syncKimai)))
                }
            }
        }
    }
    
    func loginTaiga(_ account: Account) -> AnyPublisher<Action, Error> {
        guard let taiga = account.taiga else {
            return .send(.delegate(.syncTaiga))
        }
        
        return .run { send in
            if let user = try? await self.taiga.login(taiga) {
                self.taiga.setAuth(user.auth_token)
                try? keychain.saveAccount(account)
                send(.success(.delegate(.syncTaiga)))
            }
        }
    }
}
