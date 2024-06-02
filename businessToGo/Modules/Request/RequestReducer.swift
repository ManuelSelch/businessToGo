import Combine
import OfflineSync
import Redux

extension RequestFeature {
    func reduce(into state: inout State, action: Action) -> AnyPublisher<Action, Error> {
        switch(action){
        case .sync:
            return .run { send in
                do {
                    let local = service.get()
                    send(.success(.set(local)))
                    
                    let fetch = try await service.fetch()
                    var remoteRecords = fetch.response
                    var current = Int(fetch.headers["X-Page"] as? String ?? "0") ?? 0
                    let max = Int(fetch.headers["X-Total-Pages"] as? String ?? "0") ?? 0
                    while(current < max){
                        current += 1
                        let fetchPage = try await service.fetch(page: current)
                        remoteRecords.append(contentsOf: fetchPage.response)
                    }
                    
                    let records = try await service.sync(remoteRecords)
                    send(.success(.set(records)))
                } catch {
                    
                }
            }
            
        case .set(let records):
            state.records = records
            state.changes = track.getAll(state.records, service.getName())
            
        case .create(let item):
            service.create(item)
            state.records = service.get()
            state.changes = track.getAll(state.records, service.getName())
        
            
        case .update(let item):
            service.update(item)
            if let index = state.records.firstIndex(where: { $0.id == item.id }) {
                state.records[index] = item
            }
            state.changes = track.getAll(state.records, service.getName())
        
        case .delete(let item):
            service.delete(item)
            if let index = state.records.firstIndex(where: { $0.id == item.id }) {
                state.records.remove(at: index)
            }
        }
        return .none
    }
}
