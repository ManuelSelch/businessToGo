import SwiftUI
import Combine
import os

import Redux
import ReduxDebug
import Dependencies
import PulseLogHandler

import CommonServices

struct businessToGoApp: App {
    let store: StoreOf<AppFeature>
    
    static func onAction(_ action: MonitorMiddleware<AppFeature.Action, AppFeature.State>.ActionType) -> AppFeature.Action {
        switch(action) {
        case .reset:
            return .setState(.init())
        case let .jumpTo(state):
            return .setState(state)
        }
    }
    
    static func showAction(_ action: AppFeature.Action) -> Bool {
        switch(action) {
        case .setState: return false
        default: return true
        }
    }
    
    init() {
        // log network requests
        URLSessionProxyDelegate.enableAutomaticRegistration()
        
        DependencyValues.mode = UserDefaultService.isMock ? .mock : .live
        
        let state = AppFeature.State()
        let monitor = MonitorMiddleware<AppFeature.Action, AppFeature.State>(
            currentState: state,
            onAction: Self.onAction,
            showAction: Self.showAction,
            isRemoteLog: { UserDefaultService.isRemoteLog }
        )
        
        store = Store(
            initialState: state,
            reducer: AppFeature(),
            middlewares: [
                monitor.handle
            ]
        )
        
        
    }
    
    
    var body: some Scene {
        WindowGroup {
            AppContainer(store: store)
                .scrollContentBackground(.hidden)
             
        }
    }
}
