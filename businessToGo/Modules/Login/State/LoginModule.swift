import Foundation
import Login
import ComposableArchitecture

enum LoginStatus: Equatable, Codable {
    case show
    case loading
    case error(String)
    case success
}

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
        
        var loginStatus: LoginStatus = .show
        
        init() {
            self._current = Shared(nil)
        }
    }
    
    enum Action {
        case navigate(LoginScreen)
        
        case loadAccounts
        case createAccount
        case saveAccount(Account)
        case deleteAccount(Account)
        case reset
        
        case logout
        case login(Account)
        case status(LoginStatus)
        
        case delegate(Delegate)
        
    }
    
    enum Delegate {
        case showLogin
        case showHome
        
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
