import Foundation
import ReduxMonitor
import Combine
import Redux
import PulseLogHandler
import Log

import CommonServices

final class MonitorMiddleware {
    private let monitor: ReduxMonitor
    private var subject: PassthroughSubject<AppFeature.Action, Never>
    private var cancellables: Set<AnyCancellable> = []
    
    private var isRemoteSetup = false

    init() {
        self.monitor = ReduxMonitor(url: URL(string: "wss://redux.dev.manuelselch.de/socketcluster/?transport=websocket")!)
        self.subject = PassthroughSubject<AppFeature.Action, Never>()
    }

    private func setupMonitor() {
        monitor.connect()
        monitor.monitorAction = { [weak self] monitorAction in
            guard let self = self else { return }
            let decoder = JSONDecoder()

            switch monitorAction.type {
            case let .jumpToState(_, stateDataString):
                guard
                    let stateData = stateDataString.data(using: .utf8),
                    let newState = try? decoder.decode(AppFeature.State.self, from: stateData)
                else {
                    print("failed parsing state to jump")
                    return
                }
                print("jump to state")
                self.subject.send(.setState(newState))

            case let .action(actionString):
                guard let actionRawData = actionString.data(using: .utf8) else {
                    return print("failed receiving action to dispatch")
                }
                do {
                    let action = try decoder.decode(AppFeature.Action.self, from: actionRawData)
                    self.subject.send(action)
                } catch let e {
                    print("failed parsing action to dispatch: ", e)
                }
            }
        }
    }

    func handle(_ state: AppFeature.State, _ action: AppFeature.Action) -> AnyPublisher<AppFeature.Action, Never> {
        if UserDefaultService.isLocalLog {
            let actionFormatted = Log.LogMiddleware.formatAction(action)
            LoggerStore.shared.storeMessage(label: "Action", level: .debug, message: actionFormatted)
        }

        if UserDefaultService.isRemoteLog {
            if(!isRemoteSetup) {
                setupMonitor()
                isRemoteSetup = true
            }
            
            switch(action) {
            case .setState:
                break
            default:
                monitor.publish(action: AnyEncodable(action), state: AnyEncodable(state))
            }
            
            return subject.eraseToAnyPublisher()
        }
        
        return .none
    }
}
