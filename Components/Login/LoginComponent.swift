import Foundation
import Redux
import ReduxDebug

import LoginCore

struct LoginComponent: ViewModel {
    typealias DState = AppFeature.State
    typealias DAction = AppFeature.Action
    
    struct State: ViewState {
        var accounts: [Account] = []
        var current: String?
        
        static func from(_ state: AppFeature.State) -> State {
            return State(
                accounts: state.login.accounts,
                current: state.login.accountId
            )
        }
    }
    
    enum Action: ViewAction {
        // events
        case onAppear
        
        // buttons
        case createTapped
        case deleteTapped(_ id: String)
        case editTapped(_ id: String)
        case loginTapped(_ id: String)
        case nameSaveTapped(String)
        
        case kimaiAccountTapped
        case taigaAccountTapped
        case accountSaveTapped(Account)
        case kimaiLogoutTapped
        case taigaLogoutTapped
        
        case logoutTapped
        case resetTapped
        case assistantTapped
        
        var lifted: AppFeature.Action {
            switch self {
            case .onAppear:
                return .user(.fetchAccounts)
                
            case .createTapped:
                return .component(.login(.createTapped))
            case let .deleteTapped(id):
                return .user(.delete(id))
            case let .editTapped(id):
                return .component(.login(.editTapped(id)))
            case let .loginTapped(id):
                return .user(.login(id))
            case let .nameSaveTapped(name):
                return .component(.login(.nameSaveTapped(name)))
                
            case .kimaiAccountTapped:
                return .component(.login(.kimaiAccountTapped))
            case .taigaAccountTapped:
                return .component(.login(.taigaAccountTapped))
            case let .accountSaveTapped(account):
                return .component(.login(.accountSaveTapped(account)))
            case .kimaiLogoutTapped:
                return .component(.login(.kimaiLogoutTapped))
            case .taigaLogoutTapped:
                return .component(.login(.taigaLogoutTapped))
                
            case .logoutTapped:
                return .user(.logout)
            case .resetTapped:
                return .user(.reset)
            case .assistantTapped:
                return .user(.loginDemoAccount)
            }
        }
    }
    
    enum UIAction: Equatable, Codable {
        case createTapped
        case editTapped(_ id: String)
        case nameSaveTapped(String)
        
        case kimaiAccountTapped
        case taigaAccountTapped
        case accountSaveTapped(Account)
        case kimaiLogoutTapped
        case taigaLogoutTapped
    }
    
    static func reduce(_ state: inout AppFeature.State, _ action: UIAction) -> Effect<AppFeature.Action> {
        switch(action) {
        case .createTapped:
            let id = state.login.accounts.count
            let account = Account(id: id)
            state.router.push(.login(.account(account.identifier)))
            return .send(.user(.create(account)))
            
        case let .editTapped(id):
            state.router.push(.login(.account(id)))
            
        case let .nameSaveTapped(name):
            if case let .login(.account(id)) = state.router.currentRouter.currentRoute,
               var account = state.login.accounts.first(where: {$0.identifier == id})
            {
                account.name = name
                return .send(.user(.save(account)))
            }
            
        case .kimaiAccountTapped:
            if case let .login(.account(id)) = state.router.currentRouter.currentRoute {
                state.router.push(.login(.kimai(id)))
            }
            
        case .taigaAccountTapped:
            if case let .login(.account(id)) = state.router.currentRouter.currentRoute {
                state.router.push(.login(.taiga(id)))
            }
            
        case let .accountSaveTapped(account):
            state.router.dismiss()
            return .send(.user(.save(account)))
            
        case .kimaiLogoutTapped:
            if case let .login(.kimai(id)) = state.router.currentRouter.currentRoute,
               var account = state.login.accounts.first(where: {$0.identifier == id})
            {
                account.kimai = nil
                state.router.dismiss()
                return .send(.user(.save(account)))
            }
            
        case .taigaLogoutTapped:
            if case let .login(.taiga(id)) = state.router.currentRouter.currentRoute,
               var account = state.login.accounts.first(where: {$0.identifier == id})
            {
                account.taiga = nil
                state.router.dismiss()
                return .send(.user(.save(account)))
            }
            
        }
        return .none
    }
}
