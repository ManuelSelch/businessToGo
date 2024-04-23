import Foundation

enum MenuAction {
    case navigate(AppScreen)
    case logout
    case resetDatabase
}

enum AppAction {
    case menu(MenuAction)
    case log(LogAction)
    
    case login(LoginAction)
    case kimai(KimaiAction)
    case taiga(TaigaAction)
}
