import Foundation
import Combine
import Redux
import OfflineSyncServices
import OfflineSyncCore
import Dependencies

import KimaiCore
import KimaiServices

/// kimai backend storage
public struct KimaiFeature: Reducer {
    @Dependency(\.kimai) var kimai
    
    public init() {}

    public struct State: Equatable, Codable, Hashable {
        public init() {}
        
        public var isSyncing = false
        public var selectedTeam: Int?
        
        public var customers: [KimaiCustomer] = []
        public var projects: [KimaiProject] = []
        public var activities: [KimaiActivity] = []
        public var timesheets: [KimaiTimesheet] = []
        
        public var teams: [KimaiTeam] = []
        public var users: [KimaiUser] = []
        
        public var customerChanges: [DatabaseChange] = []
        public var projectChanges: [DatabaseChange] = []
        public var activityChanges: [DatabaseChange] = []
        public var timesheetChanges: [DatabaseChange] = []
    }
    
    public enum Action: Codable, Equatable {
        case sync 
        case synced(
            [KimaiCustomer], [KimaiProject], [KimaiActivity], [KimaiTeam], [KimaiUser], [KimaiTimesheet]
        )
        
        case customer(CustomerAction)
        case project(ProjectAction)
        case activity(ActivityAction)
        case timesheet(TimesheetAction)
        
        case delegate(DelegateAction)
    }
    
    public enum CustomerAction: Codable, Equatable {
        case teamSelected(Int?)
        case save(KimaiCustomer)
        case delete(KimaiCustomer)
        case deleteConfirmed(KimaiCustomer)
    }

    public enum ProjectAction: Codable, Equatable {
        case save(KimaiProject)
        case delete(KimaiProject)
        case deleteConfirmed(KimaiProject)
    }
    
    public enum ActivityAction: Codable, Equatable {
        case save(KimaiActivity)
        case delete(KimaiActivity)
        case deleteConfirmed(KimaiActivity)
    }
    
    
    public enum TimesheetAction: Codable, Equatable {
        case save(KimaiTimesheet)
        case delete(KimaiTimesheet)
        case deleteConfirmed(KimaiTimesheet)
    }
    
    public enum DelegateAction: Codable, Equatable {
        case popup(KimaiPopupRoute)
        case dismissPopup
    }
}



