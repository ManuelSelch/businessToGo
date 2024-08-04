import SwiftUI
import Log
import Redux

struct AppContainer: View {
    @ObservedObject var store: StoreOf<AppFeature>

    var body: some View {
        AppRouterView(
            store: store.lift(\.router, AppFeature.Action.router),
            header: {
                AppHeader(
                    title: store.state.title,
                    settingsTapped: { store.send(.settingsTapped) }
                )
                
            },
            content: { route in
                route.view(store)
            },
            label: { tab in
                tab.label()
            }
        )
        .onAppear {
            store.send(.intro(.load))
        }
        
    }
}
