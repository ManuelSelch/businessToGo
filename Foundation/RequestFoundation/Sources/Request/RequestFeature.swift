import Foundation
import Redux
import Moya
import OfflineSync
import Dependencies

public struct RequestFeature<Model: TableProtocol, Target: TargetType> {
    var service: RequestService<Model, Target>
    
    @Dependency(\.track) var track
    
    public struct State: Equatable, Codable {
        var records: [Model] = []
        var changes: [DatabaseChange] = []
    }
    
    public enum Action: Codable, Equatable {
        /// set synced records
        case set([Model])
        
        /// create local record
        case create(Model)
        /// update local record
        case update(Model)
        /// delete local record
        case delete(Model)
    }
}
