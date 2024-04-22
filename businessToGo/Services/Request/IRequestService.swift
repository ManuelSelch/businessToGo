import Foundation
import Combine
import Moya

enum RequestMethodType<Input, Target> {
    case wihtinput((Input) -> Target)
    case noinput(Target)
}

class IRequestService<Table: TableProtocol, Target: TargetType> {
    /// get local records
    func get() -> [Table] {
        return []
    }
    /// load remote records
    func fetch() -> AnyPublisher<[Table], Error> {
        return Empty().eraseToAnyPublisher()
    }
    
    /// add local record
    func add(_ item: Table){
        
    }
    
    ///  sync remote with local records
    func sync(_ remoteRecords: [Table]) -> AnyPublisher<DatabaseChange, Error>{
        return Empty().eraseToAnyPublisher()
    }
    
    /// this change has been synced -> delete change history
    func hasSynced(_ change: DatabaseChange) {
        
    }
}
