import Foundation


enum MenuAction {
    case logout
    case resetDatabase
}

enum AppAction {
    case menu(MenuAction)
    case log(LogAction)
    
    case login(LoginAction)
    case management(ManagementAction)
}
