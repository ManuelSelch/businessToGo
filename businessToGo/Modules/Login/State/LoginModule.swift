import Foundation
import Login

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


struct LoginModule {
    struct State: Equatable, Codable {
        var scene: LoginScreen = .accounts
        
        var accounts: [Account] = []
        var current: Account?
        
        var loginStatus: LoginStatus = .show
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
        
    }
    
    struct Dependency {
        var management: ManagementModule.Dependency
        var keychain: KeychainService<Account>
    }

}
