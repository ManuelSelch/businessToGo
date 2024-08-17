import SwiftUI
import Redux
import PopupView

struct AppContainer: View {
    @ObservedObject var store: StoreOf<AppFeature>
    
    init(store: StoreOf<AppFeature>) {
        self.store = store
        
        UIDatePicker.appearance().minuteInterval = 15
    }

    var body: some View {
        AppRouterView(
            store: store.lift(\.router, AppFeature.Action.router),
            header: {
                EmptyView()
                /*
                AppHeader(
                    title: store.state.title,
                    settingsTapped: { store.send(.settingsTapped) }
                )
                 */
                
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
