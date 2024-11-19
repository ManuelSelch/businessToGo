import Redux


import IntegrationCore

public struct IntegrationFeature: Reducer {
    public init() {}
    
    public struct State: Equatable, Codable, Hashable {
        public init() {}
        
        public var integrations: [Integration] = []
    }
    
    public enum Action: Equatable, Codable {
        case onConnect(_ kimai: Int, _ taiga: Int)
    }
}
