import Redux

public struct DebugFeature: Reducer {
    public init() {}
    
    public struct State: Equatable, Codable, Hashable {
        public init() {}
        
        public var isLocalLog: Bool = false
        public var isRemoteLog: Bool = false
        public var isMock: Bool = false
    }
    
    public enum Action: Equatable, Codable {
        case onLocalLogChanged(Bool)
        case onRemoteLogChanged(Bool)
        case onMockChanged(Bool)
    }
}
