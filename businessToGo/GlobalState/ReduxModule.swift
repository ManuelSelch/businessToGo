import Foundation
import Redux
import Combine

public typealias StoreOf<R: Reducer> = Store<R.State, R.Action, R.Dependency>

public protocol Reducer<State, Action, Dependency> {
    associatedtype State
    associatedtype Action
    associatedtype Dependency
    
    static func reduce(_ state: inout State, _ action: Action, _ env: Dependency) -> AnyPublisher<Action, Error>
}

extension Reducer {
    static func just<T>(_ event: T) -> AnyPublisher<T, Error> {
        return Just(event)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
