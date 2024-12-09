import Foundation
import LoginService
import Redux
import Dependencies

import KimaiServices
import LoginCore
import LoginServices

public struct LoginFeature: Reducer {
    @Dependency(\.kimai) var kimai
    @Dependency(\.keychain) var keychain
    @Dependency(\.database) var database
    
    public init() {}
    
    public struct State: Equatable, Codable, Hashable {
        public init() {}
        
        public var accounts: [Account] = []
        public var accountId: String?
    }
    
    public enum Action: Codable, Equatable {
        case fetchAccounts
        
        case create(Account)
        case save(Account)
        case delete(_ id: String)
        
        case login(_ id: String)
        case loginDemoAccount
        
        case logout
        case resetDatabases
        case reset
        
        // delegate
        case delegate(Delegate)
        
    }
    
    public enum Delegate: Codable, Equatable {
        case showAssistant
        
        case onLogin(Account)
    }
    
    public  enum Route: Equatable, Codable, Hashable {
        case accounts
        case account(_ id: String)
        case kimai(_ id: String)
        case taiga(_ id: String)
    }



}
