import Foundation
import Redux
import OfflineSync
import Dependencies

import KimaiCore
import KimaiServices

public struct ReportFeature: Reducer {
    @Dependency(\.kimai) var kimai
    @Dependency(\.track) var track
    
    public init() {}
    
    public struct State: Equatable, Codable {
        public init() {}
        
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
    
    public enum Action: Codable, Equatable {
        case router(RouterFeature<Route>.Action)
        
        case onAppear
        
        case dateSelected(Date)
        case projectSelected(Int?)
        
        case reports(ReportsAction)
        case calendar(CalendarAction)
        case filter(FilterAction)
        case filterProjects(FilterProjectsAction)
        
    }
    
    public enum ReportsAction: Codable, Equatable {
        case calendarTapped
        case filterTapped
        case playTapped
        case deleteTapped(KimaiTimesheet)
    }
    
    public enum CalendarAction: Codable, Equatable {
        case lastYearTapped
        case nextYearTapped
        case monthTapped(String)
    }
    
    public enum FilterAction: Codable, Equatable {
        case projectsTapped
    }
    
    public enum FilterProjectsAction: Codable, Equatable {
        case allProjectsTapped
        case projectTapped(Int)
    }
    
    public enum Route: Identifiable, Hashable, Codable {
        case reports
        case calendar
        case filter
        case filterProjects
        
        public var id: Self {self}
    }
}
