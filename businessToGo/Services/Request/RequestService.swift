import Foundation
import Combine
import Moya

class RequestService<Table: TableProtocol, Target: TargetType>: IRequestService<Table, Target> {
    var table: DatabaseTable<Table>
    var provider: MoyaProvider<Target>
    
    var fetchMethod: Target
    var insertMethod: ((Table) -> Target)?
    var updateMethod: ((Table) -> Target)?
    var deleteMethod: ((Table) -> Target)?
    
    init(
        _ table: DatabaseTable<Table>,
        _ provider: MoyaProvider<Target>,
        
        _ loadMethod: Target,
        _ insertMethod: ((Table) -> Target)? = nil,
        _ updateMethod: ((Table) -> Target)? = nil,
        _ deleteMethod: ((Table) -> Target)? = nil
    ) {
        self.table = table
        self.provider = provider
        
        self.fetchMethod = loadMethod
        self.insertMethod = insertMethod
        self.updateMethod = updateMethod
        self.deleteMethod = deleteMethod
    }
    
    override func get() -> [Table] {
        return table.getAll()
    }
    

    override func fetch() -> AnyPublisher<[Table], Error> {
        return Env.request(provider, fetchMethod)
    }
    
    /// add local record
    override func add(_ item: Table){
        _ = table.insertCreateOffline(item)
    }
    
    override func sync(_ remoteRecords: [Table]) -> AnyPublisher<DatabaseChange, Error> {
        LogService.log("********** sync \(table.getName()) **********")
        // 1. get remote data
        // 2. get local changes
        
        // insert       -> remote insert
        // update       -> remote update
        // delete       -> remote delete
        
        
        // no insert    -> local insert
        // no update    -> local update
        // no delete    -> local delete
        
        // ------------------------------
        
        var publishers: [AnyPublisher<DatabaseChange, Error>] = []
        
        let localRecords = table.getAll()
        
        for localRecord in localRecords {
            if let change = table.getTrack()?.getChange(localRecord.id, table.getName()) {
                switch(change.type){
                    case .insert: 
                        LogService.log("insert remote: \(localRecord)")
                        if let insertMethod = insertMethod {
                            let p: AnyPublisher<Table, Error> = Env.request(provider, insertMethod(localRecord))
                            publishers.append(
                                p
                                    .map { _ in  change}
                                    .eraseToAnyPublisher()
                            )
                        }
                    case .update:
                        LogService.log("update remote: \(localRecord)")
                        if let updateMethod = updateMethod {
                            let p: AnyPublisher<Table, Error> = Env.request(provider, updateMethod(localRecord))
                            publishers.append(
                                p
                                    .map { _ in  change}
                                    .eraseToAnyPublisher()
                            )
                        }
                    
                    case .delete: 
                        LogService.log("delete remote: \(localRecord)")
                        if let deleteMethod = deleteMethod {
                            let p: AnyPublisher<Table, Error> = Env.request(provider, deleteMethod(localRecord))
                            publishers.append(
                                p
                                    .map { _ in  change}
                                    .eraseToAnyPublisher()
                            )
                        }
                }
                
            }
        }
        
        for remoteRecord in remoteRecords {
            if let localRecord = localRecords.first(where: { $0.id == remoteRecord.id }) {
                if let change = table.getTrack()?.getChange(localRecord.id, table.getName()) {
                    if change.type == .insert {
                        LogService.log("insert local too: \(remoteRecord.id)")
                        // remote and local id are new records -> insert local too
                        _ = table.insert(remoteRecord) // local record will be overwritten but later fetched again
                        publishers.append(Env.just(change))
                    }
                    // else: remoteRecord old
                } else if localRecord != remoteRecord {
                    LogService.log("update local: \(remoteRecord.id)")
                    // remote data changed -> update local
                    _ = table.insert(remoteRecord)
                }
            } else {
                if table.getTrack()?.getChange(remoteRecord.id, table.getName()) == nil {
                    LogService.log("insert local: \(remoteRecord.id)")
                    // local record not found and was not deleted -> insert local
                    _ = table.insert(remoteRecord)
                }
                // else: local record is deleted
                
            }
        }
        
        
    
        LogService.log("********** sync finished **********")
        
        return Publishers.MergeMany(publishers).eraseToAnyPublisher()
    }
    
    override func hasSynced(_ change: DatabaseChange){
        table.getTrack()?.delete(change.id)
    }
    
    
}
