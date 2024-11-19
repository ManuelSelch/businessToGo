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
        case filter(FilterAction)
        case filterProjects(FilterProjectsAction)
        
        var lifted: AppFeature.Action {
            switch self {
            case let .dateSelected(date): return .report(.dateSelected(date))
            case let .projectSelected(project): return .report(.projectSelected(project))
            case let .reportTypeSelected(reportType): return .report(.reportTypeSelected(reportType))
                
            case let .reports(action):
                switch(action){
                case .calendarTapped: return .component(.report(.calendarTapped))
                case .filterTapped: return .component(.report(.filterTapped))
                case .playTapped: return .component(.report(.playTapped))
                case let .editTapped(timesheet): return .component(.report(.editTimesheetTapped(timesheet)))
                case let .deleteTapped(timesheet): return .kimai(.timesheet(.delete(timesheet)))
                }
            case let .calendar(action):
                switch(action){
                case .previousYearTapped: return .report(.previousYearTapped)
                case .nextYearTapped: return .report(.nextYearTapped)
                case let .monthTapped(month): return .report(.monthTapped(month))
                }
            case let .filter(action):
                switch(action){
                case .projectsTapped: return .component(.report(.filterProjectsTapped))
                }
            case let .filterProjects(action):
                switch(action){
                case .allProjectsTapped: return .component(.report(.filterProjectTapped(nil)))
                case let .projectTapped(project): return .component(.report(.filterProjectTapped(project)))
                }
            }
        }
        
    }
    
    enum ReportsAction: Codable, Equatable {
        case calendarTapped
        case filterTapped
        case playTapped
        
        case editTapped(KimaiTimesheet)
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
        case allProjectsTapped
        case projectTapped(Int)
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
