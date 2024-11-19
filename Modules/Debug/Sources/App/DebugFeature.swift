import Redux

import CommonServices

public struct DebugFeature: Reducer {
    public init() {}
    
    public struct State: Equatable, Codable, Hashable {
        public init() {}
        
        public var isRemoteLog: Bool = UserDefaultService.isRemoteLog
        public var isMock: Bool = UserDefaultService.isMock
    }
    
    public enum Action: Equatable, Codable {
        case onRemoteLogChanged(Bool)
        case onMockChanged(Bool)
    }
}
