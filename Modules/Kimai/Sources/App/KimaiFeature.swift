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
    
    public struct State: Equatable, Codable, Hashable {
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
        case sync 
        case synced(
            [KimaiCustomer], [KimaiProject], [KimaiActivity], [KimaiTeam], [KimaiUser], [KimaiTimesheet]
        )
        
        
        
        case customer(CustomerAction)
        case project(ProjectAction)
        case timesheet(TimesheetAction)
        
        case assistant(AssistantAction)
    }
    
    public enum CustomerAction: Codable, Equatable {
        case teamSelected(Int?)
        case save(KimaiCustomer)
    }

    public enum ProjectAction: Codable, Equatable {
        case save(KimaiProject)
    }
    
    
    public enum TimesheetAction: Codable, Equatable {
        case save(KimaiTimesheet)
        case delete(KimaiTimesheet)
    }
    
    public enum AssistantAction: Codable, Equatable {
        case stepTapped
        case dashboardTapped
    }
}



