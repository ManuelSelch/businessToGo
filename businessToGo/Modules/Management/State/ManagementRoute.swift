import Foundation
import Redux
import SwiftUI

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
                    store: store.lift(\.kimai, ManagementModule.Action.kimai, .init(kimai: store.dependencies.kimai, track: store.dependencies.track)),
                    router: { store.send(.route($0)) },
                    onProjectClicked: { kimaiProject in
                        if let integration = store.state.integrations.first(where: {$0.id == kimaiProject})
                        {
                            store.send(.route(.push(
                                .taiga(.project(integration))
                            )))
                        }
                    }
                )
            )
        case .taiga(let route):
            return AnyView(
                route.createView(store.lift(\.taiga, ManagementModule.Action.taiga, .init(taiga: store.dependencies.taiga, track: store.dependencies.track)))
            )
        }
    }
}
