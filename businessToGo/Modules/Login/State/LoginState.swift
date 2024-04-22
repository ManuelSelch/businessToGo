import Foundation

enum LoginStatus: Equatable {
    case show
    case loading
    case error(String)
    case success
}

enum LoginScreen: Equatable {
    case accounts
    case kimai
    case taiga
}

struct LoginState: Equatable {
    var scene: LoginScreen
    
    var account: Account
    var loginStatus: LoginStatus
}

extension LoginState {
    init(){
        scene = .accounts
        account = Account()
        loginStatus = .show
    }
}
