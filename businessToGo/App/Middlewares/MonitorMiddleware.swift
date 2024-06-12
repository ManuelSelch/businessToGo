import Foundation
import ReduxMonitor
import Combine
import Redux
import PulseLogHandler
import Log

import CommonServices

struct MonitorMiddleware {
    let monitor = ReduxMonitor(url: URL(string: "wss://redux.dev.manuelselch.de/socketcluster/?transport=websocket"))
    
    func handle(_ state: AppFeature.State, _ action: AppFeature.Action) -> AnyPublisher<AppFeature.Action, Never> {
        if(UserDefaultService.isLocalLog) {
            let actionFormatted = Log.LogMiddleware.formatAction(action)
            LoggerStore.shared.storeMessage(label: "Action", level: .debug, message: actionFormatted)
        }
        if(UserDefaultService.isRemoteLog) {
            monitor.connect()
            monitor.publish(action: AnyEncodable(action), state: AnyEncodable(state))
        }
        return .none
    }
}

