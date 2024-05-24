import Foundation
import ComposableArchitecture

@Reducer(state: .equatable)
enum KimaiCoordinator {
    case customers(KimaiCustomersFeature)
    case customer(KimaiCustomerFeature)
    
    init() {
        self = .customers(.init())
    }
}

