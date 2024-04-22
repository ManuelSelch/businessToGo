import Combine

struct RequestReducer {
    static func reduce<Model, Target>(
        _ action: RequestAction<Model>,
        _ service: IRequestService<Model, Target>
    ) -> AnyPublisher<RequestAction<Model>, Error> {
        switch(action){
        case .fetch:
            return service.fetch()
                .map { .sync($0) }
                .eraseToAnyPublisher()
            
        case .sync(let value):
            return service.sync(value)
                .map { .hasSynced($0) }
                .eraseToAnyPublisher()
        
        case .hasSynced(let change):
            service.hasSynced(change)
        }
        return Empty().eraseToAnyPublisher()
    }
}
