import Foundation

enum LoginAction {
    case navigate(LoginScreen)
    
    case loadStoredAccount
    case setAccount(Account)
    
    case saveAccountData(AccountData)
    case setTaigaToken(String)
    
    case deleteAccount
    
    case check(_ username: String, _ password: String)
    case status(LoginStatus)
    
}
