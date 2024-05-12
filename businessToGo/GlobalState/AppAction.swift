import Foundation
import Log

enum AppAction {
    case log(LogAction)
    
    case login(LoginAction)
    case management(ManagementAction)
}
