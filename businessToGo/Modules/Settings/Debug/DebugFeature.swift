import Foundation
import ComposableArchitecture

@Reducer
struct DebugFeature {
    
    @ObservableState
    struct State: Equatable {
        @Shared var current: Account?
        
        @Shared var kimai: KimaiModule.State
        @Shared var taiga: TaigaModule.State
        @Shared var integrations: [Integration]
    }
    
    enum Action {
        case resetTapped
        case delegate(Delegate)
    }
    
    enum Delegate {
        case reset
    }

    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch(action){
        case .resetTapped:
            return .send(.delegate(.reset))
        case .delegate:
            return .none
        }
    }
}
