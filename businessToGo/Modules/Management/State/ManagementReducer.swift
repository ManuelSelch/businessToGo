import Combine

extension ManagementState {
    static func reduce(_ state: inout ManagementState, _ action: ManagementAction) -> AnyPublisher<ManagementAction, Error>  {
        switch(action){
        case .kimai(let action):
            return KimaiState.reduce(&state.kimai, action)
                .map { .kimai($0) }
                .eraseToAnyPublisher()
            
        case .taiga(let action):
            return TaigaState.reduce(&state.taiga, action)
                .map { .taiga($0) }
                .eraseToAnyPublisher()
        }
    }
}
