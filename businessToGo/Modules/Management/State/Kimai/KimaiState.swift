import Foundation
import OfflineSync

enum KimaiRoute: Equatable, Hashable, Codable {
    case customers
    case customer(Int)
}

struct KimaiState: Equatable, Codable {
    var customers: [KimaiCustomer]
    var projects: [KimaiProject]
    var timesheets: [KimaiTimesheet]
    var activities: [KimaiActivity]
    var teams: [KimaiTeam]
    
    var customerTracks: [DatabaseChange]
    var projectTracks: [DatabaseChange]
    var timesheetTracks: [DatabaseChange]
    var activityTracks: [DatabaseChange]
    var teamTracks: [DatabaseChange]
}

extension KimaiState {
    init() {
        customers = []
        projects = []
        timesheets = []
        activities = []
        teams = []
        
        customerTracks = []
        projectTracks = []
        timesheetTracks = []
        activityTracks = []
        teamTracks = []
    }
}

