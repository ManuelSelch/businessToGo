import Foundation
import SQLite

@available(iOS 16.0, *)
public class DatabaseTable02<T: TableProtocol> {
    private var db: Connection?
    private let table: Table
    private let tableName: String
    private var dbPath: String?
    
    private var id = Expression<Int>("id")
    private var fields: [String: Expression<Any>] = [:]
    
    private let track: TrackTable?
    
    public init(_ db: Connection?, _ tableName: String, _ track: TrackTable? = nil) {
        self.track = track
        self.db = db
        self.tableName = tableName
        
        table = Table(tableName)
        createTable()
    }
    
    public func clear() {
        do {
            try db?.run(table.delete())
        } catch {
            
        }
    }
    
    /// sets record it to lastID+1 and track changes
    public func create(_ item: T){
        var item = item
        item.id = getLastId() + 1
        insert(item, isTrack: true)
        
    }
    
    public func insert(_ item: T, isTrack: Bool) {
        let item = item
        do {
            try db?.run(table.insert(or: .replace, encodable: item))
            if(isTrack){
                track?.insert(item.id, tableName, .insert)
            }
        } catch {
            print("database insert error: \(error.localizedDescription)")
        }
    }
    
    public func getLastId() -> Int {
        return get().max(by: { $0.id < $1.id })?.id ?? 0
    }
    
    public func getTimestamp(_ item: T) -> String {
        return (get(by: item.id) as? TableSyncProtocol)?.metaFields["timestamp"] ?? "\(Date.now)"
    }
    
    public func update(_ item: T, isTrack: Bool) {
        do {
            try db?.run(table.filter(id == item.id).update(item))
            if(isTrack){
                track?.insert(item.id, tableName, .update)
            }
        } catch {
            
        }
    }
    
    public func delete(_ id: Int, isTrack: Bool) {
        do {
            try db?.run(table.filter(self.id == id).delete())
            if(isTrack){
                track?.insert(id, tableName, .delete)
            }
        } catch {
            
        }
    }
    
    public func get() -> [T] {
        guard let db = db else { print("no connection db..."); return [] }
        
        do {
            let records: [T] = try db.prepare(table).map { row in
                return try row.decode()
            }
            return records
            
        } catch {
            print("error db...: \(error.localizedDescription)")
            return []
        }
    }
    
    public func get(by id: Int) -> T? {
        guard let db = db else { return nil }
        
        do {
            let records: [T] = try db.prepare(table.filter(self.id == id)).map { row in
                return try row.decode()
            }
            return records.first
           
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
                    table.column(id, primaryKey: .default)
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
            
        }
    }
    
    public func getTrack() -> TrackTable? {
        return track
    }
    
    public func getName() -> String {
        return tableName
    }
}


