
import Foundation
import Combine

extension SettingsState {
    static func reduce(_ state: inout SettingsState, _ action: SettingsAction, _ env: SettingsDependency) -> AnyPublisher<SettingsAction, Error> {
        switch(action){
        case .route(let action):
            switch(action){
            case .push(let route):
                state.routes.append(route)
            case .pop:
                state.routes.removeLast()
            case .set(let routes):
                state.routes = routes
                
            case .presentSheet(let route):
                state.sheet = route
            case .dismissSheet:
                state.sheet = nil
            }
        }
        return Empty().eraseToAnyPublisher()
    }
}
