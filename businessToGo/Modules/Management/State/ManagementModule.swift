import Foundation
import Redux
import ComposableArchitecture
import Combine
import TCACoordinators

@Reducer
struct ManagementModule {
    @ObservableState
    struct State: Equatable, Codable {
        var router: RouteModule<ManagementRoute>.State = .init()
        
        var kimai: KimaiModule.State = .init()
        var taiga: TaigaModule.State = .init()
        var integrations: [Integration] = []
        
        var report: ReportModule.State = .init()
    }
    
    enum Action {
        case route(RouteModule<ManagementRoute>.Action)
        case sync
        case connect(_ kimaiProject: Int, _ taigaProject: Int)
        
        case kimai(KimaiModule.Action)
        case taiga(TaigaModule.Action)
        case report(ReportModule.Action)
        
        case resetDatabase
    }
    
    
    @Dependency(\.database) var database
    @Dependency(\.integrations) var integrations
    
    var body: some ReducerOf<Self> {
        
        Scope(state: \.report, action: \.report) {
            ReportModule()
        }
        Scope(state: \.kimai, action: \.kimai) {
            KimaiModule()
        }
        Scope(state: \.taiga, action: \.taiga) {
            TaigaModule()
        }
        
        Reduce { state, action in
            switch(action){
            case .route(let action):
                return .publisher {
                    RouteModule.reduce(&state.router, action, .init())
                        .map { .route($0) }
                        .catch { _ in Empty() }
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
                
            case .kimai, .taiga, .report:
                return .none
            }
        }
    }
}
