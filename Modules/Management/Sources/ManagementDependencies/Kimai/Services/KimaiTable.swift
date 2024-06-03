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
    var users: DatabaseTable<KimaiUser>
    
    init(){
        customers = DatabaseTable("kimai_customers")
        projects = DatabaseTable("kimai_projects")
        timesheets = DatabaseTable("kimai_timesheets")
        activities = DatabaseTable("kimai_activities")
        teams = DatabaseTable("kimai_teams")
        users = DatabaseTable("kimai_users")
    }
}
