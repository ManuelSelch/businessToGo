import Foundation
import Combine
import Redux
import Dependencies

import KimaiCore
import KimaiServices

/// kimai backend storage
public struct KimaiFeature: Reducer {
    @Dependency(\.kimai) var kimai
    
    public init() {}
    
    public struct State: Equatable, Codable {
        public init() {}
        
        public var selectedTeam: Int?
        
        public var customers: [KimaiCustomer] = []
        public var projects: [KimaiProject] = []
        public var timesheets: [KimaiTimesheet] = []
        public var activities: [KimaiActivity] = []
        public var teams: [KimaiTeam] = []
        public var users: [KimaiUser] = []
        
        var currentStep: KimaiAssistantStep? {
            if(customers.count == 0) {
                return .customer
            } else if(projects.count == 0) {
                return .project
            } else if(activities.count == 0) {
                return .activity
            } else if(timesheets.count == 0) {
                return .timesheet
            } else {
                return nil
            }
        }
        
        var steps: [KimaiAssistantStep] = KimaiAssistantStep.allCases
        
        
        public func title(_ route: KimaiRoute) -> String {
            switch(route) {
            case .customersList:
                return "Kunden"
            case let .customerSheet(customer):
                return customer.name
            case let .projectsList(customerId):
                return customers.first(where: { $0.id == customerId })?.name ?? "--"
            case let .projectSheet(project):
                return project.name
            case let .projectDetail(project):
                return project.name
            case let .timesheetSheet(timesheet):
                return "Timesheet"
            }
        }
    }
    
    public enum Action: Codable, Equatable {
        case synced(SyncAction)
        
        case assistant(AssistantAction)
        
        case customerList(CustomerListAction)
        
        case projectList(ProjectListAction)
        case projectSheet(ProjectSheetAction)
        case projectDetail(ProjectDetailAction)
        
        case timesheetSheet(TimesheetSheetAction)
        
        case delegate(Delegate)
    }
    
    public enum Delegate: Codable, Equatable {
        case route(KimaiRoute)
        case dismiss
    }
    
    public enum SyncAction: Codable, Equatable {
        case customers([KimaiCustomer])
        case projects([KimaiProject])
        case activities([KimaiActivity])
        case teams([KimaiTeam])
        case users([KimaiUser])
        case timesheets([KimaiTimesheet])
    }
    
    public enum CustomerListAction: Codable, Equatable {
        case teamSelected(Int?)
        case tapped(Int)
        case editTapped(KimaiCustomer)
        case saveTapped(KimaiCustomer)
    }
    
    public enum AssistantAction: Codable, Equatable {
        case stepTapped
        case dashboardTapped
    }
    
    public enum ProjectListAction: Codable, Equatable {
        case projectTapped(Int)
        case projectEditTapped(KimaiProject)
    }
    
    public enum ProjectSheetAction: Codable, Equatable {
        case saveTapped(KimaiProject)
    }
    
    public enum ProjectDetailAction: Codable, Equatable {
        case deleteTapped(KimaiTimesheet)
        case editTapped(KimaiTimesheet)
    }
    
    public enum TimesheetSheetAction: Codable, Equatable {
        case saveTapped(KimaiTimesheet)
    }
}



