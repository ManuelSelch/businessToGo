import Foundation
import SwiftUI
import ComposableArchitecture
import Redux

enum KimaiRoute: Equatable, Hashable, Codable {
    case customers
    case customer(KimaiCustomer)
    
    case projects(for: Int)
    case project(KimaiProject)
    case projectDetails(Int)
    
    case timesheet(KimaiTimesheet)
}


extension KimaiRoute {

    @ViewBuilder func createView(
        store: ComposableArchitecture.StoreOf<KimaiModule>,
        router: @escaping (RouteModule<ManagementRoute>.Action) -> (),
        onProjectClicked: @escaping (Int) -> ()
    ) -> some View {
        switch self {
        case .customers:
            EmptyView()
        case .customer(let customer):
            EmptyView()
            
        case .projects(for: let id):
            EmptyView()
            
        case .project(let project):
            EmptyView()
        
        case .projectDetails(let id):
            EmptyView()
            
        case .timesheet(let timesheet):
            EmptyView()
        }
    }
}
