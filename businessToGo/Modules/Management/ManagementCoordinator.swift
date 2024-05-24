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
                .cover(.kimai(.customers(.init(customers: $kimai.customers))), embedInNavigationView: true)
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
            
            case let .router(.routeAction(_, .kimai(.customers(.delegate(delegate))))):
                switch(delegate) {
                case let .showProject(of: customer):
                    state.routes.push(
                        .kimai(.projects(.init(customer: customer, timesheets: state.$kimai.timesheets.records, projects: state.$kimai.projects)))
                    )
                    return .none
                case let .editCustomer(customer):
                    state.routes.presentSheet(
                        .kimai(.customer(.init(customer: customer, teams: state.$kimai.teams.records)))
                    )
                    return .none
                }
            
            case let .router(.routeAction(_, .kimai(.customer(.delegate(delegate))))):
                switch(delegate) {
                case .dismiss:
                    state.routes.goBack()
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



