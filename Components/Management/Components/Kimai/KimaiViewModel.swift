import Foundation
import Redux

import KimaiCore

extension KimaiContainer: ViewModel {
    typealias DState = ManagementContainer.State
    typealias DAction = ManagementContainer.Action
    
    struct State: ViewState {
        public var selectedTeam: Int?
        
        public var customers: [KimaiCustomer]
        public var projects: [KimaiProject]
        public var timesheets: [KimaiTimesheet]
        public var activities: [KimaiActivity]
        public var teams: [KimaiTeam]
        public var users: [KimaiUser]
        
        public var currentStep: KimaiAssistantStep? {
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
        
        public var steps: [KimaiAssistantStep] = KimaiAssistantStep.allCases
        
        public func title(_ route: Route) -> String {
            switch(route) {
            case .customersList:
                return "Kunden"
            case let .customerSheet(customer):
                return customer.name
            case let .projectsList(customerId):
                return customers.first(where: { $0.id == customerId })?.name ?? "--"
            case let .projectSheet(project):
                return project.name
            case let .projectDetail(id):
                if let project = projects.first(where: {$0.id == id}) {
                    return project.name
                } else {
                    return "\(id)"
                }
            case .timesheetSheet(_):
                return "Timesheet"
            }
        }
        
        static func from(_ state: ManagementContainer.State) -> Self {
            return State(
                selectedTeam: state.kimai.selectedTeam,
                customers: state.kimai.customers,
                projects: state.kimai.projects,
                timesheets: state.kimai.timesheets,
                activities: state.kimai.activities,
                teams: state.kimai.teams,
                users: state.kimai.users
            )
            
        }
    }
    
    enum Action: ViewAction {
        case customer(CustomerAction)
        case project(ProjectAction)
        case timesheet(TimesheetAction)
        
        var lifted: ManagementContainer.Action {
            switch self {
            case let .customer(action):
                switch(action) {
                case let .teamSelected(team): return .kimai(.teamSelected(team))
                case let .tapped(id): return .kimai(.customerTapped(id))
                case let .editTapped(customer): return .kimai(.customerEditTapped(customer))
                case let .saveTapped(customer): return .kimai(.customerSaveTapped(customer))
                }
            case let .project(action):
                switch(action) {
                case let .tapped(id):  return .kimai(.projectTapped(id))
                case let .editTapped(project): return .kimai(.projectEditTapped(project))
                case let .saveTapped(project): return .kimai(.projectSaveTapped(project))
                }
            case let .timesheet(action):
                switch(action){
                case let .deleteTapped(timesheet): return .kimai(.timesheetDeleteTapped(timesheet))
                case let .editTapped(timesheet): return .kimai(.timesheetEditTapped(timesheet))
                case let .saveTapped(timesheet): return .kimai(.timesheetSaveTapped(timesheet))
                }
            }
        }
    }

    
    enum CustomerAction: Codable, Equatable {
        case teamSelected(Int?)
        case tapped(Int)
        case editTapped(KimaiCustomer)
        case saveTapped(KimaiCustomer)
    }
    
    enum ProjectAction: Codable, Equatable {
        case tapped(Int)
        case editTapped(KimaiProject)
        case saveTapped(KimaiProject)
    }

    
    enum TimesheetAction: Codable, Equatable {
        case deleteTapped(KimaiTimesheet)
        case editTapped(KimaiTimesheet)
        case saveTapped(KimaiTimesheet)
    }
    
    enum UIAction: Codable, Equatable {
        case teamSelected(Int?)
        case customerTapped(Int)
        case customerEditTapped(KimaiCustomer)
        case customerSaveTapped(KimaiCustomer)
        
        case projectTapped(Int)
        case projectEditTapped(KimaiProject)
        case projectSaveTapped(KimaiProject)
        
        case timesheetDeleteTapped(KimaiTimesheet)
        case timesheetEditTapped(KimaiTimesheet)
        case timesheetSaveTapped(KimaiTimesheet)
    }

    enum Route: Codable, Equatable, Hashable {
        case customersList
        case customerSheet(KimaiCustomer)
        
        case projectsList(for: Int)
        case projectSheet(KimaiProject)
        case projectDetail(Int)
        
        case timesheetSheet(KimaiTimesheet)
        
        var title: String {
            switch self {
            case .customersList: return "Customers"
            case let .customerSheet(customer): return customer.name
            case .projectsList(_): return "Projects"
            case let .projectSheet(project): return project.name
            case .projectDetail(_): return "Project"
            case .timesheetSheet(_): return "Timesheet"
            }
        }
    }
    
}
