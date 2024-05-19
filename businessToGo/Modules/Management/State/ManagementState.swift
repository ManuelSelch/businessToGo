import OfflineSync
import SwiftUI
import Redux

struct ManagementState: Equatable, Codable {
    var routes: [ManagementRoute]
    var sheet: ManagementRoute?
    
    var kimai: KimaiState
    var taiga: TaigaState
    var integrations: [Integration]

    init(){
        routes = []
        kimai = KimaiState()
        taiga = TaigaState()
        integrations = []
    }
}

enum ManagementRoute: Equatable, Hashable, Codable, Identifiable {
    case kimai(KimaiRoute)
    case taiga(TaigaScreen)
    
    var id: Self {self}
}

extension ManagementRoute {
    func createView(_ store: Store<ManagementState, ManagementAction, ManagementDependency>) -> some View {
        switch self {
        case .kimai(let route):
            return AnyView(
                KimaiContainer(
                    store: store.lift(\.kimai, ManagementAction.kimai, store.dependencies),
                    route: route,
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
            return AnyView( VStack {} )
        }
    }
}
