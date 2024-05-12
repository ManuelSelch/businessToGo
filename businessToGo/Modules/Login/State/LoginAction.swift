import Foundation

enum LoginAction {
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
