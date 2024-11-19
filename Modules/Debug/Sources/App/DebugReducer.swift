import Redux

import CommonServices

public extension DebugFeature {
    func reduce(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch(action) {
        case let .onRemoteLogChanged(val):
            state.isRemoteLog = val
            UserDefaultService.isRemoteLog = val
        case let .onMockChanged(val):
            state.isMock = val
            UserDefaultService.isMock = val
        }
        
        return .none
    }
}
