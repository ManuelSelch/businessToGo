import Foundation
import OfflineSync
import Redux
import SwiftUI

enum KimaiRoute: Equatable, Hashable, Codable {
    case customers
    case customer(KimaiCustomer)
    
    case projects(for: Int)
    case project(KimaiProject)
    
    case timesheet(KimaiTimesheet)
}



struct KimaiState: Equatable, Codable {
    var selectedTeam: Int?
    
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

