import Foundation
import SQLite
import Combine

protocol IDatabase {
    var connection: Connection? { get }
    func create()
    func reset()
}

class Database: IDatabase {
    var connection: Connection?
    private var dbPath: String?
    private var databaseName: String
    
    
    init(_ databaseName: String) {
        self.databaseName = databaseName
        create()
    }
    
    func create(){
        if let dirPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            dbPath = dirPath.appendingPathComponent(databaseName).path
            
            do {
                connection = try Connection(dbPath!)
            } catch {
                connection = nil
                LogService.log("SQLiteDataStore init error: \(error)")
            }
        }else{
            dbPath = nil
            connection = nil
        }
    }
    
    
    func reset()
    {
        if let dbPath = dbPath {
            let filemManager = FileManager.default
            do {
                let fileURL = NSURL(fileURLWithPath: dbPath)
                try filemManager.removeItem(at: fileURL as URL)
                print("Database Deleted!")
            } catch {
                print("Error on Delete Database!!!")
            }
        }
        
        create()
    }
    
    static let mock = DatabaseMock()
}

class DatabaseMock: IDatabase {
    var connection: Connection?
    
    
    init() {
        create()
    }
    
    func create(){
        do {
            connection = try Connection(.inMemory)
        }catch {
            
        }
    }
    
    
    func reset()
    {
        create()
    }
    
}



