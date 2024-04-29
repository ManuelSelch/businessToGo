import Combine

extension ManagementState {
    static func reduce(_ state: inout ManagementState, _ action: ManagementAction, _ env: ManagementDependency) -> AnyPublisher<ManagementAction, Error>  {
        switch(action){
        case .sync:
            state.integrations = env.integrations.get()
            
            return Publishers.Merge(
                env.just(.kimai(.sync)), 
                env.just(.taiga(.sync))
            ).eraseToAnyPublisher()
            
        case .kimai(let action):
            return KimaiState.reduce(&state.kimai, action, env)
                .map { .kimai($0) }
                .eraseToAnyPublisher()
            
        case .taiga(let action):
            return TaigaState.reduce(&state.taiga, action, env)
                .map { .taiga($0) }
                .eraseToAnyPublisher()
        }
    }
}
