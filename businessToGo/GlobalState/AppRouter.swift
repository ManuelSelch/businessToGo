import SwiftUI

class AppRouter: ObservableObject {
    var tab = AppScreen.login
    
    var management = ManagementRouter()
}

struct RouterKey: EnvironmentKey {
    static let defaultValue: AppRouter = AppRouter()
}

extension EnvironmentValues {
    var router: AppRouter {
        get { self[RouterKey.self] }
        set { self[RouterKey.self] = newValue }
    }
}
