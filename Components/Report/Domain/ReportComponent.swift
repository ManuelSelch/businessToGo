import Foundation
import Redux
import OfflineSyncCore
import Dependencies
 
import KimaiCore
import KimaiServices

struct ReportComponent: ViewModel {
    typealias DState = AppFeature.State
    typealias DAction = AppFeature.Action
    
    struct State: ViewState {
        var months: [String]
        
        var selectedDate: Date
        var selectedProject: Int?
        var selectedReportType: ReportType
        
        var timesheets: [KimaiTimesheet]
        var projects: [KimaiProject]
        var activities: [KimaiActivity]
        var customers: [KimaiCustomer]
        
        public static func from(_ state: AppFeature.State) -> Self {
            return State(
                months: state.report.months,
                selectedDate: state.report.selectedDate,
                selectedProject: state.report.selectedProject,
                selectedReportType: state.report.selectedReportType,
                
                timesheets: state.kimai.timesheets,
                projects: state.kimai.projects,
                activities: state.kimai.activities,
                customers: state.kimai.customers
            )
        }
    }
    
    enum Action: ViewAction {
        case dateSelected(Date)
        case projectSelected(Int?)
        case reportTypeSelected(ReportType)
        case reports(ReportsAction)
        case calendar(CalendarAction)
        case filterProjects(FilterProjectsAction)
        
        var lifted: AppFeature.Action {
            switch self {
            case let .dateSelected(date): return .report(.dateSelected(date))
            case let .projectSelected(project): return .report(.projectSelected(project))
            case let .reportTypeSelected(reportType): return .report(.reportTypeSelected(reportType))
            case let .reports(action):
                switch(action) {
                case let .deleteTapped(timesheet):
                    return .kimai(.timesheet(.delete(timesheet)))
                }
                
            case let .calendar(action):
                switch(action){
                case .previousYearTapped: return .report(.previousYearTapped)
                case .nextYearTapped: return .report(.nextYearTapped)
                case let .monthTapped(month): return .report(.monthTapped(month))
                }
           
            case let .filterProjects(action):
                switch(action){
                case let .projectTapped(project):
                    return .report(.projectSelected(project))
                case .allProjectsTapped:
                    return .report(.projectSelected(nil))
                }
            }
        }
    }
    
    
    enum ReportsAction: Codable, Equatable {
        case deleteTapped(KimaiTimesheet)
    }
    
    enum CalendarAction: Codable, Equatable {
        case previousYearTapped
        case nextYearTapped
        case monthTapped(String)
    }
    
    enum FilterAction: Codable, Equatable {
        case projectsTapped
    }
    
    enum FilterProjectsAction: Codable, Equatable {
        case projectTapped(Int)
        case allProjectsTapped
    }
    
    enum UIAction: Codable, Equatable {
        case calendarTapped
        case filterTapped
        case filterProjectsTapped
        case filterProjectTapped(Int?)
        
        case playTapped
        case editTimesheetTapped(KimaiTimesheet)
    }
    
    enum Route: Identifiable, Hashable, Codable {
        case reports
        case calendar
        case filter
        case filterProjects
        
        public var id: Self {self}
    }
}
