import Foundation
import Login
import ComposableArchitecture

enum LoginScreen: Equatable, Codable {
    case accounts
    case account(Account)
    case kimai(Account)
    case taiga(Account)
}


@Reducer
struct LoginModule {
    @Dependency(\.kimai) var kimai
    @Dependency(\.taiga) var taiga
    @Dependency(\.keychain) var keychain
    @Dependency(\.database) var database
    
    @ObservableState
    struct State: Equatable {
        var scene: LoginScreen = .accounts
        
        var accounts: [Account] = []
        @Shared var current: Account?
        
        
        init() {
            self._current = Shared(nil)
        }
    }
    
    enum Action {        
        case onAppear
        
        case createAccountTapped
        case deleteTapped(Account)
        case editTapped(Account)
        case resetTapped
        
        case nameChanged(String)
        
        case logout
        case loginTapped(Account)
        
        case backTapped
        
        case assistantTapped
        
        case delegate(Delegate)
        
    }
    
    enum Delegate {
        case showLogin
        case showHome
        case showAssistant
        
        case syncKimai
        case syncTaiga
    }


}

extension DependencyValues {
    var keychain: KeychainService<Account> {
        get { self[KeychainService<Account>.self] }
        set { self[KeychainService<Account>.self] = newValue }
    }
}
