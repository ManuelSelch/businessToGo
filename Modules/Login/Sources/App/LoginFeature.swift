import Foundation
import LoginService
import Redux
import Dependencies

import KimaiServices
import TaigaServices
import LoginCore
import LoginServices

enum LoginScreen: Equatable, Codable, Hashable {
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
    
    public struct State: Equatable, Codable, Hashable {
        public init() {}
        
        var scene: LoginScreen = .accounts
        
        var accounts: [Account] = []
        public var current: Account?
    }
    
    public enum Action: Codable, Equatable {
        case onAppear
        
        case createAccountTapped
        case deleteTapped(Account)
        case editTapped(Account)
        case kimaiAccountTapped(Account)
        case taigaAccountTapped(Account)
        
        
        case nameChanged(String)
        
        case loginTapped(Account)
        case logoutTapped
        case resetTapped
        
        case backTapped
        
        case assistantTapped
        
        case delegate(Delegate)
        
    }
    
    public enum Delegate: Codable, Equatable {
        case showAssistant
        
        case syncKimai(Account)
        case syncTaiga(Account)
        
        case onLogin(Account)
    }
    
    public  enum Route: Equatable, Codable, Hashable {
        case accounts
        case account(Account)
        case kimai(Account)
        case taiga(Account)
    }



}
