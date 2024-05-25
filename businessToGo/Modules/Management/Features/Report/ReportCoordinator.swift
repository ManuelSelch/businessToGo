import Foundation
import ComposableArchitecture
import TCACoordinators

@Reducer(state: .equatable)
enum ReportRoute {
    case reports(ReportsFeature)
    case calendar(ReportCalendarFeature)
}

/*
 case timesheet(KimaiTimesheet)
 
 case filter
 case filterProjects
 */

@Reducer
struct ReportCoordinator {
    struct State {
        @Shared var selectedDate: Date
        
        @Shared var timesheets: RequestModule<KimaiTimesheet, KimaiRequest>.State
        @Shared var projects: [KimaiProject]
        @Shared var activities: [KimaiActivity]
        
        var routes: [Route<ReportRoute.State>] = []
        
        init(timesheets: Shared<RequestModule<KimaiTimesheet, KimaiRequest>.State>, projects: Shared<[KimaiProject]>, activities: Shared<[KimaiActivity]>) {
            self._selectedDate = Shared(Date.today)
            self._timesheets = timesheets
            self._projects = projects
            self._activities = activities
            
            self.routes = [
                .cover(
                    .reports(.init(
                        selectedDate: $selectedDate,
                        timesheets: $timesheets,
                        projects: $projects,
                        activities: $activities
                    )),
                    embedInNavigationView: true
                )
            ]
        }
    }
    
    enum Action {
        case router(IndexedRouterActionOf<ReportRoute>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch(action) {
            case let .router(.routeAction(_, .reports(.delegate(delegate)))):
                switch(delegate) {
                case .showCalendar:
                    state.routes.push(
                        .calendar(.init(selectedDate: state.$selectedDate))
                    )
                    return .none
                case .showFilter:
                    return .none
                case .editTimesheet(_):
                    return .none
                case .deleteTimesheet(_):
                    return .none
                }
            case .router:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
