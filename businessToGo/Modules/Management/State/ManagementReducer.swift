import Combine
import Redux

extension ManagementModule: Reducer {
    static func reduce(_ state: inout State, _ action: Action, _ env: Dependency) -> AnyPublisher<Action, Error>  {
        switch(action){
        case .route(let action):
            return RouteModule.reduce(&state.router, action, .init())
                .map { .route($0) }
                .eraseToAnyPublisher()
            
        case .sync:
            state.integrations = env.integrations.get()
            
            return Publishers.Merge(
                just(.kimai(.sync)),
                just(.taiga(.sync))
            ).eraseToAnyPublisher()
        
        
        case .connect(let kimaiProject, let taigaProject):
            env.integrations.setIntegration(kimaiProject, taigaProject)
            state.integrations = env.integrations.get()
            
        case .kimai(let action):
            return KimaiModule.reduce(&state.kimai, action, KimaiModule.Dependency(kimai: env.kimai, track: env.track))
                .map { .kimai($0) }
                .eraseToAnyPublisher()
            
        case .taiga(let action):
            return TaigaModule.reduce(&state.taiga, action, TaigaModule.Dependency(taiga: env.taiga, track: env.track))
                .map { Action.taiga($0) }
                .eraseToAnyPublisher()
            
        case .resetDatabase:
            env.reset()
            state = .init()
        }
        
        return Empty().eraseToAnyPublisher()
    }
}
