import Foundation
import Redux
import Combine

public extension ReportFeature {
    func reduce(_ state: inout State, _ action: Action) -> AnyPublisher<Action, Error> {
        switch(action) {
            
        case .onAppear:
            state.timesheets = kimai.timesheets.get()
            state.timesheetChanges = track.getChanges(kimai.timesheets.getName()) ?? []
            state.projects = kimai.projects.get()
            state.activities = kimai.activities.get()
            state.customers = kimai.customers.get()
            
        case let .dateSelected(date):
            state.selectedDate = date
        case let .projectSelected(project):
            state.selectedProject = project
            
        case let .reports(action):
            switch(action) {
            case .calendarTapped:
                state.router.presentSheet(.calendar)
            case .filterTapped:
                state.router.presentSheet(.filter)
            case .playTapped:
                return .none
            case let .deleteTapped(timesheet):
                return .none
            }
            
        case let .calendar(action):
            switch(action) {
            case .lastYearTapped:
                var dateComponent = DateComponents()
                dateComponent.year = -1
                state.selectedDate = Calendar.current.date(byAdding: dateComponent, to: state.selectedDate)!
            case .nextYearTapped:
                var dateComponent = DateComponents()
                dateComponent.year = +1
                state.selectedDate = Calendar.current.date(byAdding: dateComponent, to: state.selectedDate)!
            case let .monthTapped(month):
                var dateComponent = DateComponents()
                dateComponent.day = 1
                dateComponent.month =  state.months.firstIndex(of: month)! + 1
                dateComponent.year = Int(state.selectedDate.year())
                state.selectedDate = Calendar.current.date(from: dateComponent)!
            }
        
        case let .filter(action):
            switch(action) {
            case .projectsTapped:
                state.router.push(.filterProjects)
            }
            
       
        case let .filterProjects(action):
            switch(action) {
            case .allProjectsTapped:
                state.selectedProject = nil
                state.router.dismiss()
            case let .projectTapped(project):
                state.selectedProject = project
                state.router.dismiss()
            }
        
        case let .router(action):
            return RouterFeature<Route>().reduce(&state.router, action)
                .map { .router($0) }
                .eraseToAnyPublisher()
        }
        
        return .none
    }
}
