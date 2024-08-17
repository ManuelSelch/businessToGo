import Foundation
import Combine
import Redux

import LoginCore

public extension LoginFeature {
    func reduce(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch(action){
        case .reset:
            database.reset()
            try? keychain.removeAccounts()
            state.accounts = []
        
        case .fetchAccounts:
            state.accounts = (try? keychain.getAccounts()) ?? []
            if(state.accountId == nil){
                if let account = try? keychain.getCurrentAccount(state.accounts) {
                    state.accountId = account.identifier
                    login(account)
                    return .send(.delegate(.onLogin(account)))
                }
            }
            
        case let .create(account):
            state.accounts.append(account)
            
        case let .save(account):
            if let index = state.accounts.firstIndex(where: {$0.identifier == account.identifier}) {
                state.accounts[index] = account
                try? keychain.saveAccount(state.accounts[index])
                
            }
        
        case .login(let id):
            if let account = state.accounts.first(where: {$0.identifier == id}) {
                state.accountId = account.identifier
                login(account)
                return .send(.delegate(.onLogin(account)))
            }
        
        case .logout:
            state.accountId = nil
            keychain.logout()
        
        case .delete(let id):
            if let account = state.accounts.first(where: {$0.identifier == id}) {
                try? keychain.removeAccount(account)
                state.accounts.removeAll(where: { $0.identifier == account.identifier })
            }
            
        case .loginDemoAccount:
            let demo = Account.demo
            try? keychain.saveAccount(demo)
            state.accountId = demo.identifier
            login(demo)
            return .send(.delegate(.showAssistant))
        
        case .delegate:
            return .none
        }
        
        return .none
    }
    
    
    func login(_ account: Account) {
        database.switchDB("businessToGo_\(account.identifier).sqlite")
        keychain.login(account)
    }
}
