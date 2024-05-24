import Foundation
import Redux
import ComposableArchitecture
import Combine
import TCACoordinators


@Reducer(state: .equatable)
enum ManagementScreen {    
    case kimai(KimaiCoordinator)
}

@Reducer
struct ManagementCoordinator {
    @Dependency(\.database) var database
    @Dependency(\.integrations) var integrations
    
    @ObservableState
    struct State {
        var routes: [Route<ManagementScreen.State>] = []
        
        @Shared var kimai: KimaiModule.State
        @Shared var taiga: TaigaModule.State
        @Shared var integrations: [Integration]
        
        init(){
            self._kimai = Shared(.init())
            self._taiga = Shared(.init())
            self._integrations = Shared([])
            
            self.routes = [
                .cover(.kimai(.customersList(.init(customers: $kimai.customers))), embedInNavigationView: true)
            ]
        }
    }
    
    enum Action {
        case router(IndexedRouterActionOf<ManagementScreen>)
        
        case sync
        case connect(_ kimaiProject: Int, _ taigaProject: Int)
        
        case kimai(KimaiModule.Action)
        case taiga(TaigaModule.Action)
        case report(ReportModule.Action)
        
        case resetDatabase
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.kimai, action: \.kimai) {
            KimaiModule()
        }
        Scope(state: \.taiga, action: \.taiga) {
            TaigaModule()
        }
        
        Reduce { state, action in
            switch(action){
            
            // MARK: - Kimai Customers List
            case let .router(.routeAction(_, .kimai(.customersList(.delegate(delegate))))):
                switch(delegate) {
                case let .showProject(of: customer):
                    state.routes.push(
                        .kimai(.projectsList(.init(
                            customer: customer,
                            timesheets: state.$kimai.timesheets.records,
                            projects: state.$kimai.projects
                        )))
                    )
                    return .none
                case let .editCustomer(customer):
                    state.routes.presentSheet(
                        .kimai(.customerSheet(.init(customer: customer, teams: state.$kimai.teams.records)))
                    )
                    return .none
                }
                
            // MARK: - Kimai Customer Sheet
            case let .router(.routeAction(_, .kimai(.customerSheet(.delegate(delegate))))):
                switch(delegate) {
                case .dismiss:
                    state.routes.goBack()
                    return .none
                case let .update(customer):
                    return .send(.kimai(.customers(.update(customer))))
                case let .create(customer):
                    return .send(.kimai(.customers(.create(customer))))
                }
                
            // MARK: - Kimai Projects List
            case let .router(.routeAction(_, .kimai(.projectsList(.delegate(delegate))))):
                switch(delegate){
                case let .showProject(id):
                    if let project = state.kimai.projects.records.first(where: { $0.id == id }) {
                        state.routes.push(
                            .kimai(.projectDetail(.init(
                                project: project,
                                activities: state.$kimai.activities.records,
                                timesheets: state.$kimai.timesheets.records,
                                users: state.$kimai.users.records
                            )))
                        )
                    }
                    return .none
                case let .editProject(project):
                    state.routes.presentSheet(
                        .kimai(.projectSheet(.init(
                            project: project,
                            customers: state.$kimai.customers.records
                        )))
                    )
                    return .none
                }
                
            // MARK: - Kimai Project Sheet
            case let .router(.routeAction(_, .kimai(.projectSheet(.delegate(delegate))))):
                switch(delegate) {
                case .dismiss:
                    state.routes.goBack()
                    return .none
                case let .create(project):
                    return .send(.kimai(.projects(.create(project))))
                case let .update(project):
                    return .send(.kimai(.projects(.update(project))))
                }
            
            // MARK: - Kimai Timesheets List
            case let .router(.routeAction(_, .kimai(.timesheetsList(.delegate(delegate))))):
                switch(delegate){
                case let .delete(timesheet):
                    return .send(.kimai(.timesheets(.delete(timesheet))))
                case let .edit(timesheet):
                    state.routes.presentSheet(
                        .kimai(.timesheetSheet(.init(
                            timesheet: timesheet,
                            customers: state.$kimai.customers.records,
                            projects: state.$kimai.projects.records,
                            activities: state.$kimai.activities.records
                        )))
                    )
                    return .none
                }
            
                
            case .sync:
                state.integrations = integrations.get()
                return .publisher {
                    return Publishers.Merge(
                        Just(.kimai(.sync)),
                        Just(.taiga(.sync))
                    )
                }
            
            
            case .connect(let kimaiProject, let taigaProject):
                integrations.setIntegration(kimaiProject, taigaProject)
                state.integrations = integrations.get()
                return .none
                
                
            case .resetDatabase:
                database.reset()
                state = .init()
                return .none
                
            case .kimai, .taiga, .report, .router:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}



