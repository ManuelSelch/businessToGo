import Foundation

enum LoginStatus: Equatable {
    case show
    case loading
    case error(String)
    case success
}

enum LoginScreen: Equatable {
    case accounts
    case account(Account)
    case kimai(Account)
    case taiga(Account)
}

struct LoginState: Equatable {
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
