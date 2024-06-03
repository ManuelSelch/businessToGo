import Foundation
import LoginService
import Redux
import ManagementDependencies

enum LoginScreen: Equatable, Codable {
    case accounts
    case account(Account)
    case kimai(Account)
    case taiga(Account)
}


public struct LoginFeature: Reducer {
    
    @Dependency(\.kimai) var kimai
    @Dependency(\.taiga) var taiga
    @Dependency(\.keychain) var keychain
    @Dependency(\.database) var database
    
    public init() {}
    
    public struct State: Equatable, Codable {
        public init() {}
        
        var scene: LoginScreen = .accounts
        
        var accounts: [Account] = []
        var current: Account?
    }
    
    public enum Action: Codable {
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
    
    public enum Delegate: Codable {
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

public extension DependencyValues {
    var keychain: KeychainService<Account> {
        get { Self[KeychainServiceKey.self] }
        set { Self[KeychainServiceKey.self] = newValue }
    }
}
