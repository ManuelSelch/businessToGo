import Foundation
import ComposableArchitecture

@Reducer
struct DebugFeature {
    @Dependency(\.database) var database
    
    @ObservableState
    struct State: Equatable {
        @Shared var current: Account?
        
        @Shared var kimai: KimaiModule.State
        @Shared var taiga: TaigaModule.State
        @Shared var integrations: [Integration]
    }
    
    enum Action {
        case resetTapped
    }
    

    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch(action){
        case .resetTapped:
            database.reset()
            return .none
        }
    }
}
