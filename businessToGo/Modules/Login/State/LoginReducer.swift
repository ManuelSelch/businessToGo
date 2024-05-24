import Foundation
import Combine
import OfflineSync
import ComposableArchitecture

extension LoginModule {
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch(action){
            case .navigate(let scene):
                state.scene = scene
                
            case .logout:
                state.scene = .accounts
                state.current = nil
                keychain.logout()
                return .send(.delegate(.showLogin))
            
            case .reset:
                try? keychain.removeAccounts()
                state.accounts = []
            
            case .loadAccounts:
                state.accounts = (try? keychain.getAccounts()) ?? []
                if(state.accounts.isEmpty){
                    state.accounts.append(Account.demo)
                    try? keychain.saveAccount(Account.demo)
                }
                if(state.current == nil){
                    if let account = try? keychain.getCurrentAccount(state.accounts) {
                        return .send(Action.login(account))
                    }
                }
            
            case .login(let account):
                switch(state.scene){
                    case .kimai:
                        return loginKimai(account) // -> saveAccount
                    case .taiga:
                        return loginTaiga(account) // -> saveAccount
                    case .accounts:
                        state.current = account
                        database.switchDB("businessToGo_\(account.identifier).sqlite")
                        keychain.login(account)
                        
                        return .merge([
                            loginKimai(account), loginTaiga(account), .send(.delegate(.showHome))
                        ])
                    
                default: break
                }
            
            case .createAccount:
                let id = state.accounts.count
                let account = Account(id: id)
                state.scene = .account(account)
            
            case .saveAccount(let account):
                state.scene = .account(account)
                try? keychain.saveAccount(account)
            
            case .status(let status):
                state.loginStatus = status
            
            case .deleteAccount(let account):
                try? keychain.removeAccount(account)
                state.accounts.removeAll(where: { $0.identifier == account.identifier })
            
            case .delegate:
                return .none
        }
        
        return .none
    }
    
    
    func loginKimai(_ account: Account) -> Effect<Action> {
        return .run { send in
            guard let kimai = account.kimai else { return }
            if let success = try? await self.kimai.login(kimai) {
                if(success){
                    self.kimai.setAuth(kimai)
                    await send(.saveAccount(account))
                    await send(.delegate(.syncKimai))
                }
            }
        }
    }
    
    func loginTaiga(_ account: Account) -> Effect<Action> {
        return .run { send in
            guard let taiga = account.taiga else { return }
            if let user = try? await self.taiga.login(taiga) {
                self.taiga.setAuth(user.auth_token)
                await send(.saveAccount(account))
                await send(.delegate(.syncTaiga))
            }
        }
    }
}
