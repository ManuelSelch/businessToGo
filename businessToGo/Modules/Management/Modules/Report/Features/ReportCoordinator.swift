import Foundation
import ComposableArchitecture
import TCACoordinators

@Reducer(state: .equatable)
enum ReportRoute {
    case reports(ReportsFeature)
    case calendar(ReportCalendarFeature)
    case filter(ReportFilterFeature)
    case filterProjects(ReportFilterProjectsFeature)
}

/*
 case timesheet(KimaiTimesheet)
 */

@Reducer
struct ReportCoordinator {
    struct State {
        @Shared var selectedDate: Date
        @Shared var selectedProject: Int?
        
        @Shared var timesheets: RequestModule<KimaiTimesheet, KimaiRequest>.State
        @Shared var projects: [KimaiProject]
        @Shared var activities: [KimaiActivity]
        @Shared var customers: [KimaiCustomer]
        
        var routes: [Route<ReportRoute.State>] = []
        
        init(
            timesheets: Shared<RequestModule<KimaiTimesheet, KimaiRequest>.State>,
            projects: Shared<[KimaiProject]>,
            activities: Shared<[KimaiActivity]>,
            customers: Shared<[KimaiCustomer]>
        ) {
            self._selectedDate = Shared(Date.today)
            self._selectedProject = Shared(nil)
            
            self._timesheets = timesheets
            self._projects = projects
            self._activities = activities
            self._customers = customers
            
            self.routes = [
                .root(
                    .reports(.init(
                        selectedDate: $selectedDate,
                        selectedProject: $selectedProject,
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
                    state.routes.presentSheet(
                        .calendar(.init(selectedDate: state.$selectedDate))
                    )
                    return .none
                case .showFilter:
                    state.routes.presentSheet(
                        .filter(.init(selectedProject: state.$selectedProject, customers: state.$customers, projects: state.$projects)), embedInNavigationView: true
                    )
                    return .none
                case .editTimesheet(_):
                    return .none
                case .deleteTimesheet(_):
                    return .none
                }
            
            case let .router(.routeAction(_, .filter(.delegate(delegate)))):
                switch(delegate) {
                case .showFilterProjects:
                    state.routes.push(
                        .filterProjects(.init(selectedProject: state.$selectedProject, customers: state.$customers, projects: state.$projects))
                    )
                    return .none
                }
            
            case let .router(.routeAction(_, .filterProjects(.delegate(delegate)))):
                switch(delegate) {
                case let .selectProject(project):
                    state.selectedProject = project
                    return .none
                case .dismiss:
                    state.routes.goBack()
                    return .none
                }
                
            
            case .router:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
