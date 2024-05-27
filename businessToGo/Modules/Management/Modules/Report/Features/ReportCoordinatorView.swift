import SwiftUI
import ComposableArchitecture
import TCACoordinators

struct ReportCoordinatorView: View {
    let store: StoreOf<ReportCoordinator>
    
    var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            switch(screen.case) {
            case let .reports(store):
                ReportsView(store: store)
            case let .calendar(store):
                ReportCalendarView(store: store)
            case let .filter(store):
                ReportFilterView(store: store)
            case let .filterProjects(store):
                ReportFilterProjectsView(store: store)
            }
        }
        
    }
    
    
}
