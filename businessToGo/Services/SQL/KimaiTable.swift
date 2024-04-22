import Foundation
import SQLite

struct KimaiTable {
    private var db: IDatabase
    
    var customers: DatabaseTable<KimaiCustomer>
    var projects: DatabaseTable<KimaiProject>
    var timesheets: DatabaseTable<KimaiTimesheet>
    var activities: DatabaseTable<KimaiActivity>
    
    private var track: ITrackTable
}

extension KimaiTable {
    init(_ db: IDatabase, _ track: ITrackTable) {
        self.db = db
        self.track = track
        
        customers = DatabaseTable(db.connection, "customers")
        projects = DatabaseTable(db.connection, "projects")
        timesheets = DatabaseTable(db.connection, "timesheets", track)
        activities = DatabaseTable(db.connection, "activities")
    }
}
