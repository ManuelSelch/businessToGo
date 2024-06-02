import Foundation
import Login
import Redux

enum LoginScreen: Equatable, Codable {
    case accounts
    case account(Account)
    case kimai(Account)
    case taiga(Account)
}


struct LoginFeature: Reducer {
    
    @Dependency(\.kimai) var kimai
    @Dependency(\.taiga) var taiga
    @Dependency(\.keychain) var keychain
    @Dependency(\.database) var database
    
    struct State: Equatable, Codable {
        var scene: LoginScreen = .accounts
        
        var accounts: [Account] = []
        var current: Account?
    }
    
    enum Action: Codable {
        case onAppear
        
        case createAccountTapped
        case deleteTapped(Account)
        case editTapped(Account)
        case kimaiAccountTapped(Account)
        case taigaAccountTapped(Account)
        case resetTapped
        
        case nameChanged(String)
        
        case logout
        case loginTapped(Account)
        
        case backTapped
        
        case assistantTapped
        
        case delegate(Delegate)
        
    }
    
    enum Delegate: Codable {
        case showLogin
        case showHome
        case showAssistant
        
        case syncKimai
        case syncTaiga
    }


}


struct KeychainServiceKey: DependencyKey {
    static var liveValue = KeychainService<Account>.live("de.selch")
    static var mockValue = KeychainService<Account>.mock
}

extension DependencyValues {
    var keychain: KeychainService<Account> {
        get { Self[KeychainServiceKey.self] }
        set { Self[KeychainServiceKey.self] = newValue }
    }
}
