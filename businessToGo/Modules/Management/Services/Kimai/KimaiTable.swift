import Foundation
import SQLite
import OfflineSync

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
        
        customers = DatabaseTable(db.connection, "kimai_customers", track)
        projects = DatabaseTable(db.connection, "kimai_projects", track)
        timesheets = DatabaseTable(db.connection, "kimai_timesheets", track)
        activities = DatabaseTable(db.connection, "kimai_activities", track)
    }
}
