import Foundation
import Redux

import KimaiCore
import OfflineSyncCore 

struct KimaiComponent: ViewModel {
    typealias DState = AppFeature.State
    typealias DAction = AppFeature.Action
    
    struct State: ViewState {
        var selectedTeam: Int?
        
        var customers: [KimaiCustomer]
        var projects: [KimaiProject] 
        var timesheets: [KimaiTimesheet]
        var activities: [KimaiActivity]
        var teams: [KimaiTeam]
        var users: [KimaiUser]
        
        var customerChanges: [DatabaseChange]
        
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
        
        static func from(_ state: AppFeature.State) -> Self {
            return State(
                selectedTeam: state.kimai.selectedTeam,
                
                customers: state.kimai.customers,
                projects: state.kimai.projects,
                timesheets: state.kimai.timesheets,
                activities: state.kimai.activities,
                teams: state.kimai.teams,
                users: state.kimai.users,
                
                customerChanges: state.kimai.customerChanges
            )
            
        }
    }
    
    enum Action: ViewAction {
        case customer(CustomerAction)
        case project(ProjectAction)
        case activity(ActivityAction)
        case timesheet(TimesheetAction)
        
        case popupCloseTapped
        
        var lifted: AppFeature.Action {
            switch self {
            case let .customer(action):
                switch(action) {
                case let .saveTapped(customer): return .kimai(.customer(.save(customer)))
                case let .created(customer): return .kimai(.customer(.save(customer)))
                case let .deleteTapped(customer): return .kimai(.customer(.delete(customer)))
                case let .deleteConfirmed(customer): return .kimai(.customer(.deleteConfirmed(customer)))
                }
            case let .project(action):
                switch(action) {
                case let .saveTapped(project): return .kimai(.project(.save(project)))
                case let .created(project): return .kimai(.project(.save(project)))
                case let .deleteTapped(project): return .kimai(.project(.delete(project)))
                case let .deleteConfirmed(project): return .kimai(.project(.deleteConfirmed(project)))
                }
            case let .activity(action):
                switch(action){
                case let .saveTapped(activity): return .kimai(.activity(.save(activity)))
                case let .created(activity): return .kimai(.activity(.save(activity)))
                case let .deleteTapped(activity): return .kimai(.activity(.delete(activity)))
                case let .deleteConfirmed(activity): return .kimai(.activity(.deleteConfirmed(activity)))
                }
            case let .timesheet(action):
                switch(action){
                case let .saveTapped(timesheet): return .kimai(.timesheet(.save(timesheet)))
                case let .deleteTapped(timesheet): return .kimai(.timesheet(.delete(timesheet)))
                case let .deleteConfirmed(timesheet): return .kimai(.timesheet(.deleteConfirmed(timesheet)))
                }
                
            case .popupCloseTapped: return .popupCloseTapped
            }
        }
    }

    
    enum CustomerAction: Codable, Equatable {
        case deleteTapped(KimaiCustomer)
        case deleteConfirmed(KimaiCustomer)
        case saveTapped(KimaiCustomer)
        case created(KimaiCustomer)
    }
    
    enum ProjectAction: Codable, Equatable {
        case deleteTapped(KimaiProject)
        case deleteConfirmed(KimaiProject)
        case saveTapped(KimaiProject)
        case created(KimaiProject)
    }
    
    enum ActivityAction: Codable, Equatable {
        case deleteTapped(KimaiActivity)
        case deleteConfirmed(KimaiActivity)
        case saveTapped(KimaiActivity)
        case created(KimaiActivity)
    }

    
    enum TimesheetAction: Codable, Equatable {
        case deleteTapped(KimaiTimesheet)
        case deleteConfirmed(KimaiTimesheet)
        case saveTapped(KimaiTimesheet)
    }
    
    enum UIAction: Codable, Equatable {
        case customerTapped(Int)
        case customerEditTapped(KimaiCustomer)
        case customerSaveTapped(KimaiCustomer)
        
        case projectTapped(Int)
        case projectEditTapped(KimaiProject)
        case projectSaveTapped(KimaiProject)
        
        case activityEditTapped(KimaiActivity)
        case activitySaveTapped(KimaiActivity)
        
        case timesheetEditTapped(KimaiTimesheet)
        case timesheetSaveTapped(KimaiTimesheet)
    }

    enum Route: Codable, Equatable, Hashable {
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
