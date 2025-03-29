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
        
        public var syncStatus: SyncStatus = .idle
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
        case syncFailed
        
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
    
    public enum Route: Codable, Equatable, Hashable {
        case customersList
        case customerSheet(KimaiCustomer)
        
        case projectsList(for: Int)
        case projectSheet(KimaiProject)
        case projectDetail(Int)
        
        case activitySheet(KimaiActivity)
        
        case timesheetSheet(KimaiTimesheet)
        
        case popup(KimaiPopupRoute)
        
        var title: String {
            switch self {
            case .customersList: return "Customers"
            case let .customerSheet(customer): return customer.name
                
            case .projectsList(_): return "Projects"
            case let .projectSheet(project):
                if(project.id == KimaiProject.new.id) {
                    return "New Project"
                } else {
                    return project.name
                }
                
            case let .activitySheet(activity):
                if(activity.id == KimaiActivity.new.id) {
                    return "New Activity"
                } else {
                    return activity.name
                }
                
            case .projectDetail(_): return "Project"
            case .timesheetSheet(_): return "Timesheet"
            
            case .popup(_): return "Popup"
                
            }
        }
    }
}



