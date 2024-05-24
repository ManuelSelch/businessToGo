import SwiftUI
import ComposableArchitecture

struct ReportContainer: View {
    let store: StoreOf<ManagementModule>
    
    var body: some View {
        NavigationStack(path: Binding(get: { store.report.router.routes }, set: { store.send(.report(.route(.set($0)))) })) {
            ReportRoute.reports.createView(store)
                .navigationDestination(for: ReportRoute.self) { route in
                    route.createView(store)
                }
            
        }
        .transition(.slide)
        .sheet(item: Binding(
            get: { store.report.router.sheet },
            set: {
                if let route = $0 {
                    store.send(.report(.route(.presentSheet(route))))
                } else {
                    store.send(.report(.route(.dismissSheet)))
                }
            }
        )) { route in
            NavigationStack {
                route.createView(store)
            }
            .presentationDetents([.medium])
        }

        
    }
    
    
}
