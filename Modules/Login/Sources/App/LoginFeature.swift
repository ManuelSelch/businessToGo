import Foundation
import LoginService
import Redux
import Dependencies

import KimaiServices
import TaigaServices
import LoginCore
import LoginServices

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
    
    public enum Action: Codable, Equatable {
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
