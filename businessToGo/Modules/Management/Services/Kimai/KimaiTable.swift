import Foundation
import SQLite
import OfflineSync
import SQLite

struct KimaiTable {
    var customers: DatabaseTable<KimaiCustomer>
    var projects: DatabaseTable<KimaiProject>
    var timesheets: DatabaseTable<KimaiTimesheet>
    var activities: DatabaseTable<KimaiActivity>
    var teams: DatabaseTable<KimaiTeam>
    
    private var track: TrackTable
}

extension KimaiTable {
    static func live(_ db: Connection?, _ track: TrackTable) -> Self {
        
        return Self(
            customers: DatabaseTable.live(db, "kimai_customers", track),
            projects: DatabaseTable.live(db, "kimai_projects", track),
            timesheets: DatabaseTable.live(db, "kimai_timesheets", track),
            activities: DatabaseTable.live(db, "kimai_activities", track),
            teams: DatabaseTable.live(db, "kimai_teams", track),
            track: track
        )
    }
}
