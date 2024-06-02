import SwiftUI
import Combine
import Redux
import PulseUI
import SwiftUI
import PulseLogHandler
import os

import ReduxMonitor

struct businessToGoApp: App {
    let store: StoreOf<AppFeature>
    
    init() {
        //DependencyValues[\.keychain] = .mock
        //DependencyValues[\.database] = .mock
        
        store = Store(
            initialState: .init(),
            reducer: AppFeature(),
            middlewares: [
                MonitorMiddleware().handle
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

struct MonitorMiddleware {
    let monitor = ReduxMonitor(url: URL(string: "wss://redux.dev.manuelselch.de/socketcluster/?transport=websocket"))
    
    func handle(_ state: AppFeature.State, _ action: AppFeature.Action) -> AnyPublisher<AppFeature.Action, Never> {
        monitor.connect()
        monitor.publish(action: AnyEncodable(action), state: AnyEncodable(state))
        
        return .run { send in
            monitor.monitorAction = { monitorAction in
                let decoder = JSONDecoder()
                switch(monitorAction.type) {
                case let .jumpToState(_, stateDataString):
                    guard
                        let stateData = stateDataString.data(using: .utf8),
                        let newState = try? decoder.decode(AppFeature.State.self, from: stateData)
                    else {
                        return
                    }
                    // send(.success(.setState(newState)))
                    // dispatch(SetState(payload: newState))
                    
                default: break
                    
                    
                    
                }
            }
        }
    }
}


