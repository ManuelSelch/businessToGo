import Foundation
import ComposableArchitecture

@Reducer
struct TaigaProjectFeature {
    struct State: Equatable {
        var integration: Integration
    }
    
    enum Action {
        
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        return .none
    }
}
