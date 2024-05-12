import Foundation
import OfflineSync

enum KimaiRoute: Equatable, Hashable {
    case customers
    case chart
    case customer(Int)
    case project(Int)
}

struct KimaiState: Equatable {
    var customers: [KimaiCustomer]
    var projects: [KimaiProject]
    var timesheets: [KimaiTimesheet]
    var activities: [KimaiActivity]
    
    var customerTracks: [DatabaseChange]
    var projectTracks: [DatabaseChange]
    var timesheetTracks: [DatabaseChange]
    var activityTracks: [DatabaseChange]
}

extension KimaiState {
    init() {
        customers = []
        projects = []
        timesheets = []
        activities = []
        
        customerTracks = []
        projectTracks = []
        timesheetTracks = []
        activityTracks = []
    }
}

