import Foundation
import Combine

typealias Reducer<State, Action> = (inout State, Action) -> AnyPublisher<Action, Error>?

class Store<State, Action>: ObservableObject {
    @Published private(set) var state: State

    private let reducer: Reducer<State, Action>
    private var cancellables: Set<AnyCancellable> = []

    init(initialState: State, reducer: @escaping Reducer<State, Action>) {
        self.state = initialState
        self.reducer = reducer
    }

    func send(_ action: Action) {
        handleLog(action)
        
        guard let effect = reducer(&state, action) else {
            return
        }
 
        effect
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let e):
                        self.handleError(e)
                
                }
            }, receiveValue: send)
            .store(in: &cancellables)
    }
    
    
    func lift<DerivedState: Equatable, ExtractedAction>(
        _ deriveState: @escaping (State) -> DerivedState,
        _ embedAction: @escaping (ExtractedAction) -> Action
    ) -> Store<DerivedState, ExtractedAction> {
        
        let derivedStore = Store<DerivedState, ExtractedAction>(
            initialState: deriveState(state),
            reducer: { derivedState, action  in
                self.send(embedAction(action))
                return Empty().eraseToAnyPublisher()
            }
        )
        
        $state
            .map(deriveState)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: &derivedStore.$state)
        
        return derivedStore
    }
    
    func handleError(_ error: Error) {
        LogService.log("\(error)")
    }
    
    func handleLog(_ action: Action) {
        // LogService.log("\(action)")
    }
}

class AppStore: Store<AppState, AppAction> {
    override func handleError(_ error: Error) {
        LogService.log("\(error)")
        
        self.send(.log(.error("\(error)")))
    }
    
    override func handleLog(_ action: AppAction){
        let actionStr = "\(action)"
        
        let methods = actionStr.split(separator: "(")
        var methodsFormatted: [String] = []
        for method in methods {
            if(
                method.contains(":") ||
                method.contains("\"") ||
                method.contains("-") ||
                method.contains("[") ||
                method.contains("]")
            ){
                continue // only show action but no data
            }
            
            if let methodFormatted = method.split(separator: ".").last {
                let strMethodFormatted = String(methodFormatted).replacing(")",with: "")
                if(
                    strMethodFormatted.split(separator: " ").count == 1
                ){
                    methodsFormatted.append(strMethodFormatted)
                }
            }
        
        }
        
        var actionFormatted = ""
        for method in methodsFormatted {
            actionFormatted += "." + method
        }
        
        LogService.log(actionFormatted)
    }
}


