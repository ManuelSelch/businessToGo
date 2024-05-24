import Foundation
import SwiftUI
import ComposableArchitecture

enum ManagementRoute: Equatable, Hashable, Codable, Identifiable {
    case kimai(KimaiRoute)
    case taiga(TaigaRoute)
    
    var id: Self {self}
}

extension ManagementRoute {
    func createView(_ store: StoreOf<ManagementModule>) -> some View {
        switch self {
        case .kimai(let route):
            return AnyView(
                route.createView(
                    store: store.scope(state: \.kimai, action: \.kimai),
                    router: { store.send(.route($0)) },
                    onProjectClicked: { kimaiProject in
                        if let integration = store.integrations.first(where: {$0.id == kimaiProject})
                        {
                            // show taiga project details
                            store.send(.route(.push(
                                .taiga(.project(integration))
                            )))
                        } else {
                            // fallback to kimai project details
                            store.send(.route(.push(
                                .kimai(.projectDetails(kimaiProject))
                            )))
                        }
                    }
                )
            )
        case .taiga(let route):
            return AnyView(
                route.createView(store.scope(state: \.taiga, action: \.taiga))
            )
        }
    }
}
