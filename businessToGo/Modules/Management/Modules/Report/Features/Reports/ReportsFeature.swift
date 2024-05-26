import Foundation
import ComposableArchitecture

@Reducer
struct ReportsFeature {
    @ObservableState
    struct State: Equatable {
        var selectedProject: Int?
        @Shared var selectedDate: Date
        
        @Shared var timesheets: RequestModule<KimaiTimesheet, KimaiRequest>.State
        @Shared(.inMemory("projects")) var projects: [KimaiProject] = []
        @Shared(.inMemory("activities")) var activities: [KimaiActivity] = []
        
        init(
            selectedDate: Shared<Date>,
            timesheets: Shared<RequestModule<KimaiTimesheet, KimaiRequest>.State>,
            projects: Shared<[KimaiProject]>,
            activities: Shared<[KimaiActivity]>
        
        ) {
            self._selectedDate = selectedDate
            
            self._timesheets = timesheets
            self._projects = projects
            self._activities = activities
        }
    }
    
    enum Action {
        case calendarTapped
        case filterTapped
        case playTapped
        
        case projectSelected(Int?)
        case dateSelected(Date)
        
        case deleteTapped(KimaiTimesheet)
    
        case delegate(Delegate)
    }
    
    enum Delegate {
        case showCalendar
        case showFilter
        case editTimesheet(KimaiTimesheet)
        case deleteTimesheet(KimaiTimesheet)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch(action){
            case .calendarTapped:
                return .send(.delegate(.showCalendar))
            case .filterTapped:
                return .send(.delegate(.showFilter))
            case .playTapped:
                return .send(.delegate(.editTimesheet(KimaiTimesheet.new)))
                
            case let .projectSelected(project):
                state.selectedProject = project
                return .none
            case let .dateSelected(date):
                state.selectedDate = date
                return .none
                
            case let .deleteTapped(timesheet):
                return .send(.delegate(.deleteTimesheet(timesheet)))
                
            case .delegate:
                return .none
            }
        }
    }
}
