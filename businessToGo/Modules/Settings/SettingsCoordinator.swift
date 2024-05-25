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
    case log(LogFeature)
}

@Reducer
struct SettingsCoordinator {
    @Dependency(\.database) var database
    
    struct State: Equatable {
        @Shared var current: Account?
        @Shared var kimai: KimaiModule.State
        @Shared var taiga: TaigaModule.State
        @Shared var integrations: [Integration]
        
        var routes: [Route<SettingsRoute.State>] = [
            .cover(.settings(.init()), embedInNavigationView: true)
        ]
    }
    
    enum Action {
        case router(IndexedRouterActionOf<SettingsRoute>)
        case delegate(Delegate)
    }
    
    enum Delegate {
        case showIntro
        case logout
        case dismiss
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
                case .showLog:
                    state.routes.push(
                        .log(.init())
                    )
                    return .none
                case .showIntro:
                    return .send(.delegate(.showIntro))
                case .logout:
                    return .run { send in
                        await send(.delegate(.logout))
                        await send(.delegate(.dismiss))
                    }
                }
            case let .router(.routeAction(_, action: .debug(.delegate(delegate)))):
                switch(delegate){
                case .reset:
                    database.reset()
                    return .run { send in
                        await send(.delegate(.logout))
                        await send(.delegate(.dismiss))
                    }
                }
                
            case .router, .delegate:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
    
   
}
