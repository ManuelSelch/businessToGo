import SwiftUI
import Combine
import ComposableArchitecture
import Logging
import PulseUI
import SwiftUI
import TCASwiftLog
import PulseLogHandler

@main
struct businessToGoApp: App {
    let store: StoreOf<AppModule>
    
    init() {
        LoggingSystem.bootstrap(PersistentLogHandler.init)
        
        store = Store(initialState: AppModule.State()){
            AppModule()
                ._printChanges(.swiftLog(label: "tca"))
        }
    }
    
    
    var body: some Scene {
        WindowGroup {
            AppContainer(store: store)
                .scrollContentBackground(.hidden)
             
        }
    }
}


