import SwiftUI
import Redux
import Router
import Dependencies

import CommonUI

struct AppContainer: View {
    @Dependency(\.router) var router
    @ObservedObject var store: StoreOf<AppFeature>
    
    init(store: StoreOf<AppFeature>) {
        self.store = store
        
        UIDatePicker.appearance().minuteInterval = 15
    }

    var body: some View {
        AppRouterView(
            router: router,
            header: {
                EmptyView()
            },
            content: { route in
                ZStack(alignment: .top)  {
                    Color.background.edgesIgnoringSafeArea(.all)
                    route.view(store)
                }
            },
            label: { tab in
                tab.label()
            }
        )
        .onAppear {
            store.send(.intro(.load))
        }
        .environmentObject(router)
    }
}
