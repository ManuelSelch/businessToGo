import SwiftUI
import ComposableArchitecture

struct TaigaCoordinatorView: View {
    let store: StoreOf<TaigaCoordinator>
    
    var body: some View {
        switch(store.state) {
        case .project:
            if let store = store.scope(state: \.project, action: \.project) {
                TaigaProjectView(store: store)
            }
        }
    }
}
