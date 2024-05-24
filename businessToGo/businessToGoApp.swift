import SwiftUI
import Combine
import ComposableArchitecture
import Log

@main
struct businessToGoApp: App {
    let store = Store(initialState: AppModule.State()){
        AppModule()
            ._printChanges()
    }
    
    
    var body: some Scene {
        WindowGroup {
            AppContainer(store: store)
                .scrollContentBackground(.hidden)
             
        }
    }
}


