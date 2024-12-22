import SwiftUI
import Combine
import os
import TipKit

import Redux
import ReduxDebug
import Dependencies
import PulseLogHandler

import CommonServices
import BoardingUI
import BoardingCore


struct businessToGoApp: App {
    let store: StoreOf<AppFeature>
    @State private var featureFrames: [FeatureIdentifier: CGRect] = [:]
    
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
            VStack {
                AppContainer(store: store)
                    .scrollContentBackground(.hidden)
                
                if #available(iOS 17.0, *) {
                    TipView(FavoriteLandmarkTip(), arrowEdge: .bottom)
                }
                
                Text("Hello, World!")
                    .padding()
            }
            .task {
                if #available(iOS 17.0, *) {
                    do {
                        try Tips.configure()
                    }
                    catch {
                        // Handle TipKit errors
                        print("Error initializing TipKit \(error.localizedDescription)")
                    }
                }
           }
           
        }
    }
}

@available(iOS 17.0, *)
struct FavoriteLandmarkTip: Tip {
    var title: Text {
        Text("Save as a Favorite")
    }


    var message: Text? {
        Text("Your favorite landmarks always appear at the top of the list.")
    }


    var image: Image? {
        Image(systemName: "star")
    }
}
