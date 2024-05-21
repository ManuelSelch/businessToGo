import SwiftUI
import Redux

struct SettingsContainer: View {
    @ObservedObject var store: StoreOf<AppModule>
    
    @State var projectView: KimaiProject?

    var body: some View {
        NavigationStack(
            path:  Binding(
                get: { store.state.settings.router.routes },
                set: { store.send(.settings(.route(.set($0)))) }
            )
        ){
            SettingsRoute.settings.createView(store)
            
                .navigationDestination(for: SettingsRoute.self){ route in
                    route.createView(store)
                }
        }
        .tint(Color.theme)
        .sheet(item: Binding(
            get: { store.state.settings.router.sheet },
            set: {
                if let sheet = $0 {
                    store.send(.settings(.route(.presentSheet(sheet))))
                } else {
                    store.send(.settings(.route(.dismissSheet)))
                }
            }
        )) { route in
            
        }
    }
}
