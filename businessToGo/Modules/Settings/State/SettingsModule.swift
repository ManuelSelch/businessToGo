import Foundation
import ComposableArchitecture
import Redux
import Combine

@Reducer
struct SettingsModule {
    struct State: Codable, Equatable {
        var router: RouteModule<SettingsRoute>.State = .init()
    }
    
    enum Action {
        case route(RouteModule<SettingsRoute>.Action)
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch(action){
        case .route(let action):
            return .publisher {
                RouteModule.reduce(&state.router, action, .init())
                    .map { .route($0) }
                    .catch { _ in Empty() }
            }
            
            
           
        }
    }
    
   
}
