import Foundation
import Combine

extension LogState {
    static func reduce(_ state: inout LogState, _ action: LogAction) -> AnyPublisher<LogAction, Error> {
        
        switch action {
        case .error(let error):
            state.error = error
        case .message(_):
            // state.message = message
            break
        }
        
        
        return Empty().eraseToAnyPublisher()
    }
}
