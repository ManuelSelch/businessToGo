import Combine
import OfflineSync

struct RequestReducer {
    static func reduce<Model, Target>(
        _ action: RequestAction<Model>,
        _ service: RequestService<Model, Target>,
        _ track: TrackTable,
        _ state: inout [Model],
        _ changes: inout [DatabaseChange]
    ) -> AnyPublisher<RequestAction<Model>, Error> {
        switch(action){
        case .sync:
            return Future<RequestAction<Model>, Error> { promise in
                Task {
                    do {
                        let fetch = try await service.fetch(1)
                        var remoteRecords = fetch.response
                        var current = Int(fetch.headers["X-Page"] as? String ?? "0") ?? 0
                        let max = Int(fetch.headers["X-Total-Pages"] as? String ?? "0") ?? 0
                        while(current < max){
                            current += 1
                            let fetchPage = try await service.fetch(current)
                            remoteRecords.append(contentsOf: fetchPage.response)
                        }
                        
                        let records = try await service.sync(remoteRecords)
                        promise(.success(.set(records)))
                    } catch {
                        promise(.failure(ServiceError.unknown("\(error)")))
                    }
                }
            }
            .eraseToAnyPublisher()
            
        case .set(let records):
            state = records
            changes = track.getAll(state, service.getName())
            
        case .create(let item):
            service.create(item)
            state = service.get()
            changes = track.getAll(state, service.getName())
        
            
        case .update(let item):
            service.update(item)
            if let index = state.firstIndex(where: { $0.id == item.id }) {
                state[index] = item
            }
            changes = track.getAll(state, service.getName())
        
        case .delete(let item):
            service.delete(item)
            if let index = state.firstIndex(where: { $0.id == item.id }) {
                state.remove(at: index)
            }
        }
        return Empty().eraseToAnyPublisher()
    }
}
