import Foundation
import ComposableArchitecture

@Reducer(state: .equatable)
enum KimaiCoordinator {
    case customers(KimaiCustomersFeature)
    case customer(KimaiCustomerFeature)
    
    case projects(KimaiProjectsFeature)
    
    init() {
        self = .customers(.init())
    }
}

