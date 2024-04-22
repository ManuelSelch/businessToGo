import Foundation
import SQLite

/*
 sync system:
 - fetch remote data
 - update old local data by timestamp
 - update old remote data
 */
protocol TableSyncProtocol: Encodable {
    var metaFields: [String: String] { get set }
}

protocol TableProtocol: Codable, Equatable, Identifiable {
    var id: Int { get set }
    /// Mirror(reflecting: T())
    init()
}

class DatabaseTable<T: TableProtocol> {
    private var db: Connection?
    private let table: Table
    private let tableName: String
    private var dbPath: String?
    
    private var id = Expression<Int>("id")
    
    private let track: ITrackTable?
    
    init(_ db: Connection?, _ tableName: String, _ track: ITrackTable? = nil) {
        self.track = track
        self.db = db
        self.tableName = tableName
        
        table = Table(tableName)
        createTable()
    }
    
    func clear() {
        do {
            try db?.run(table.delete())
        } catch {
            LogService.log("clear table failed")
        }
    }
    
    func insertCreateOffline(_ item: T) -> Bool {
        var item = item
        do {
            item.id = getLastId() + 1
            try db?.run(table.insert(or: .replace, encodable: item))
            track?.insert(item.id, tableName, .insert)
            
        } catch {
            LogService.log("\(error); \(item.id)T")
            return false
        }
        
        return true
    }
    
    func insert(_ item: T) -> Bool {
        let item = item
        do {
            try db?.run(table.insert(or: .replace, encodable: item))
        } catch {
            LogService.log("\(error); \(item.id)T")
            return false
        }
        
        return true
    }
    
    func getLastId() -> Int {
        return getAll().max(by: { $0.id < $1.id })?.id ?? 0
    }
    
    func insertAll(_ items: [T]) -> Bool {
        if (T.self as? TableSyncProtocol) == nil {
            // no sync service -> just replace data
            clear()
        }
        
        for item in items {
            _ = insert(item)
        }
        
        return true
    }
    
    func getTimestamp(_ item: T) -> String {
        return (get(by: item.id) as? TableSyncProtocol)?.metaFields["timestamp"] ?? "\(Date.now)"
    }
    
    func update(_ item: T) {
        do {
            try db?.run(table.filter(id == item.id).update(item))
            track?.insert(item.id, tableName, .update)
        } catch {
            LogService.log("Error updating item: \(error); \(item.id)")
        }
    }
    
    func delete(_ item: T) {
        do {
            try db?.run(table.filter(id == item.id).delete())
            track?.insert(item.id, tableName, .delete)
        } catch {
            LogService.log("Error deleting item: \(error); \(item.id)")
        }
    }
    
    func getAll() -> [T] {
        guard let db = db else { return [] }
        do {
            let records: [T] = try db.prepare(table).map { row in
                return try row.decode()
            }
            return records
        } catch {
            return []
        }
    }
    
    func get(by id: Int) -> T? {
        do {
            let query = table.filter(self.id == id)
            let row = try db?.pluck(query)
            return try row?.decode()
        } catch {
            return nil
        }
    }
    
    private func createTable() {
        let createTable = table.create(ifNotExists: true) { (table) in
            
            let mirror = Mirror(reflecting: T())
            
            for (name, value) in mirror.children {
                guard let name = name else { continue }
                
                let type = type(of: value)
                
                
                
                if(name == "id"){
                    // table.column(id, primaryKey: .default)
                    table.column(id)
                }else{
                    switch type {
                    case is String.Type:
                        table.column(Expression<String>(name))
                    case is Int.Type:
                        table.column(Expression<Int>(name))
                    case is Bool.Type:
                        table.column(Expression<Bool>(name))
                    case is Double.Type:
                        table.column(Expression<Double>(name))
                        
                    case is String?.Type:
                        table.column(Expression<String?>(name))
                    case is Int?.Type:
                        table.column(Expression<Int?>(name))
                    case is Bool?.Type:
                        table.column(Expression<Bool?>(name))
                    case is Double?.Type:
                        table.column(Expression<Double?>(name))
                        
                    default:
                        table.column(Expression<String>(name))
                    }
                }
                
                
            }
        }
        
        do {
            try db?.run(createTable)
        } catch {
            LogService.log("Error creating table: \(error)")
        }
    }
    
    func getTrack() -> ITrackTable? {
        return track
    }
    
    func getName() -> String {
        return tableName
    }
}


