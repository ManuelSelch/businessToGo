import Foundation

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

struct LoginState: Equatable, Codable {
    var scene: LoginScreen
    
    var accounts: [Account]
    var current: Account?
    
    var loginStatus: LoginStatus
}

extension LoginState {
    init(){
        scene = .accounts
        accounts = []
        loginStatus = .show
    }
}
