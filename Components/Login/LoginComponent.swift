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
        case createTapped(_ account: Account)
        case deleteTapped(_ id: String)
        case loginTapped(_ id: String)
        case accountSaveTapped(Account)
        case logoutTapped
        case resetTapped
        case assistantTapped
        
        var lifted: AppFeature.Action {
            switch self {
            case .onAppear:
                return .user(.fetchAccounts)
                
            case let .createTapped(account):
                return .user(.create(account))
            case let .deleteTapped(id):
                return .user(.delete(id))
            case let .loginTapped(id):
                return .user(.login(id))
            case let .accountSaveTapped(account):
                return .user(.save(account))
            case .logoutTapped:
                return .user(.logout)
            case .resetTapped:
                return .user(.reset)
            case .assistantTapped:
                return .user(.loginDemoAccount)
            }
        }
    }
    
  
}
