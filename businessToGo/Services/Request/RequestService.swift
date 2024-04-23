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
        return table.get()
    }
    
    override func get(by id: Int) -> Table? {
        return table.get(by: id)
    }
    

    override func fetch() -> AnyPublisher<[Table], Error> {
        return Env.request(provider, fetchMethod)
    }
    
    
    override func create(_ item: Table){
        table.create(item)
    }
    
    override func update(_ item: Table) {
        table.update(item, isTrack: true)
    }
    
    override func sync(_ remoteRecords: [Table]) -> AnyPublisher<SyncResponse<Table>, Error> {
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
        
        var publishers: [AnyPublisher<SyncResponse<Table>, Error>] = []
        
        let localRecords = table.get()
        
        for localRecord in localRecords {
            if let change = table.getTrack()?.getChange(localRecord.id, table.getName()) {
                switch(change.type){
                    case .insert: 
                        LogService.log("insert remote: \(localRecord)")
                        if let insertMethod = insertMethod {
                            let p: AnyPublisher<Table, Error> = Env.request(provider, insertMethod(localRecord))
                            publishers.append(
                                p
                                    .map { SyncResponse(change: change, result: $0) }
                                    .eraseToAnyPublisher()
                            )
                        }
                    case .update:
                        LogService.log("update remote: \(localRecord)")
                        if let updateMethod = updateMethod {
                            let p: AnyPublisher<Table, Error> = Env.request(provider, updateMethod(localRecord))
                            publishers.append(
                                p
                                    .map { SyncResponse(change: change, result: $0) }
                                    .eraseToAnyPublisher()
                            )
                        }
                    
                    case .delete: 
                        LogService.log("delete remote: \(localRecord)")
                        if let deleteMethod = deleteMethod {
                            let p: AnyPublisher<Table, Error> = Env.request(provider, deleteMethod(localRecord))
                            publishers.append(
                                p
                                    .map { SyncResponse(change: change, result: $0) }
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
                        table.insert(remoteRecord, isTrack: false) // local record will be overwritten but later fetched again
                    }
                    // else: remoteRecord old
                } else if localRecord != remoteRecord {
                    LogService.log("update local: \(remoteRecord.id)")
                    // remote data changed -> update local
                    table.update(remoteRecord, isTrack: false)
                }
            } else {
                if table.getTrack()?.getChange(remoteRecord.id, table.getName()) == nil {
                    LogService.log("insert local: \(remoteRecord.id)")
                    // local record not found and was not deleted -> insert local
                    table.insert(remoteRecord, isTrack: false)
                }
                // else: local record is deleted
                
            }
        }
        
        
    
        LogService.log("********** sync finished **********")
        
        return Publishers.MergeMany(publishers).eraseToAnyPublisher()
    }
    
    override func hasSynced(_ response: SyncResponse<Table>){
        table.getTrack()?.delete(by: response.change.recordID)
        if(response.change.recordID != response.result.id){
            // id has changed -> delete and reinsert record
            table.delete(response.change.recordID, isTrack: false)
            table.insert(response.result, isTrack: false)
        }else {
            table.update(response.result, isTrack: false)
        }
    }
    
    
}
