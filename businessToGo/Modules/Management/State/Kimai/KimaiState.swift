import Foundation

enum KimaiRoute: Equatable, Hashable {
    case customers
    case chart
    case customer(Int)
    case project(Int)
    case timesheet(Int)
}

struct KimaiState: Equatable {
    var customers: [KimaiCustomer]
    var projects: [KimaiProject]
    var timesheets: [KimaiTimesheet]
    var activities: [KimaiActivity]
}

extension KimaiState {
    init() {
        customers = []
        projects = []
        timesheets = []
        activities = []
    }
}

