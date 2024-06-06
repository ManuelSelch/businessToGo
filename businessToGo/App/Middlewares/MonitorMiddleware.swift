import Foundation
import ReduxMonitor
import Combine
import Redux
import PulseLogHandler
import Log

import AppCore

struct MonitorMiddleware {
    let monitor = ReduxMonitor(url: URL(string: "wss://redux.dev.manuelselch.de/socketcluster/?transport=websocket"))
    
    func handle(_ state: AppFeature.State, _ action: AppFeature.Action) -> AnyPublisher<AppFeature.Action, Never> {
        if(UserDefault.isLocalLog) {
            let actionFormatted = Log.LogMiddleware.formatAction(action)
            LoggerStore.shared.storeMessage(label: "Action", level: .debug, message: actionFormatted)
        }
        if(UserDefault.isRemoteLog) {
            monitor.connect()
            monitor.publish(action: AnyEncodable(action), state: AnyEncodable(state))
        }
        return .none
    }
}
