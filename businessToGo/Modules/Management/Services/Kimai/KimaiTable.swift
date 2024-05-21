import Foundation
import SQLite
import OfflineSync
import SQLite

class KimaiTable {
    var customers: DatabaseTable<KimaiCustomer>
    var projects: DatabaseTable<KimaiProject>
    var timesheets: DatabaseTable<KimaiTimesheet>
    var activities: DatabaseTable<KimaiActivity>
    var teams: DatabaseTable<KimaiTeam>
    
    init(_ db: Connection?, _ track: TrackTable){
        customers = DatabaseTable(db, "kimai_customers", track)
        projects = DatabaseTable(db, "kimai_projects", track)
        timesheets = DatabaseTable(db, "kimai_timesheets", track)
        activities = DatabaseTable(db, "kimai_activities", track)
        teams = DatabaseTable(db, "kimai_teams", track)
    }
}
