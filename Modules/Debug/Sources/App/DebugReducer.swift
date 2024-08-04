import Redux

public extension DebugFeature {
    func reduce(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch(action) {
            
        case let .onLocalLogChanged(val):
            state.isLocalLog = val
        case let .onRemoteLogChanged(val):
            state.isRemoteLog = val
        case let .onMockChanged(val):
            state.isMock = val
        }
        
        return .none
    }
}
