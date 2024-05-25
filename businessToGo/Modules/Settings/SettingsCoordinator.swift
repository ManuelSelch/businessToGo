import Foundation
import ComposableArchitecture
import Redux
import Combine
import TCACoordinators


@Reducer(state: .equatable)
enum SettingsRoute {
    case settings(SettingsFeature)
    case integrations(IntegrationsFeature)
    case debug(DebugFeature)
    case log
}

@Reducer
struct SettingsCoordinator {
    struct State: Equatable {
        @Shared var current: Account?
        @Shared var kimai: KimaiModule.State
        @Shared var taiga: TaigaModule.State
        @Shared var integrations: [Integration]
        
        var routes: [Route<SettingsRoute.State>] = []
    }
    
    enum Action {
        case router(IndexedRouterActionOf<SettingsRoute>)
        case delegate(Delegate)
    }
    
    enum Delegate {
        case showIntro
        case logout
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch(action){
            case let .router(.routeAction(_, action: .settings(.delegate(delegate)))):
                switch(delegate){
                case .showDebug:
                    state.routes.push(
                        .debug(.init(
                            current: state.$current,
                            kimai: state.$kimai,
                            taiga: state.$taiga,
                            integrations: state.$integrations
                        ))
                    )
                    return .none
                case .showIntegrations:
                    state.routes.push(
                        .integrations(.init(
                            customers: state.$kimai.customers.records,
                            projects: state.$kimai.projects.records,
                            taigaProjects: state.$taiga.projects.records,
                            integrations: state.$integrations)
                        )
                    )
                    return .none
                case .showIntro:
                    return .send(.delegate(.showIntro))
                case .logout:
                    return .send(.delegate(.logout))
                }
            case .router, .delegate:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
    
   
}
