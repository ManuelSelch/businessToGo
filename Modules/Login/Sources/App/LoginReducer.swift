import Foundation
import Combine
import Redux

import LoginCore

public extension LoginFeature {
    func reduce(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch(action){
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
                    state.scene = .account(account)
                case .taiga:
                    state.scene = .account(account)
                case .accounts:
                    return login(account)
                default: return .none
            }
        
        case .logoutTapped:
            state.current = nil
            keychain.logout()
        
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
                state.scene = .account(account)
            default:
                return .none
            }
        
        case .backTapped:
            switch(state.scene) {
            case .account:
                state.scene = .accounts
            case let .kimai(account), let .taiga(account):
                state.scene = .account(account)
            case .accounts:
                break
            }
            
        
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
        
        return .send(.delegate(.onLogin(account)))
    }
}
