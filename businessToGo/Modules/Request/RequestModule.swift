import Foundation
import ComposableArchitecture
import OfflineSync
import Moya

@Reducer
struct RequestModule<Model: TableProtocol, Target: TargetType> {
    var service: RequestService<Model, Target>
    
    @Dependency(\.track) var track
    
    struct State: Equatable, Codable {
        var records: [Model] = []
        var changes: [DatabaseChange] = []
    }
    
    enum Action {
        /// sync by remote data
        case sync
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
