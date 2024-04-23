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
    
    /// get local record by id
    func get(by id: Int) -> Table? {
        return nil
    }
    /// load remote records
    func fetch() -> AnyPublisher<[Table], Error> {
        return Empty().eraseToAnyPublisher()
    }
    
    /// create local record
    func create(_ item: Table){
        
    }
    
    /// update local record
    func update(_ item: Table){
        
    }
    
    ///  sync remote with local records
    func sync(_ remoteRecords: [Table]) -> AnyPublisher<SyncResponse<Table>, Error>{
        return Empty().eraseToAnyPublisher()
    }
    
    /// this change has been synced -> delete change history
    func hasSynced(_ response: SyncResponse<Table>) {
        
    }
}
