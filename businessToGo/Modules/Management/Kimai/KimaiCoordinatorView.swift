import SwiftUI
import ComposableArchitecture

struct KimaiCoordinatorView: View {
    let store: StoreOf<KimaiCoordinator>
    
    var body: some View {
        switch(store.state){
        case .customers:
            if let store = store.scope(state: \.customers, action: \.customers) {
                KimaiCustomersView(store: store)
            }
        case .customer:
            if let store = store.scope(state: \.customer, action: \.customer) {
                KimaiCustomerSheet(store: store)
            }
            
        case .projects:
            if let store = store.scope(state: \.projects, action: \.projects) {
                KimaiProjectsView(store: store)
            }
        }
    }
}
