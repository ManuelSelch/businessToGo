import SwiftUI
import Combine
import Redux
import SwiftUI
import PulseLogHandler
import os

struct businessToGoApp: App {
    let store: StoreOf<AppFeature>
    
    init() {
        // log network requests
        URLSessionProxyDelegate.enableAutomaticRegistration()
        
        store = Store(
            initialState: .init(),
            reducer: AppFeature(),
            middlewares: [
                MonitorMiddleware().handle
            ],
            errorAction: { error in
                LoggerStore.shared.storeMessage(label: "Error", level: .warning, message: "\(error)")
                return .log(.error(error.localizedDescription))
            }
        )
        
        
    }
    
    
    var body: some Scene {
        WindowGroup {
            AppContainer(store: store)
                .scrollContentBackground(.hidden)
             
        }
    }
}
