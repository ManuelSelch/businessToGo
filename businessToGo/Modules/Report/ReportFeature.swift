import Foundation
import Redux
import OfflineSync

struct ReportFeature: Reducer {
    @Dependency(\.kimai) var kimai
    @Dependency(\.track) var track
    
    struct State: Equatable, Codable {
        var selectedDate: Date = Date.today
        var selectedProject: Int?
        var months: [String] = Calendar.current.shortMonthSymbols
        
        var timesheets: [KimaiTimesheet] = []
        var timesheetChanges: [DatabaseChange] = []
        var projects: [KimaiProject] = []
        var activities: [KimaiActivity] = []
        var customers: [KimaiCustomer] = []
        
        var router: RouterFeature<Route>.State = .init(root: .reports)
    }
    
    enum Action: Codable {
        case router(RouterFeature<Route>.Action)
        
        case onAppear
        
        case dateSelected(Date)
        case projectSelected(Int?)
        
        case reports(ReportsAction)
        case calendar(CalendarAction)
        case filter(FilterAction)
        case filterProjects(FilterProjectsAction)
        
    }
    
    enum ReportsAction: Codable {
        case calendarTapped
        case filterTapped
        case playTapped
        case deleteTapped(KimaiTimesheet)
    }
    
    enum CalendarAction: Codable {
        case lastYearTapped
        case nextYearTapped
        case monthTapped(String)
    }
    
    enum FilterAction: Codable {
        case projectsTapped
    }
    
    enum FilterProjectsAction: Codable {
        case allProjectsTapped
        case projectTapped(Int)
    }
    
    enum Route: Identifiable, Hashable, Codable {
        case reports
        case calendar
        case filter
        case filterProjects
        
        var id: Self {self}
    }
}
