import Foundation
import ComposableArchitecture

@Reducer(state: .equatable)
enum TaigaCoordinator {
    case project(TaigaProjectFeature)
    
    init() {
        self = .project(.init())
    }
}
