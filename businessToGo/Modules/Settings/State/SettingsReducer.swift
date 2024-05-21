import Foundation
import Combine
import Redux

extension SettingsModule: Reducer {
    static func reduce(_ state: inout State, _ action: Action, _ env: Dependency) -> AnyPublisher<Action, Error> {
        switch(action){
        case .route(let action):
            return RouteModule.reduce(&state.router, action, .init())
                .map { .route($0) }
                .eraseToAnyPublisher()
        }
    }
}
